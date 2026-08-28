import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rouletinium/widgets/roulette.dart';
import 'package:roulette/roulette.dart';
import 'package:package_info_plus/package_info_plus.dart';

const int kMaxFields = 30;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static final _random = Random();

  late RouletteController _rouletteController;
  late RouletteGroup _rouletteGroup;
  bool _clockwise = true;
  List<String> list = [];
  int _winnerIndex = 0;

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
      colorBuilder: (i) => colors[i % colors.length],
      textBuilder: list.elementAt,
    );
    _rouletteController = RouletteController();
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
              return <PopupMenuEntry<int>>[
                CheckedPopupMenuItem<int>(
                    value: 0,
                    checked: _clockwise,
                    child: const Text("Zgodnie ze wskazówkami zegara"),
                ),
                const PopupMenuDivider(),
                CheckedPopupMenuItem<int>(
                  value: 2,
                  checked: widget.themeMode == ThemeMode.system,
                  child: const Text("Motyw: Systemowy"),
                ),
                CheckedPopupMenuItem<int>(
                  value: 3,
                  checked: widget.themeMode == ThemeMode.light,
                  child: const Text("Motyw: Jasny"),
                ),
                CheckedPopupMenuItem<int>(
                  value: 4,
                  checked: widget.themeMode == ThemeMode.dark,
                  child: const Text("Motyw: Ciemny"),
                ),
                const PopupMenuDivider(),
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
                case 2:
                  widget.onThemeModeChanged(ThemeMode.system);
                break;
                case 3:
                  widget.onThemeModeChanged(ThemeMode.light);
                break;
                case 4:
                  widget.onThemeModeChanged(ThemeMode.dark);
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
              Expanded(
                child: CustomRoulette(
                  controller: _rouletteController,
                  group: _rouletteGroup,
                  onTap: _onSectorTapped,
                  onSpin: _spin,
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
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text("Potwierdź"),
                            content: const Text(
                                "Czy na pewno chcesz wyczyścić wszystkie pola?"),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: const Text("Anuluj"),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                      140, 255, 0, 0),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  setState(() {
                                    clearItemsButtonPressed();
                                  });
                                },
                                child: const Text("Wyczyść"),
                              ),
                            ],
                          );
                        },
                      );
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
    );
  }

  void _spin() {
    _winnerIndex = _random.nextInt(list.length);
    _rouletteController.rollTo(
      _winnerIndex,
      clockwise: _clockwise,
      offset: _random.nextDouble() * 0.9,
    );
  }

  void _onSectorTapped(int index) {
    if (index >= list.length) return;

    final TextEditingController editController =
        TextEditingController(text: list[index]);
    final FocusNode editFocusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Edytuj wpis"),
          content: TextFormField(
            controller: editController,
            focusNode: editFocusNode,
            maxLength: 20,
            autofocus: true,
            decoration: const InputDecoration(
              constraints: BoxConstraints(
                maxWidth: 200,
              ),
            ),
            onFieldSubmitted: (value) {
              setState(() {
                list[index] = editController.text;
                assignGroupToRoulette();
              });
              Navigator.pop(dialogContext);
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(140, 255, 0, 0),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (list.length <= 2) {
                  Navigator.pop(dialogContext);
                  showAlertDialog(
                      "Error", "Nie można usunąć więcej pól.");
                  return;
                }
                setState(() {
                  list.removeAt(index);
                  assignGroupToRoulette();
                });
                Navigator.pop(dialogContext);
              },
              child: const Text("Usuń"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  list[index] = editController.text;
                  assignGroupToRoulette();
                });
                Navigator.pop(dialogContext);
              },
              child: const Text("Zapisz"),
            ),
          ],
        );
      },
    );
  }

  void addItemButtonPressed() {
    if (list.length >= kMaxFields) {
      showAlertDialog("Error", "Osiągnięto maksymalną liczbę pól ($kMaxFields).");
      return;
    }
    list.add("");
    assignGroupToRoulette();
  }

  void undoItemsButtonPressed() {
    if(list.length > 2){
      list.removeLast();
      assignGroupToRoulette();
    } else {
      showAlertDialog("Error", "Nie można cofnąć dalej.");
    }
  }

  void clearItemsButtonPressed() {
    list.clear();
    while(list.length < 2){
      list.add("");
    }
    assignGroupToRoulette();
  }

  void assignGroupToRoulette() {
    var group = RouletteGroup.uniform(
      list.length,
      colorBuilder: (i) => colors[i % colors.length],
      textBuilder: list.elementAt,
    );
    _rouletteGroup = group;
    _rouletteController.resetAnimation();
  }

  void showAlertDialog(String title, String content) {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(content),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
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

  @override
  void dispose() {
    _rouletteController.dispose();
    super.dispose();
  }
}
