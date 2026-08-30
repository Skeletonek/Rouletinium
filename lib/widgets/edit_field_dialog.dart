import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditFieldDialog extends StatefulWidget {
  const EditFieldDialog({
    super.key,
    required this.initialText,
    required this.initialColor,
    required this.palette,
    required this.currentIndex,
    required this.fieldLabels,
    required this.fieldColors,
    required this.onSave,
    required this.onDelete,
    required this.onReorder,
  });

  final String initialText;
  final Color initialColor;
  final List<Color> palette;
  final int currentIndex;
  final List<String> fieldLabels;
  final List<Color> fieldColors;
  final void Function(String text, Color color) onSave;
  final VoidCallback onDelete;
  final void Function(int toIndex) onReorder;

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  late final TextEditingController _controller;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _selectedColor = widget.initialColor;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openColorPicker() {
    Color temp = _selectedColor;
    showDialog(
      context: context,
      builder: (pickerContext) {
        return AlertDialog(
          title: const Text("Wybierz kolor"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: temp,
              onColorChanged: (color) => temp = color,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.pop(pickerContext),
              child: const Text("Anuluj"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              onPressed: () {
                setState(() => _selectedColor = temp.withAlpha(140));
                Navigator.pop(pickerContext);
              },
              child: const Text("Wybierz"),
            ),
          ],
        );
      },
    );
  }

  void _openReorderPicker() {
    showDialog(
      context: context,
      builder: (pickerContext) {
        return AlertDialog(
          title: const Text("Przenieś do"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.fieldLabels.length,
              itemBuilder: (context, targetIndex) {
                final label = widget.fieldLabels[targetIndex];
                final isCurrent = targetIndex == widget.currentIndex;
                return ListTile(
                  enabled: !isCurrent,
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.fieldColors[targetIndex]
                          .withAlpha(isCurrent ? 80 : 255),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  title: Text(
                    isCurrent
                        ? "${label.isNotEmpty ? label : "Pole ${targetIndex + 1}"} (obecne)"
                        : (label.isNotEmpty ? label : "Pole ${targetIndex + 1}"),
                  ),
                  onTap: isCurrent
                      ? null
                      : () {
                          widget.onReorder(targetIndex);
                          Navigator.pop(pickerContext);
                          Navigator.pop(context);
                        },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.pop(pickerContext),
              child: const Text("Anuluj"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edytuj wpis"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            maxLength: 20,
            autofocus: true,
            decoration: const InputDecoration(
              constraints: BoxConstraints(
                maxWidth: double.infinity,
              ),
            ),
            onFieldSubmitted: (value) {
              widget.onSave(_controller.text, _selectedColor);
              Navigator.pop(context);
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
          const Text("Kolor"),
          const Padding(padding: EdgeInsets.symmetric(vertical: 6.0)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...widget.palette.map((color) {
                final selected = color.toARGB32() == _selectedColor.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: selected
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                );
              }),
              Builder(
                builder: (context) {
                  final isCustom = !widget.palette
                      .any((c) => c.toARGB32() == _selectedColor.toARGB32());
                  return GestureDetector(
                    onTap: _openColorPicker,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCustom ? _selectedColor : Colors.grey.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCustom ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: widget.onDelete,
          child: const Text("Usuń"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _openReorderPicker,
          child: const Text("Przenieś"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          onPressed: () {
            widget.onSave(_controller.text, _selectedColor);
            Navigator.pop(context);
          },
          child: const Text("Zapisz"),
        ),
      ],
    );
  }
}
