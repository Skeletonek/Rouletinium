import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/update_info.dart';

Future<void> showUpdateDialog(BuildContext context, UpdateInfo info) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => _UpdateDialog(info: info),
  );
}

class _UpdateDialog extends StatelessWidget {
  const _UpdateDialog({required this.info});

  final UpdateInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.system_update,
              color: theme.colorScheme.primary, size: 28),
          const SizedBox(width: 10),
          Expanded(child: Text(l10n.updateTitle)),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.updateFromTo(info.currentVersion, info.latestVersion),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward,
                        size: 18,
                        color: theme.colorScheme.onPrimaryContainer),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.updateChangelog,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                constraints: const BoxConstraints(maxHeight: 320),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    info.changelog.isNotEmpty
                        ? info.changelog
                        : l10n.updateChangelogUnavailable,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.later),
        ),
        FilledButton.icon(
          onPressed: () async {
            final uri = Uri.tryParse(info.downloadUrl);
            if (uri == null) return;
            try {
              final launched = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              if (!launched && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch ${info.downloadUrl}')),
                );
              }
            } catch (_) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch ${info.downloadUrl}')),
                );
              }
            }
          },
          icon: const Icon(Icons.open_in_new, size: 18),
          label: Text(l10n.download),
        ),
      ],
    );
  }
}
