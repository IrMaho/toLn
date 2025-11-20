// lib/src/cli/models/l10n_config.dart

import 'package:yaml/yaml.dart';

/// A data class to hold the configuration from the l10n.yaml file.
class L10nConfig {
  /// The directory where the .arb files are located.
  /// e.g., 'lib/l10n'
  final String arbDir;

  /// The name of the template .arb file.
  /// e.g., 'app_en.arb'
  final String templateArbFile;

  /// The name of the output localization file.
  /// e.g., 'l10n.dart'
  final String outputLocalizationFile;

  /// The name of the generated localization class.
  /// e.g., 'S'
  final String outputClass;

  L10nConfig({
    required this.arbDir,
    required this.templateArbFile,
    required this.outputLocalizationFile,
    required this.outputClass,
  });

  /// Creates an instance from a parsed YAML map.
  factory L10nConfig.fromYaml(YamlMap yamlMap) {
    return L10nConfig(
      arbDir: yamlMap['arb-dir'] as String? ?? 'lib/l10n',
      templateArbFile: yamlMap['template-arb-file'] as String? ?? 'app_en.arb',
      outputLocalizationFile:
          yamlMap['output-localization-file'] as String? ?? 'l10n.dart',
      outputClass: yamlMap['output-class'] as String? ?? 'S',
    );
  }
}
