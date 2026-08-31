import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rouletinium/l10n/app_localizations.dart';
import 'package:rouletinium/models/saved_roulette.dart';
import 'package:rouletinium/models/update_info.dart';
import 'package:rouletinium/services/saved_roulettes_storage.dart';
import 'package:rouletinium/services/update_service.dart';
import 'package:rouletinium/widgets/about_dialog.dart';
import 'package:rouletinium/widgets/edit_field_dialog.dart';
import 'package:rouletinium/widgets/roulette.dart';
import 'package:rouletinium/widgets/save_roulette_dialog.dart';
import 'package:rouletinium/widgets/saved_roulettes_dialog.dart';
import 'package:rouletinium/widgets/update_dialog.dart';
import 'package:roulette/roulette.dart';

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
  List<Color> fieldColors = [];
  int _winnerIndex = 0;
  String _winnerLabel = '';
  bool _showWinnerLabel = false;
  Timer? _winnerTimer;
  final SavedRoulettesStorage _storage = SavedRoulettesStorage();
  String _lastSavedHash = '';
  UpdateInfo? _updateInfo;
  late final UpdateService _updateService;

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
      fieldColors.add(colors[fieldColors.length % colors.length]);
    }
    _rouletteGroup = RouletteGroup.uniform(
      list.length,
      colorBuilder: (i) => fieldColors[i],
      textBuilder: list.elementAt,
    );
    _rouletteController = RouletteController();
    _lastSavedHash = _currentHash();
    _updateService = UpdateService();
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    final info = await _updateService.checkForUpdate();
    if (!mounted || info == null) return;
    setState(() => _updateInfo = info);
  }

  String _currentHash() {
    final entries = List.generate(
        list.length, (i) => SavedEntry(text: list[i], color: fieldColors[i]));
    return SavedRoulette.encodeList([
      SavedRoulette(id: '', name: '', entries: entries, createdAt: DateTime.fromMillisecondsSinceEpoch(0))
    ]);
  }

  bool get _isDirty => _currentHash() != _lastSavedHash;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rouletinium"),
        actions: [
          PopupMenuButton(
            icon: Badge(
              isLabelVisible: _updateInfo != null,
              backgroundColor: Colors.red,
              smallSize: 8,
              child: const Icon(Icons.more_vert),
            ),
            itemBuilder: (context){
              final l10n = AppLocalizations.of(context);
              return <PopupMenuEntry<int>>[
                CheckedPopupMenuItem<int>(
                    value: 0,
                    checked: _clockwise,
                    child: Text(l10n.menuClockwise),
                ),
                const PopupMenuDivider(),
                CheckedPopupMenuItem<int>(
                  value: 2,
                  checked: widget.themeMode == ThemeMode.system,
                  child: Text(l10n.menuThemeSystem),
                ),
                CheckedPopupMenuItem<int>(
                  value: 3,
                  checked: widget.themeMode == ThemeMode.light,
                  child: Text(l10n.menuThemeLight),
                ),
                CheckedPopupMenuItem<int>(
                  value: 4,
                  checked: widget.themeMode == ThemeMode.dark,
                  child: Text(l10n.menuThemeDark),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 5,
                  child: Row(
                    children: [
                      const Icon(Icons.save_outlined, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(l10n.menuSaveRoulette)),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 6,
                  child: Row(
                    children: [
                      const Icon(Icons.list_alt_outlined, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(l10n.menuMyRoulettes)),
                    ],
                  ),
                ),
                if (_updateInfo != null) ...[
                  const PopupMenuDivider(),
                  PopupMenuItem<int>(
                    value: 7,
                    child: Row(
                      children: [
                        const Icon(Icons.system_update, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.menuUpdate)),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.menuAbout)),
                      ],
                    ),
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
                  showAboutRouletiniumDialog(context);
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
                case 5:
                  _saveRoulette();
                break;
                case 6:
                  _showMyRoulettes();
                break;
                case 7:
                  if (_updateInfo != null) {
                    showUpdateDialog(context, _updateInfo!);
                  }
                break;
              }
            },
          ),
        ]
      ),
      body: Container(
        padding: const EdgeInsetsDirectional.all(8),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomRoulette(
                      controller: _rouletteController,
                      group: _rouletteGroup,
                      onTap: _onSectorTapped,
                      onSpin: _spin,
                    ),
                    Positioned(
                      bottom: 50,
                      child: AnimatedOpacity(
                        opacity: _showWinnerLabel ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context).winnerTitle,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              Text(
                                _winnerLabel,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'clear',
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              onPressed: _showClearConfirmationDialog,
              child: const Icon(Icons.delete_sweep_outlined),
            ),
            FloatingActionButton(
              heroTag: 'add',
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: () {
                setState(() {
                  addItemButtonPressed();
                });
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _spin() async {
    _winnerIndex = _random.nextInt(list.length);
    final completed = await _rouletteController.rollTo(
      _winnerIndex,
      clockwise: _clockwise,
      offset: _random.nextDouble() * 0.9,
    );
    if (!completed || !mounted) return;
    final winner = list[_winnerIndex];
    if (winner.isNotEmpty) {
      _displayWinnerLabel(winner);
    }
  }

  void _displayWinnerLabel(String name) {
    _winnerTimer?.cancel();
    setState(() {
      _winnerLabel = name;
      _showWinnerLabel = true;
    });
    _winnerTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showWinnerLabel = false);
      _winnerTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _winnerLabel = '');
      });
    });
  }

  void _onSectorTapped(int index) {
    if (index >= list.length) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return EditFieldDialog(
          initialText: list[index],
          initialColor: fieldColors[index],
          palette: colors,
          currentIndex: index,
          fieldLabels: list,
          fieldColors: fieldColors,
          onSave: (text, color) {
            setState(() {
              list[index] = text;
              fieldColors[index] = color;
              assignGroupToRoulette();
            });
          },
          onReorder: (toIndex) {
            setState(() {
              reorderField(index, toIndex);
            });
          },
          onDelete: () {
            if (list.length <= 2) {
              Navigator.pop(dialogContext);
              showAlertDialog(
                AppLocalizations.of(context).errorTitle,
                AppLocalizations.of(context).errorCannotDeleteMore,
              );
              return;
            }
            setState(() {
              list.removeAt(index);
              fieldColors.removeAt(index);
              assignGroupToRoulette();
            });
            Navigator.pop(dialogContext);
          },
        );
      },
    );
  }

  void _showClearConfirmationDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.dialogConfirmTitle),
          content: Text(l10n.dialogConfirmClearContent),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  clearItemsButtonPressed();
                });
              },
              child: Text(l10n.clear),
            ),
          ],
        );
      },
    );
  }

  void addItemButtonPressed() {
    if (list.length >= kMaxFields) {
      final l10n = AppLocalizations.of(context);
      showAlertDialog(l10n.errorTitle, l10n.errorMaxFieldsReached(kMaxFields));
      return;
    }
    list.add("");
    fieldColors.add(colors[(list.length - 1) % colors.length]);
    assignGroupToRoulette();
  }

  void clearItemsButtonPressed() {
    list.clear();
    fieldColors.clear();
    while(list.length < 2){
      list.add("");
      fieldColors.add(colors[fieldColors.length % colors.length]);
    }
    assignGroupToRoulette();
  }

  void reorderField(int from, int to) {
    if (from == to) return;
    final text = list.removeAt(from);
    list.insert(to, text);
    final color = fieldColors.removeAt(from);
    fieldColors.insert(to, color);
    assignGroupToRoulette();
  }

  void assignGroupToRoulette() {
    var group = RouletteGroup.uniform(
      list.length,
      colorBuilder: (i) => fieldColors[i],
      textBuilder: list.elementAt,
    );
    _rouletteGroup = group;
    _rouletteController.resetAnimation();
  }

  Future<void> _saveRoulette() async {
    final l10n = AppLocalizations.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const SaveRouletteDialog(),
    );
    if (name == null || !mounted) return;
    final all = await _storage.loadAll();
    if (all.length >= SavedRoulettesStorage.kMaxSaved) {
      if (!mounted) return;
      showAlertDialog(l10n.errorTitle, l10n.errorMaxSavedReached(SavedRoulettesStorage.kMaxSaved));
      return;
    }
    final entries = List.generate(
        list.length, (i) => SavedEntry(text: list[i], color: fieldColors[i]));
    final saved = SavedRoulette(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      entries: entries,
      createdAt: DateTime.now(),
    );
    try {
      await _storage.save(saved);
    } on MaxSavedReachedException {
      if (!mounted) return;
      showAlertDialog(l10n.errorTitle, l10n.errorMaxSavedReached(SavedRoulettesStorage.kMaxSaved));
      return;
    }
    _lastSavedHash = _currentHash();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.rouletteSaved)),
    );
  }

  Future<void> _showMyRoulettes() async {
    final selected = await showSavedRoulettesDialog(context, storage: _storage);
    if (selected == null || !mounted) return;
    if (_isDirty) {
      final l10n = AppLocalizations.of(context);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.confirmLoadTitle),
          content: Text(l10n.confirmLoadContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.load),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    _loadRoulette(selected);
  }

  void _loadRoulette(SavedRoulette r) {
    setState(() {
      list = r.entries.map((e) => e.text).toList();
      fieldColors = r.entries.map((e) => e.color).toList();
      while (list.length < 2) {
        list.add('');
        fieldColors.add(colors[fieldColors.length % colors.length]);
      }
      assignGroupToRoulette();
    });
    _lastSavedHash = _currentHash();
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
              child: Text(AppLocalizations.of(context).ok)),
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
    _winnerTimer?.cancel();
    _rouletteController.dispose();
    _updateService.dispose();
    super.dispose();
  }
}
