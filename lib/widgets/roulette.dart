import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'arrow.dart';

class MyRoulette extends StatefulWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final RouletteController controller;

  @override
  State<MyRoulette> createState() => _MyRouletteState();
}

class _MyRouletteState extends State<MyRoulette> {
  final _roulette = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: RouletteTapWrapper(
              controller: widget.controller,
              rouletteKey: _roulette,
              onTap: (index) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Tap gesture detector'),
                      content: Text('You have tapped part at $index'),
                    );
                  },
                );
              },
              builder: (context, controller) {
                return Roulette(
                  key: _roulette,
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
                );
              }
          ),
        ),
        const Arrow(),
      ],
    );
  }
}
