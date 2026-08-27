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
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: TappableRoulette(
            group: group,
            controller: controller,
            onTap: onTap,
            style: const RouletteStyle(
                dividerThickness: 6,
                textLayoutBias: .8,
                centerStickerColor: Color(0xFF45A3FA),
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Sans",
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white
                )
            ),
          ),
        ),
        const Arrow(),
      ],
    );
  }
}
