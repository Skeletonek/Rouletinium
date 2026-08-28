import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'arrow.dart';

class CustomRoulette extends StatelessWidget {
  const CustomRoulette({
    super.key,
    required this.controller,
    required this.group,
    this.onTap,
    this.onSpin,
  });

  final RouletteGroup group;
  final RouletteController controller;
  final void Function(int index)? onTap;
  final VoidCallback? onSpin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final borderColor = isDark ? Colors.white : Colors.black;

    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            TappableRoulette(
              group: group,
              controller: controller,
              onTap: onTap,
              style: RouletteStyle(
                dividerThickness: 4,
                textLayoutBias: .8,
                dividerColor: borderColor,
                centerStickerColor: const Color(0xFF45A3FA),
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Sans",
                  overflow: TextOverflow.ellipsis,
                  color: textColor,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: const Center(child: Arrow()),
            ),
            Center(
              child: GestureDetector(
                onTap: onSpin,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF45A3FA),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
