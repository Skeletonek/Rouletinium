import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'arrow.dart';

class CustomRoulette extends StatelessWidget {
  const CustomRoulette({
    super.key,
    required this.controller,
    required this.group,
  });

  final RouletteGroup group;
  final RouletteController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Roulette(
            group: group,
            controller: controller,
            style: const RouletteStyle(
                dividerThickness: 4,
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
