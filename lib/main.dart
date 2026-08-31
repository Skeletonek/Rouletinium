import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:rouletinium/l10n/app_localizations.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final lightColorScheme = lightDynamic ??
            ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));
        final darkColorScheme = darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              brightness: Brightness.dark,
            );

        return MaterialApp(
          title: 'Rouletinium',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            scaffoldBackgroundColor: lightColorScheme.surface,
            dialogTheme: DialogThemeData(
              backgroundColor: lightColorScheme.surface,
              surfaceTintColor: Colors.transparent,
            ),
            popupMenuTheme: PopupMenuThemeData(
              color: lightColorScheme.surface,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            scaffoldBackgroundColor: darkColorScheme.surface,
            dialogTheme: DialogThemeData(
              backgroundColor: darkColorScheme.surface,
              surfaceTintColor: Colors.transparent,
            ),
            popupMenuTheme: PopupMenuThemeData(
              color: darkColorScheme.surface,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          themeMode: _themeMode,
          home: HomePage(
            themeMode: _themeMode,
            onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
          ),
        );
      },
    );
  }
}


