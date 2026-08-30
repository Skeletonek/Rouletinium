#!/usr/bin/env dart
// Generates lib/generated/versions.dart from .fvmrc and packages/roulette/pubspec.yaml.
// Run with: dart tool/generate_versions.dart
// This keeps Flutter/Roulette versions in sync without manual hardcoding.

import 'dart:convert';
import 'dart:io';

void main() {
  final fvmrcFile = File('.fvmrc');
  if (!fvmrcFile.existsSync()) {
    stderr.writeln('Missing .fvmrc');
    exit(1);
  }
  final fvmrc = jsonDecode(fvmrcFile.readAsStringSync()) as Map<String, dynamic>;
  final flutterVersion = fvmrc['flutter'] as String? ?? 'unknown';

  final roulettePubspec = File('packages/roulette/pubspec.yaml');
  if (!roulettePubspec.existsSync()) {
    stderr.writeln('Missing packages/roulette/pubspec.yaml');
    exit(1);
  }
  final yaml = roulettePubspec.readAsStringSync();
  final match = RegExp(r'^version:\s*([^\s#]+)', multiLine: true).firstMatch(yaml);
  final rouletteVersion = match?.group(1)?.trim() ?? 'unknown';

  final outDir = Directory('lib/generated');
  outDir.createSync(recursive: true);
  final outFile = File('lib/generated/versions.dart');
  outFile.writeAsStringSync('''
// GENERATED — do not edit by hand.
// Run `dart tool/generate_versions.dart` to regenerate.
// Source: .fvmrc (flutter) and packages/roulette/pubspec.yaml (roulette).

const String kFlutterSdkVersion = '$flutterVersion';
const String kRouletteVersion = '$rouletteVersion';
''');
  stdout.writeln('Generated lib/generated/versions.dart:');
  stdout.writeln('  kFlutterSdkVersion = $flutterVersion');
  stdout.writeln('  kRouletteVersion = $rouletteVersion');
}
