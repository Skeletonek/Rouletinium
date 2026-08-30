import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rouletinium/l10n/app_localizations.dart';
import '../models/saved_roulette.dart';
import '../services/saved_roulettes_storage.dart';
import 'roulette_preview.dart';

Future<SavedRoulette?> showSavedRoulettesDialog(
  BuildContext context, {
  required SavedRoulettesStorage storage,
}) {
  return showDialog<SavedRoulette>(
    context: context,
    builder: (ctx) => _SavedRoulettesDialog(storage: storage),
  );
}

class _SavedRoulettesDialog extends StatefulWidget {
  const _SavedRoulettesDialog({required this.storage});

  final SavedRoulettesStorage storage;

  @override
  State<_SavedRoulettesDialog> createState() => _SavedRoulettesDialogState();
}

class _SavedRoulettesDialogState extends State<_SavedRoulettesDialog> {
  late Future<List<SavedRoulette>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.storage.loadAll();
  }

  void _reload() {
    setState(() {
      _future = widget.storage.loadAll();
    });
  }

  Future<void> _confirmDelete(SavedRoulette r) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.dialogConfirmTitle),
        content: Text(l10n.confirmDeleteRoulette(r.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.storage.delete(r.id);
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.savedRoulettesTitle),
      content: SizedBox(
        width: 520,
        child: FutureBuilder<List<SavedRoulette>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return SizedBox(
                height: 80,
                child: Center(child: Text(l10n.noSavedRoulettes)),
              );
            }
            // Newest first
            final sorted = [...items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: sorted.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final r = sorted[index];
                  final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(r.createdAt);
                  final subtitle = '${l10n.fieldsCount(r.entries.length)} \u2022 $dateStr';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        RoulettePreview(saved: r, size: 110),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(subtitle,
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                r.entries.map((e) => e.text.isEmpty ? '—' : e.text).join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, r),
                              child: Text(l10n.load),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: l10n.delete,
                              onPressed: () => _confirmDelete(r),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
