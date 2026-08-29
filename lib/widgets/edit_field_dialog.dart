import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditFieldDialog extends StatefulWidget {
  const EditFieldDialog({
    super.key,
    required this.initialText,
    required this.initialColor,
    required this.palette,
    required this.onSave,
    required this.onDelete,
  });

  final String initialText;
  final Color initialColor;
  final List<Color> palette;
  final void Function(String text, Color color) onSave;
  final VoidCallback onDelete;

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
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
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
              }).toList(),
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
            backgroundColor: const Color.fromARGB(140, 255, 0, 0),
            foregroundColor: Colors.white,
          ),
          onPressed: widget.onDelete,
          child: const Text("Usuń"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
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
