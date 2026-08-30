import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rouletinium/l10n/app_localizations.dart';
import '../generated/versions.dart';
import '../utils/dart_version.dart' as dv;
import '../utils/user_agent.dart' as ua;

// Roulette package provenance — version comes from generated file
// (packages/roulette/pubspec.yaml via tool/generate_versions.dart).
const String kRouletteAuthor = 'do9core';
const String kRoulettePubUrl = 'https://pub.dev/packages/roulette';
const String kRouletteLicense = 'Apache License 2.0';
const String kRouletteForkUrl = 'https://github.com/Skeletonek/roulette';

String _platformLabel() {
  if (kIsWeb) return 'Web';
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'Android';
    case TargetPlatform.iOS:
      return 'iOS';
    case TargetPlatform.linux:
      return 'Linux';
    case TargetPlatform.windows:
      return 'Windows';
    case TargetPlatform.macOS:
      return 'macOS';
    case TargetPlatform.fuchsia:
      return 'Fuchsia';
  }
}

String _webUserAgent() => ua.getWebUserAgent();

Future<void> showAboutRouletiniumDialog(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final platform = _platformLabel();
  final userAgent = kIsWeb ? _webUserAgent() : '';
  final platformDisplay =
      userAgent.isNotEmpty ? '$platform\n$userAgent' : platform;

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (dialogContext) => _AboutRouletiniumDialog(
      packageInfo: packageInfo,
      platformDisplay: platformDisplay,
    ),
  );
}

class _AboutRouletiniumDialog extends StatelessWidget {
  const _AboutRouletiniumDialog({
    required this.packageInfo,
    required this.platformDisplay,
  });

  final PackageInfo packageInfo;
  final String platformDisplay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        children: [
          _AppIcon(size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rouletinium'),
                Text(
                  l10n.aboutVersion(packageInfo.version),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _AuthorIcon(size: 36),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.aboutAuthor,
                            style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                        const SelectableText('Skeletonek'),
                        SelectableText(
                          'contact@skeletonek.com',
                          style: theme.textTheme.bodySmall,
                        ),
                        SelectableText(
                          'gitlab.com/Skeletonek/Rouletinium',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              _InfoRow(
                icon: Icons.copyright_outlined,
                label: l10n.aboutCopyright,
                value: '\u00a9 2022\u20132026 Skeletonek',
              ),
              _InfoRow(
                icon: Icons.description_outlined,
                label: l10n.aboutLicense,
                value: l10n.aboutLicenseValue,
              ),
              _InfoRow(
                icon: Icons.flutter_dash,
                label: l10n.aboutFlutterDart,
                value:
                    'Flutter $kFlutterSdkVersion \u2022 Dart ${dv.getDartVersion()}',
              ),
              _InfoRow(
                icon: Icons.computer_outlined,
                label: l10n.aboutOsPlatform,
                value: platformDisplay,
              ),
              _InfoRow(
                icon: Icons.extension_outlined,
                label: l10n.aboutRoulettePackage,
                value:
                    'roulette $kRouletteVersion by $kRouletteAuthor\n$kRouletteLicense\nUpstream URL: $kRoulettePubUrl\nRouletinium Fork: $kRouletteForkUrl',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => showLicensePage(
            context: context,
            applicationName: 'Rouletinium',
            applicationVersion: 'v${packageInfo.version}+${packageInfo.buildNumber}',
            applicationIcon: const _AppIcon(size: 48),
            applicationLegalese: '\u00a9 2022\u20132026 Skeletonek \u2014 GPL-3.0',
          ),
          child: Text(l10n.licenses),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 2),
                SelectableText(
                  value,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    // Use the launcher source image; ensure `media/icon.png` is in
    // flutter.assets in pubspec.yaml. The same file is also copied to
    // `media/logo/` variants for other resolutions.
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'media/icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.casino_outlined,
            size: size * 0.6,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class _AuthorIcon extends StatelessWidget {
  const _AuthorIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'media/skeletonek.jpg',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
