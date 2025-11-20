// lib/src/cli/migrator.dart

import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p; // THE ULTIMATE FIX IS HERE!
import 'package:yaml/yaml.dart';
import 'package:toln/src/cli/models/l10n_config.dart';

/// A class to handle the migration from the standard Flutter localization
/// system (using .arb files) to the ToLn system.
class Migrator {
  final String projectPath;
  L10nConfig? _config;
  final Map<String, String> _keyToOriginalTextMap =
      {}; // arb_key -> text with {placeholders}
  final Map<String, String> _normalizedTextToKeyMap =
      {}; // text with $s -> arb_key
  bool _migrationHadErrors = false;

  Migrator(this.projectPath);

  /// Runs the entire migration process.
  Future<void> run() async {
    _config = await _readConfig();
    if (_config == null) {
      stdout.writeln(
          '\x1B[31m[ERROR]\x1B[0m l10n.yaml file not found. Cannot proceed.');
      exit(1);
    }
    stdout.writeln('\x1B[34m[INFO]\x1B[0m Found and parsed l10n.yaml.');

    await _convertArbFiles();
    stdout.writeln(
        '\x1B[32m[SUCCESS]\x1B[0m Successfully converted .arb files to .ln format.');

    await _refactorDartCode();

    if (_migrationHadErrors) {
      stdout.writeln(
          '\n\x1B[31m[MIGRATION FAILED]\x1B[0m Errors occurred during refactoring. The process was halted.');
      stdout.writeln(
          '\x1B[33m[ACTION REQUIRED]\x1B[0m Please check error messages and review the *.unformatted files.');
      stdout.writeln(
          '  No old files were deleted. It is safe to fix issues and run the migrator again, or revert changes.');
      exit(1);
    }

    stdout.writeln(
        '\x1B[32m[SUCCESS]\x1B[0m Successfully refactored all Dart code.');

    await _cleanupOldFiles();

    stdout.writeln(
        '\n\x1B[32m[MIGRATION COMPLETE]\x1B[0m Your project is now using ToLn!');
    stdout.writeln(
        '\x1B[33m[NEXT STEPS]\x1B[0m You can now safely delete the l10n.yaml file.');
  }

  Future<L10nConfig?> _readConfig() async {
    final configFile = File(p.join(projectPath, 'l10n.yaml'));
    if (!await configFile.exists()) return null;
    final content = await configFile.readAsString();
    final yamlMap = loadYaml(content) as YamlMap;
    return L10nConfig.fromYaml(yamlMap);
  }

  Future<void> _convertArbFiles() async {
    final arbDir = Directory(p.join(projectPath, _config!.arbDir));
    if (!await arbDir.exists()) {
      throw DirectoryNotFoundException(
          'The specified arb-dir "${_config!.arbDir}" does not exist.');
    }

    final localesDir = Directory(p.join(projectPath, 'assets', 'locales'));
    if (!await localesDir.exists()) {
      await localesDir.create(recursive: true);
    }

    final arbFiles = arbDir
        .listSync()
        .where((e) => e is File && e.path.endsWith('.arb'))
        .cast<File>();

    final templateArbFile = File(p.join(arbDir.path, _config!.templateArbFile));
    if (!await templateArbFile.exists()) {
      throw FileSystemException(
          'Template arb file not found at ${templateArbFile.path}');
    }

    final baseTranslations = await _processSingleArb(templateArbFile, true);
    final encoder = JsonEncoder.withIndent('  ');
    await File(p.join(localesDir.path, 'base.ln'))
        .writeAsString(encoder.convert(baseTranslations));
    await File(p.join(localesDir.path, 'key_map.ln'))
        .writeAsString(encoder.convert(_normalizedTextToKeyMap));

    for (final file in arbFiles) {
      if (p.basename(file.path) == _config!.templateArbFile) continue;
      final translations = await _processSingleArb(file, false);
      final localeCode = p.basenameWithoutExtension(file.path).split('_').last;
      await File(p.join(localesDir.path, '$localeCode.ln'))
          .writeAsString(encoder.convert(translations));
    }
  }

  Future<Map<String, String>> _processSingleArb(
      File arbFile, bool isBase) async {
    final content = await arbFile.readAsString();
    final arbMap = json.decode(content) as Map<String, dynamic>;
    final translations = <String, String>{};
    String? lnName;
    final placeholderRegex = RegExp(r'\{(\w+)\}');

    arbMap.forEach((key, value) {
      if (key.startsWith('@')) {
        return;
      }

      final String stringValue = value.toString();
      final normalizedValue = stringValue.replaceAll(placeholderRegex, r'$s');

      if (isBase) {
        _keyToOriginalTextMap[key] = stringValue;
        _normalizedTextToKeyMap[normalizedValue] = key;
        translations[key] = normalizedValue;
      } else {
        translations[key] = stringValue;
      }

      if (key == '@@locale') {
        lnName = stringValue;
      }
    });

    final localeCode = p.basenameWithoutExtension(arbFile.path).split('_').last;
    translations['ln_name'] = lnName ?? localeCode.toUpperCase();
    return translations;
  }

  Future<void> _refactorDartCode() async {
    final libDir = Directory(p.join(projectPath, 'lib'));
    final collection =
        AnalysisContextCollection(includedPaths: [libDir.absolute.path]);

    for (final context in collection.contexts) {
      for (final filePath in context.contextRoot.analyzedFiles()) {
        if (filePath.endsWith('.dart')) {
          await _processFile(filePath, context);
        }
      }
    }
  }

  Future<void> _processFile(String path, AnalysisContext context) async {
    final result = await context.currentSession.getResolvedUnit(path);
    if (result is! ResolvedUnitResult) return;

    final visitor = _MigrationVisitor(
      l10nClassName: _config!.outputClass,
      keyToOriginalTextMap: _keyToOriginalTextMap,
      l10nImportPath: _config!.outputLocalizationFile,
    );
    result.unit.visitChildren(visitor);

    if (visitor.modifications.isEmpty && !visitor.needsTolnImport) return;

    stdout.writeln(
        '  \x1B[33m[REFACTOR]\x1B[0m Found ${visitor.modifications.length} modification(s) in ${p.basename(path)}');

    String newContent = result.content;
    visitor.modifications.sort((a, b) => b.offset.compareTo(a.offset));
    for (final mod in visitor.modifications) {
      newContent = newContent.substring(0, mod.offset) +
          mod.replaceWith +
          newContent.substring(mod.offset + mod.length);
    }

    if (visitor.needsTolnImport && !visitor.tolnImportExists) {
      final parsedResult = context.currentSession.getParsedUnit(path);
      if (parsedResult is ParsedUnitResult) {
        final lastImport = parsedResult.unit.directives
            .whereType<ImportDirective>()
            .lastOrNull;
        final offset = lastImport?.end ?? 0;
        final text =
            '${offset > 0 ? '\n' : ''}import \'package:toln/toln.dart\';\n';
        newContent = newContent.substring(0, offset) +
            text +
            newContent.substring(offset);
      }
    }

    try {
      final formattedContent = DartFormatter().format(newContent);
      await File(path).writeAsString(formattedContent);
    } catch (e) {
      _migrationHadErrors = true;
      stdout.writeln(
          '  \x1B[31m[ERROR]\x1B[0m Could not format ${p.basename(path)}. There might be an issue with the refactoring.');
      stdout.writeln('  Error details: $e');
      final unformattedPath = '$path.unformatted';
      await File(unformattedPath).writeAsString(newContent);
      stdout.writeln(
          '  \x1B[34m[INFO]\x1B[0m Unformatted file saved as ${p.basename(unformattedPath)} for debugging.');
    }
  }

  Future<void> _cleanupOldFiles() async {
    stdout
        .writeln('\x1B[34m[INFO]\x1B[0m Cleaning up old localization files...');
    final arbDir = Directory(p.join(projectPath, _config!.arbDir));
    if (await arbDir.exists()) {
      await arbDir.delete(recursive: true);
      stdout
          .writeln('  \x1B[32m[DELETED]\x1B[0m Directory: ${_config!.arbDir}');
    }
    final l10nFile =
        File(p.join(projectPath, 'lib', _config!.outputLocalizationFile));
    if (await l10nFile.exists()) {
      await l10nFile.delete();
      stdout.writeln(
          '  \x1B[32m[DELETED]\x1B[0m File: ${p.join('lib', _config!.outputLocalizationFile)}');
    }
  }
}

class _MigrationVisitor extends RecursiveAstVisitor<void> {
  final String l10nClassName;
  final String l10nImportPath;
  final Map<String, String> keyToOriginalTextMap;
  final List<({int offset, int length, String replaceWith})> modifications = [];
  bool needsTolnImport = false;
  bool tolnImportExists = false;
  final Set<String> _l10nVarNames = {};

  _MigrationVisitor({
    required this.l10nClassName,
    required this.keyToOriginalTextMap,
    required this.l10nImportPath,
  });

  @override
  void visitImportDirective(ImportDirective node) {
    if (node.uri.stringValue == l10nImportPath) {
      modifications.add((
        offset: node.offset,
        length: node.end - node.offset,
        replaceWith: ''
      ));
    }
    if (node.uri.stringValue == 'package:toln/toln.dart') {
      tolnImportExists = true;
    }
    super.visitImportDirective(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final initializer = node.initializer;
    if (initializer != null && _isL10nStaticAccess(initializer)) {
      _l10nVarNames.add(node.name.lexeme);
      final parentStatement =
          node.thisOrAncestorOfType<VariableDeclarationStatement>();
      if (parentStatement != null) {
        modifications.add((
          offset: parentStatement.offset,
          length: parentStatement.end - parentStatement.offset,
          replaceWith: ''
        ));
      }
    }
    super.visitVariableDeclaration(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_isL10nCall(node)) {
      _addModificationFor(node);
      return;
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (_isL10nCall(node)) {
      if (node.parent is MethodInvocation &&
          _isL10nCall(node.parent as MethodInvocation)) {
        // Already handled by the parent MethodInvocation visitor
      } else {
        _addModificationFor(node);
      }
      return;
    }
    super.visitPropertyAccess(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final className = node.constructorName.type.element?.name;
    if (className == 'MaterialApp' || className == 'CupertinoApp') {
      _processAppWidget(node);
    }
    super.visitInstanceCreationExpression(node);
  }

  void _processAppWidget(InstanceCreationExpression node) {
    _removeDelegateFromList(
        node, 'localizationsDelegates', '$l10nClassName.delegate');
    _removeDelegateFromList(
        node, 'supportedLocales', '$l10nClassName.supportedLocales');
  }

  void _removeDelegateFromList(
      InstanceCreationExpression node, String listName, String delegateSource) {
    NamedExpression? arg;
    for (final argument
        in node.argumentList.arguments.whereType<NamedExpression>()) {
      if (argument.name.label.name == listName) {
        arg = argument;
        break;
      }
    }

    if (arg?.expression is ListLiteral) {
      final list = arg!.expression as ListLiteral;

      CollectionElement? delegate;
      for (final element in list.elements) {
        if (element.toSource().contains(delegateSource)) {
          delegate = element;
          break;
        }
      }

      if (delegate != null) {
        final startOffset = delegate.offset;
        final nextToken = delegate.endToken.next!;
        final endOffset =
            (nextToken.lexeme == ',') ? nextToken.end : delegate.end;

        modifications.add((
          offset: startOffset,
          length: endOffset - startOffset,
          replaceWith: ''
        ));
      }
    }
  }

  bool _isL10nStaticAccess(Expression expression) {
    final source = expression.toSource();
    return source.startsWith('$l10nClassName.of') ||
        source.startsWith('$l10nClassName.current');
  }

  bool _isL10nCall(Expression expression) {
    if (_isL10nStaticAccess(expression)) return true;

    Expression? target;
    if (expression is PropertyAccess) {
      target = expression.target;
    } else if (expression is MethodInvocation) {
      target = expression.target;
    }

    if (target != null && _l10nVarNames.contains(target.toSource())) {
      return true;
    }

    return false;
  }

  void _addModificationFor(Expression expression) {
    final AstNode? keyNode;
    NodeList<Expression>? arguments;

    if (expression is MethodInvocation) {
      keyNode = expression.methodName;
      arguments = expression.argumentList.arguments;
    } else if (expression is PropertyAccess) {
      keyNode = expression.propertyName;
      arguments = null;
    } else {
      return;
    }

    final String key = keyNode.toSource();
    String? textTemplate = keyToOriginalTextMap[key];
    if (textTemplate == null) return;

    needsTolnImport = true;
    final argSources = arguments?.map((arg) => arg.toSource()).toList() ?? [];
    final replacementString = _buildRobustString(textTemplate, argSources);

    modifications.add((
      offset: expression.offset,
      length: expression.end - expression.offset,
      replaceWith: '$replacementString.toLn()',
    ));
  }

  String _buildRobustString(String template, List<String> args) {
    String result = template;
    int i = 0;
    result = result.replaceAllMapped(RegExp(r'\{(\w+)\}'), (match) {
      if (i < args.length) {
        return '\${${args[i++]}}';
      }
      return match.group(0)!;
    });

    if (result.contains("'")) {
      if (result.contains('"')) {
        return "'''$result'''";
      }
      return '"$result"';
    }
    return "'$result'";
  }
}

class DirectoryNotFoundException implements Exception {
  final String message;
  const DirectoryNotFoundException(this.message);
  @override
  String toString() => 'DirectoryNotFoundException: $message';
}
