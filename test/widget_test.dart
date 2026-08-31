import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rouletinium/main.dart';

void main() {
  testWidgets('Renders app title and spin button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('Add button builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(FloatingActionButton), findsWidgets);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
