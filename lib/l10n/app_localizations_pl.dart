// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get menuClockwise => 'Zgodnie ze wskazówkami zegara';

  @override
  String get menuThemeSystem => 'Motyw: Systemowy';

  @override
  String get menuThemeLight => 'Motyw: Jasny';

  @override
  String get menuThemeDark => 'Motyw: Ciemny';

  @override
  String get menuAbout => 'O aplikacji';

  @override
  String get winnerTitle => 'Zwycięzca:';

  @override
  String get dialogConfirmTitle => 'Potwierdź';

  @override
  String get dialogConfirmClearContent =>
      'Czy na pewno chcesz wyczyścić wszystkie pola?';

  @override
  String get cancel => 'Anuluj';

  @override
  String get clear => 'Wyczyść';

  @override
  String get errorTitle => 'Błąd';

  @override
  String get errorCannotDeleteMore => 'Nie można usunąć więcej pól.';

  @override
  String errorMaxFieldsReached(int count) {
    return 'Osiągnięto maksymalną liczbę pól ($count).';
  }

  @override
  String get ok => 'Ok';

  @override
  String get chooseColorTitle => 'Wybierz kolor';

  @override
  String get chooseColorSelect => 'Wybierz';

  @override
  String get moveToTitle => 'Przenieś do';

  @override
  String fieldFallback(int number) {
    return 'Pole $number';
  }

  @override
  String get currentSuffix => '(obecne)';

  @override
  String get editEntryTitle => 'Edytuj wpis';

  @override
  String get colorLabel => 'Kolor';

  @override
  String get delete => 'Usuń';

  @override
  String get move => 'Przenieś';

  @override
  String get save => 'Zapisz';

  @override
  String get aboutAuthor => 'Autor';

  @override
  String get aboutCopyright => 'Prawa autorskie';

  @override
  String get aboutLicense => 'Licencja';

  @override
  String get aboutOsPlatform => 'OS / Platforma';

  @override
  String get aboutRoulettePackage => 'Pakiet roulette';

  @override
  String get licenses => 'Licencje';

  @override
  String get close => 'Zamknij';
}
