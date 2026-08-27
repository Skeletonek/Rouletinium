import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  if (!kIsWeb) {
//    if (Platform.isWindows || Platform.isLinux) {
//      setWindowTitle("Rouletinium");
//      setWindowMinSize(const Size(600, 400));
//    }
// }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rouletinium',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}


