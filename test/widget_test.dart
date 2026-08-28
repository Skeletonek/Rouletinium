import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rouletinium/main.dart';

void main() {
  testWidgets('Renders app title and spin button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Rouletinium'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('Add button builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(TextButton, 'Dodaj'));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
