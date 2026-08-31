// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get menuClockwise => 'Clockwise';

  @override
  String get menuThemeSystem => 'Theme: System';

  @override
  String get menuThemeLight => 'Theme: Light';

  @override
  String get menuThemeDark => 'Theme: Dark';

  @override
  String get menuAbout => 'About';

  @override
  String get winnerTitle => 'Winner:';

  @override
  String get dialogConfirmTitle => 'Confirm';

  @override
  String get dialogConfirmClearContent =>
      'Are you sure you want to clear all fields?';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get errorTitle => 'Error';

  @override
  String get errorCannotDeleteMore => 'Cannot delete any more fields.';

  @override
  String errorMaxFieldsReached(int count) {
    return 'Maximum number of fields reached ($count).';
  }

  @override
  String get ok => 'Ok';

  @override
  String get chooseColorTitle => 'Choose color';

  @override
  String get chooseColorSelect => 'Select';

  @override
  String get moveToTitle => 'Move to';

  @override
  String fieldFallback(int number) {
    return 'Field $number';
  }

  @override
  String get currentSuffix => '(current)';

  @override
  String get editEntryTitle => 'Edit entry';

  @override
  String get colorLabel => 'Color';

  @override
  String get delete => 'Delete';

  @override
  String get move => 'Move';

  @override
  String get save => 'Save';

  @override
  String get aboutAuthor => 'Author';

  @override
  String get aboutCopyright => 'Copyright';

  @override
  String get aboutLicense => 'License';

  @override
  String get aboutOsPlatform => 'OS / Platform';

  @override
  String get aboutRoulettePackage => 'Roulette package';

  @override
  String get licenses => 'Licenses';

  @override
  String get close => 'Close';

  @override
  String get menuSaveRoulette => 'Save roulette';

  @override
  String get menuMyRoulettes => 'My roulettes';

  @override
  String get saveRouletteTitle => 'Save roulette';

  @override
  String get saveRouletteHint => 'Roulette name';

  @override
  String get savedRoulettesTitle => 'My roulettes';

  @override
  String get noSavedRoulettes => 'No saved roulettes yet.';

  @override
  String get rouletteSaved => 'Roulette saved.';

  @override
  String errorMaxSavedReached(int count) {
    return 'Maximum number of saved roulettes reached ($count).';
  }

  @override
  String get confirmLoadTitle => 'Load roulette?';

  @override
  String get confirmLoadContent =>
      'Current roulette has unsaved changes. Load anyway?';

  @override
  String get load => 'Load';

  @override
  String fallbackRouletteName(String date) {
    return 'Roulette $date';
  }

  @override
  String confirmDeleteRoulette(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String fieldsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fields',
      one: '1 field',
    );
    return '$_temp0';
  }

  @override
  String get menuUpdate => 'Update available';

  @override
  String get updateTitle => 'Update available';

  @override
  String updateFromTo(String from, String to) {
    return 'Update from $from to $to';
  }

  @override
  String get updateChangelog => 'Changelog';

  @override
  String get updateChangelogUnavailable => 'Changelog unavailable.';

  @override
  String get download => 'Download';

  @override
  String get later => 'Later';
}
