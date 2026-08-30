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
  String aboutVersion(String version) {
    return 'v$version';
  }

  @override
  String get aboutAuthor => 'Author';

  @override
  String get aboutCopyright => 'Copyright';

  @override
  String get aboutLicense => 'License';

  @override
  String get aboutLicenseValue => 'GNU General Public License v3.0 (GPL-3.0)';

  @override
  String get aboutFlutterDart => 'Flutter / Dart SDK';

  @override
  String get aboutOsPlatform => 'OS / Platform';

  @override
  String get aboutRoulettePackage => 'Roulette package';

  @override
  String get licenses => 'Licenses';

  @override
  String get close => 'Close';
}
