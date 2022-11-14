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
      alignment: AlignmentDirectional.topCenter,
      children: [
        const Arrow(),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Roulette(
            controller: controller,
            style: const RouletteStyle(
                dividerThickness: 4,
                textLayoutBias: .8,
                centerStickerColor: Color(0xFF45A3FA),
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Sans",
                )
            ),
          ),
        ),
      ],
    );
  }
}
