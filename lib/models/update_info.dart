class UpdateInfo {
  const UpdateInfo({
    required this.currentVersion,
    required this.currentBuild,
    required this.latestVersion,
    required this.latestBuild,
    required this.downloadUrl,
    required this.changelog,
  });

  final String currentVersion;
  final int currentBuild;
  final String latestVersion;
  final int latestBuild;
  final String downloadUrl;
  final String changelog;
}
