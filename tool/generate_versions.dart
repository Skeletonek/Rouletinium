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

  // Also generate version.json for update checker (server.skeletonek.com)
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr.writeln('Missing pubspec.yaml');
    exit(1);
  }
  final pubspec = pubspecFile.readAsStringSync();
  final verMatch = RegExp(r'^version:\s*([^\s#]+)', multiLine: true).firstMatch(pubspec);
  final fullVersion = verMatch?.group(1)?.trim() ?? '1.0.0+100';
  final parts = fullVersion.split('+');
  final versionName = parts[0];
  final buildStr = parts.length > 1 ? parts[1] : '100';
  final buildNumber = int.tryParse(buildStr) ?? 0;

  final versionJson = {
    'version': versionName,
    'buildNumber': buildNumber,
    'downloadUrl': 'https://gitlab.com/Skeletonek/Rouletinium/-/releases',
    'changelogUrl': 'https://server.skeletonek.com/app/rouletinium/CHANGELOG.md',
  };
  final encoder = JsonEncoder.withIndent('  ');
  File('version.json').writeAsStringSync('${encoder.convert(versionJson)}\n');
  stdout.writeln('Generated version.json:');
  stdout.writeln('  version = $versionName');
  stdout.writeln('  buildNumber = $buildNumber');
}
