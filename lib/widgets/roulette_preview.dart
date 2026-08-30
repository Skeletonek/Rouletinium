import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import '../models/saved_roulette.dart';

class RoulettePreview extends StatelessWidget {
  const RoulettePreview({
    super.key,
    required this.saved,
    this.size = 120,
  });

  final SavedRoulette saved;
  final double size;

  @override
  Widget build(BuildContext context) {
    final group = saved.toGroup();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final borderColor = isDark ? Colors.white : Colors.grey.shade800;

    return SizedBox(
      width: size,
      height: size,
      child: IgnorePointer(
        child: RoulettePaint(
          group: group,
          rotation: 0,
          imageInfos: const {},
          style: RouletteStyle(
            dividerThickness: 3,
            dividerColor: borderColor,
            centerStickerColor: const Color(0xFF45A3FA),
            textLayoutBias: 0.8,
            textPadding: 4,
            maxTextFontSize: 10,
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Sans',
              overflow: TextOverflow.ellipsis,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
