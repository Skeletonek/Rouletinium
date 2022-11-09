import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rouletinium/roulette.dart';
import 'package:roulette/roulette.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static final _random = Random();

  late RouletteController _rouletteController;
  late TextEditingController _textEditingController;
  bool _clockwise = true;
  List<String> list = [];

  final colors = <Color>[
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.yellow.withAlpha(90),
    Colors.amber.withAlpha(50),
    Colors.indigo.withAlpha(70),
  ];

  @override
  void initState() {
    final group = RouletteGroup.uniform(
      list.length,
      colorBuilder: colors.elementAt,
      textBuilder: list.elementAt,
    );
    _rouletteController = RouletteController(vsync: this, group: group);
    _textEditingController = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rouletinium"),
      ),
      body: Container(
        padding: const EdgeInsetsDirectional.all(20),
        decoration: BoxDecoration(
          color: Colors.pink.withOpacity(0.1),
        ),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        constraints: BoxConstraints(
                          maxWidth: 200,
                        )
                    ),
                    controller: _textEditingController,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          list.add(_textEditingController.text);
                          var group = RouletteGroup.uniform(
                            list.length,
                            colorBuilder: colors.elementAt,
                            textBuilder: list.elementAt,
                          );
                          _rouletteController.group = group;
                          _rouletteController.resetAnimation();
                        });
                      },
                      child: const Text(
                        "Dodaj"
                      )
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Zgodnie ze wskazówkami zegara: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: _clockwise,
                    onChanged: (onChanged) {
                      setState(() {
                        _rouletteController.resetAnimation();
                        _clockwise = !_clockwise;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: MyRoulette(
                  controller: _rouletteController
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Use the controller to run the animation with rollTo method
        onPressed: () => _rouletteController.rollTo(
          0,
          clockwise: _clockwise,
          offset: _random.nextDouble(),
        ),
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }

  List<Widget> objectsInListAsText() {
    List<Widget> widgets = [];

    for(int i = 0; i < list.length; i++) {
        widgets.add(Text(list[i]));
    }

    return widgets;
  }

  @override
  void dispose() {
    _rouletteController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}