import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'arrow.dart';

class CustomRoulette extends StatelessWidget {
  const CustomRoulette({
    super.key,
    required this.controller,
    required this.group,
    this.onTap,
  });

  final RouletteGroup group;
  final RouletteController controller;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final borderColor = isDark ? Colors.white : Colors.black;

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: TappableRoulette(
            group: group,
            controller: controller,
            onTap: onTap,
            style: RouletteStyle(
              dividerThickness: 6,
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
        ),
        const Arrow(),
      ],
    );
  }
}
