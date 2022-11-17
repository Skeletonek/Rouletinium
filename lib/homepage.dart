import 'dart:math';
import 'dart:async';
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
  String _winnerText = "";
  List<String> list = [];
  int _winnerIndex = 0;
  Timer? _timer;

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
              Text(
                  _winnerText
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        constraints: BoxConstraints(
                          maxWidth: 200,
                        )
                    ),
                    maxLength: 20,
                    controller: _textEditingController,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          addItemButtonPressed();
                          _textEditingController.text = "";
                        });
                      },
                      child: const Text("Dodaj")
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          clearItemsButtonPressed();
                          _textEditingController.text = "";
                        });
                      },
                      child: const Text("Wyczyść")
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
        onPressed: () {
          _winnerIndex = _random.nextInt(list.length);
          _rouletteController.rollTo(
          _winnerIndex,
          clockwise: _clockwise,
          offset: _random.nextDouble() * 0.9,
          );
        },
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }

  void addItemButtonPressed() {
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
  }

  void clearItemsButtonPressed() {
    list.clear();
    var group = RouletteGroup.uniform(
      list.length,
      colorBuilder: colors.elementAt,
      textBuilder: list.elementAt,
    );
    _rouletteController.group = group;
    _rouletteController.resetAnimation();
  }

  List<Widget> objectsInListAsText() {
    List<Widget> widgets = [];

    for(int i = 0; i < list.length; i++) {
      widgets.add(Text(list[i]));
    }

    return widgets;
  }

  void startTimer() {
    _timer = Timer.periodic(
        const Duration(seconds: 3),
            (timer) => setState(
                () {
                  print("Fired!");
              _winnerText = list[_winnerIndex];
              _timer?.cancel();
            }
        ));
  }

  @override
  void dispose() {
    _rouletteController.dispose();
    _textEditingController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}