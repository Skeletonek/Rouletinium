import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/update_info.dart';

class UpdateService {
  UpdateService({
    http.Client? httpClient,
    Future<PackageInfo> Function()? packageInfoProvider,
  })  : _client = httpClient ?? http.Client(),
        _packageInfoProvider = packageInfoProvider ?? PackageInfo.fromPlatform;

  static const String _versionUrl =
      'https://server.skeletonek.com/app/rouletinium/version.json';

  final http.Client _client;
  final Future<PackageInfo> Function() _packageInfoProvider;

  /// Checks for an update on startup. Returns [UpdateInfo] if a newer build
  /// is available, otherwise `null`. Never throws — all errors are swallowed.
  /// On web always returns `null`.
  Future<UpdateInfo?> checkForUpdate() async {
    if (kIsWeb) return null;
    try {
      final packageInfo = await _packageInfoProvider();
      final currentVersion = packageInfo.version;
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;

      final versionResp = await _client
          .get(Uri.parse(_versionUrl))
          .timeout(const Duration(seconds: 5));
      if (versionResp.statusCode != 200) return null;

      final Map<String, dynamic> json =
          jsonDecode(versionResp.body) as Map<String, dynamic>;

      final latestVersion = (json['version'] as String?)?.trim() ?? '';
      final latestBuildRaw = json['buildNumber'];
      final int latestBuild = latestBuildRaw is int
          ? latestBuildRaw
          : int.tryParse(latestBuildRaw.toString()) ?? 0;
      final downloadUrl = (json['downloadUrl'] as String?)?.trim() ?? '';
      final changelogUrl = (json['changelogUrl'] as String?)?.trim() ?? '';

      if (latestVersion.isEmpty || latestBuild == 0) return null;
      if (latestBuild <= currentBuild) return null;
      if (downloadUrl.isEmpty) return null;

      String changelog = '';
      if (changelogUrl.isNotEmpty) {
        try {
          final changelogResp = await _client
              .get(Uri.parse(changelogUrl))
              .timeout(const Duration(seconds: 5));
          if (changelogResp.statusCode == 200) {
            changelog = filterChangelog(
              changelogResp.body,
              currentVersion,
            );
          }
        } catch (_) {
          // ignore changelog fetch errors — still report update
        }
      }

      return UpdateInfo(
        currentVersion: currentVersion,
        currentBuild: currentBuild,
        latestVersion: latestVersion,
        latestBuild: latestBuild,
        downloadUrl: downloadUrl,
        changelog: changelog,
      );
    } catch (_) {
      return null;
    }
  }

  /// Filters [rawChangelog] to only include sections newer than
  /// [currentVersion]. Changelog is expected to have descending
  /// `### version` headers (as in repo CHANGELOG.md).
  ///
  /// If no header matches [currentVersion], returns all sections whose
  /// header version is semantically newer than [currentVersion] using
  /// simple version comparison; falls back to full changelog.
  @visibleForTesting
  static String filterChangelog(String rawChangelog, String currentVersion) {
    if (rawChangelog.trim().isEmpty) return '';
    final lines = rawChangelog.split('\n');
    final headerRegex = RegExp(r'^###\s+(.+)$');

    // Collect header indices
    final headers = <int>[];
    final headerVersions = <String>[];
    for (var i = 0; i < lines.length; i++) {
      final m = headerRegex.firstMatch(lines[i].trim());
      if (m != null) {
        headers.add(i);
        final v = m.group(1)!.trim().split(RegExp(r'\s+')).first;
        headerVersions.add(v);
      }
    }
    if (headers.isEmpty) return rawChangelog.trim();

    // Exact match on currentVersion
    final exactIdx = headerVersions.indexWhere((v) => v == currentVersion);
    if (exactIdx != -1) {
      if (exactIdx == 0) return '';
      final endLine = headers[exactIdx];
      return lines.sublist(0, endLine).join('\n').trim();
    }

    // Fallback: semantic version compare — include headers with version > current
    String normalize(String v) => v.trim().replaceAll(RegExp(r'^v'), '');
    int compareVersions(String a, String b) {
      final pa = normalize(a).split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final pb = normalize(b).split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final len = pa.length > pb.length ? pa.length : pb.length;
      for (var i = 0; i < len; i++) {
        final av = i < pa.length ? pa[i] : 0;
        final bv = i < pb.length ? pb[i] : 0;
        if (av != bv) return av.compareTo(bv);
      }
      return 0;
    }

    final newerHeaderIndices = <int>[];
    for (var i = 0; i < headerVersions.length; i++) {
      if (compareVersions(headerVersions[i], currentVersion) > 0) {
        newerHeaderIndices.add(i);
      }
    }
    if (newerHeaderIndices.isEmpty) return rawChangelog.trim();
    // Include from start up to the line before first non-newer header
    final nextNonNewer = headerVersions.indexWhere(
      (v) => compareVersions(v, currentVersion) <= 0,
    );
    if (nextNonNewer == -1) return rawChangelog.trim();
    final endLine = headers[nextNonNewer];
    return lines.sublist(0, endLine).join('\n').trim();
  }

  void dispose() => _client.close();
}
