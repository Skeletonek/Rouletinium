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
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.amber,
    Colors.indigo,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.greenAccent,
    Colors.lime,
    Colors.purple,
    Colors.deepPurple
  ];

  @override
  void initState() {
    for(int i = 0; i < colors.length; i++) {
      colors[i] = colors[i].withAlpha(70);
    }
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
                          try {
                            list.add(_textEditingController.text);
                            var group = RouletteGroup.uniform(
                              list.length,
                              colorBuilder: colors.elementAt,
                              textBuilder: list.elementAt,
                            );
                            _rouletteController.group = group;
                            _rouletteController.resetAnimation();
                          } catch (e) {
                            if(list.contains(_textEditingController.text)) {
                              list.remove(_textEditingController.text);
                            }

                            AlertDialog dialog = AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Przekroczono limit możliwych wpisów"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok")),
                              ],
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return dialog;
                                });
                          }
                        });
                      },
                      child: const Text("Dodaj")
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
        onPressed: () => _rouletteController.rollTo(
          _random.nextInt(list.length),
          clockwise: _clockwise,
          offset: _random.nextDouble() * 0.9,
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