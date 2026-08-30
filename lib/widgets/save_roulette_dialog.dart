import 'package:flutter/material.dart';
import 'package:rouletinium/l10n/app_localizations.dart';

class SaveRouletteDialog extends StatefulWidget {
  const SaveRouletteDialog({super.key});

  @override
  State<SaveRouletteDialog> createState() => _SaveRouletteDialogState();
}

class _SaveRouletteDialogState extends State<SaveRouletteDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.saveRouletteTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 30,
        decoration: InputDecoration(
          hintText: l10n.saveRouletteHint,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (v) => _submit(v, l10n),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          onPressed: () => _submit(_controller.text, l10n),
          child: Text(l10n.save),
        ),
      ],
    );
  }

  void _submit(String raw, AppLocalizations l10n) {
    var name = raw.trim();
    if (name.isEmpty) {
      final now = DateTime.now();
      final date =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      name = l10n.fallbackRouletteName(date);
    }
    Navigator.pop(context, name);
  }
}
