// bin/toln.dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:toln/src/cli/extractor.dart';
import 'package:toln/src/cli/syncer.dart';
import 'package:toln/src/cli/auto_applier.dart';
import 'package:toln/src/cli/migrator.dart'; // Import the new Migrator

const String commandExtract = 'extract';
const String commandSync = 'sync';
const String commandAutoApply = 'auto-apply';
const String commandMigrate = 'migrate'; // Define the new migrate command name

final ArgParser argParser = ArgParser()
  ..addCommand(commandExtract)
  ..addCommand(commandSync)
  ..addCommand(
      commandAutoApply,
      ArgParser()
        ..addFlag('dry-run',
            negatable: false,
            help:
                'Shows which files would be changed without actually modifying them.'))
  ..addCommand(
      commandMigrate,
      ArgParser()
        ..addFlag('yes',
            abbr: 'y',
            negatable: false,
            help:
                'Skips the confirmation prompt before starting the migration.')); // Add the migrate command

void main(List<String> arguments) async {
  try {
    final ArgResults results = argParser.parse(arguments);
    final command = results.command;

    if (command == null) {
      printError(
          'No command specified. Available commands: extract, sync, auto-apply, migrate');
      exit(1);
    }

    final projectPath = Directory.current.path;

    switch (command.name) {
      case commandExtract:
        printInfo('Running ToLn Extractor...');
        await Extractor(projectPath).run();
        printSuccess('Extraction complete!');
        break;
      case commandSync:
        printInfo('Running ToLn Syncer...');
        await Syncer(projectPath).run();
        printSuccess('Sync complete!');
        break;
      case commandAutoApply:
        printInfo('Running ToLn Auto-Applier...');
        final dryRun = command['dry-run'] as bool;
        await AutoApplier(projectPath, dryRun: dryRun).run();

        if (!dryRun) {
          printInfo('----------------------------------------------------');
          printInfo('Auto-apply finished. Now running extractor...');
          await Extractor(projectPath).run();
          printSuccess(
              'SUCCESS! Your code is now localized and translation files are ready.');
        } else {
          printSuccess('Auto-apply dry-run finished. No files were changed.');
        }
        break;
      case commandMigrate: // Handle the new command
        printWarning(
            'WARNING: This is a destructive operation that will modify your source code.');
        printWarning(
            'It will convert .arb files to .ln and replace old localization calls.');
        printWarning(
            'Please make sure your project is under version control (e.g., Git).');

        final skipConfirmation = command['yes'] as bool;
        bool confirmed = false;

        if (skipConfirmation) {
          confirmed = true;
        } else {
          stdout.write('Are you sure you want to continue? (y/N): ');
          final answer = stdin.readLineSync()?.toLowerCase() ?? 'n';
          if (answer == 'y') {
            confirmed = true;
          }
        }

        if (confirmed) {
          printInfo('Starting migration process...');
          await Migrator(projectPath).run();
        } else {
          printInfo('Migration cancelled by user.');
        }
        break;
    }
  } on FormatException catch (e) {
    printError(e.message);
    stdout.writeln(argParser.usage);
    exit(1);
  } catch (e) {
    printError('An unexpected error occurred: ${e.toString()}');
    exit(1);
  }
}

void printError(String text) => stdout.writeln('\x1B[31m[ERROR] $text\x1B[0m');
void printInfo(String text) => stdout.writeln('\x1B[34m[INFO] $text\x1B[0m');
void printSuccess(String text) =>
    stdout.writeln('\x1B[32m[SUCCESS] $text\x1B[0m');
void printWarning(String text) =>
    stdout.writeln('\x1B[33m[WARNING] $text\x1B[0m');
