import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'arrow.dart';

class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final RouletteController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              controller: controller,
              style: const RouletteStyle(
                dividerThickness: 4,
                textLayoutBias: .8,
                centerStickerColor: Color(0xFF45A3FA),
              ),
            ),
          ),
        ),
        const Arrow(),
      ],
    );
  }
}
