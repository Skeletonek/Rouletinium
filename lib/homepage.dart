import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rouletinium/widgets/roulette.dart';
import 'package:roulette/roulette.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static final _random = Random();

  late RouletteController _rouletteController;
  late RouletteGroup _rouletteGroup;
  late TextEditingController _textEditingController;
  late FocusNode _textFocusNode;
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
      colors[i] = colors[i].withAlpha(140);
    }
    while(list.length < 2){
      list.add("");
    }
    _rouletteGroup = RouletteGroup.uniform(
      list.length,
      colorBuilder: colors.elementAt,
      textBuilder: list.elementAt,
    );
    list.clear();
    _rouletteController = RouletteController();
    _textEditingController = TextEditingController(text: "");
    _textFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rouletinium"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context){
              return [
                CheckedPopupMenuItem<int>(
                    value: 0,
                    checked: _clockwise,
                    child: const Text("Zgodnie ze wskazówkami zegara"),
                ),
                const PopupMenuItem<int>(
                    value: 1,
                    child: Text("O aplikacji"),
                ),
              ];
            },
            onSelected: (value){
              switch(value){
                case 0:
                  setState(() {
                    _rouletteController.resetAnimation();
                    _clockwise = !_clockwise;
                  });
                break;
                case 1:
                  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                    showAlertDialog("Rouletinium",
                        "Autor: Skeletonek\n"
                        "Wersja: ${packageInfo.version}");
                  });
                break;
              }
            },
          ),
        ]
      ),
      body: Container(
        padding: const EdgeInsetsDirectional.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                _winnerText
              ),
              Expanded(
                child: CustomRoulette(
                  controller: _rouletteController,
                  group: _rouletteGroup
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(140, 255, 0, 0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      minimumSize: const Size(96, 48),
                    ),
                    onPressed: () {
                      setState(() {
                        clearItemsButtonPressed();
                        _textEditingController.text = "";
                      });
                    },
                    child: const Text("Wyczyść")
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(140, 255, 150, 0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      minimumSize: const Size(96, 48),
                    ),
                    onPressed: () {
                      setState(() {
                        undoItemsButtonPressed();
                      });
                    },
                    child: const Text("Cofnij")
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
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
                    onFieldSubmitted: (value){
                      setState(() {
                        addItemButtonPressed();
                      });
                      _textEditingController.text = "";
                      _textFocusNode.requestFocus();
                    },
                    focusNode: _textFocusNode,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      minimumSize: const Size(96, 48),
                    ),
                    onPressed: () {
                      setState(() {
                        addItemButtonPressed();
                        _textEditingController.text = "";
                        _textFocusNode.requestFocus();
                      });
                    },
                    child: const Text("Dodaj")
                  ),
                ],
              ),
              Container(
                height: 64,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(list.length > 1) {
            _winnerIndex = _random.nextInt(list.length);
          } else {
            _winnerIndex = _random.nextInt(2);
          }
          _rouletteController.rollTo(
            _winnerIndex,
            clockwise: _clockwise,
            offset: _random.nextDouble() * 0.9,
          );
        },
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  void addItemButtonPressed() {
    try {
      list.add(_textEditingController.text);
      assignGroupToRoulette();
    } on RangeError {
      if(list.contains(_textEditingController.text)) {
        list.remove(_textEditingController.text);
      }
      showAlertDialog("Error", "Przekroczono limit możliwych wpisów.");
    }
  }

  void undoItemsButtonPressed() {
    if(list.isNotEmpty){
      list.removeLast();
      assignGroupToRoulette();
    } else {
      showAlertDialog("Error", "Nie można cofnąć dalej.");
    }
  }

  void clearItemsButtonPressed() {
    list.clear();
    assignGroupToRoulette();
  }

  void assignGroupToRoulette() {
    var additionalFieldToRemove = 0;
    while(list.length < 2){
      list.add("");
      additionalFieldToRemove++;
    }
    var group = RouletteGroup.uniform(
      list.length,
      colorBuilder: colors.elementAt,
      textBuilder: list.elementAt,
    );
    _rouletteGroup = group;
    _rouletteController.resetAnimation();
    while(additionalFieldToRemove > 0){
      list.removeLast();
      additionalFieldToRemove--;
    }
  }

  void showAlertDialog(String title, String content) {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
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
