import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bhangti_chai/main.dart';

void main() {
  testWidgets('VangtiChai initial state test', (WidgetTester tester) async {
    await tester.pumpWidget(const VangtiChaiApp());

    // Verify initial header and app bar
    expect(find.text('VangtiChai'), findsOneWidget);
    expect(find.text('Taka:'), findsOneWidget);

    // Verify initial change table values (500: 0, 100: 0, etc.)
    expect(find.text('500: 0'), findsOneWidget);
    expect(find.text('100: 0'), findsOneWidget);
    expect(find.text('50: 0'), findsOneWidget);
    expect(find.text('20: 0'), findsOneWidget);
    expect(find.text('10: 0'), findsOneWidget);
    expect(find.text('5: 0'), findsOneWidget);
    expect(find.text('2: 0'), findsOneWidget);
    expect(find.text('1: 0'), findsOneWidget);
  });

  testWidgets('Keypad digit entry and change calculation test', (WidgetTester tester) async {
    await tester.pumpWidget(const VangtiChaiApp());

    // Tap digits '6', '8', '8'
    await tester.tap(find.widgetWithText(InkWell, '6'));
    await tester.pump();
    expect(find.text('Taka: 6'), findsOneWidget);
    expect(find.text('5: 1'), findsOneWidget);
    expect(find.text('1: 1'), findsOneWidget);

    await tester.tap(find.widgetWithText(InkWell, '8'));
    await tester.pump();
    expect(find.text('Taka: 68'), findsOneWidget);
    expect(find.text('50: 1'), findsOneWidget);
    expect(find.text('10: 1'), findsOneWidget);

    await tester.tap(find.widgetWithText(InkWell, '8'));
    await tester.pump();
    expect(find.text('Taka: 688'), findsOneWidget);
    expect(find.text('500: 1'), findsOneWidget);
    expect(find.text('100: 1'), findsOneWidget);
    expect(find.text('50: 1'), findsOneWidget);
    expect(find.text('20: 1'), findsOneWidget);

    // Tap CLEAR button
    await tester.tap(find.widgetWithText(InkWell, 'CLEAR'));
    await tester.pump();
    expect(find.text('Taka:'), findsOneWidget);
    expect(find.text('500: 0'), findsOneWidget);
  });

  testWidgets('Landscape mode layout test', (WidgetTester tester) async {
    // Set screen size to landscape
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const VangtiChaiApp());

    // Tap digits '6', '8', '8', '0'
    await tester.tap(find.widgetWithText(InkWell, '6'));
    await tester.pump();
    await tester.tap(find.widgetWithText(InkWell, '8'));
    await tester.pump();
    await tester.tap(find.widgetWithText(InkWell, '8'));
    await tester.pump();
    await tester.tap(find.widgetWithText(InkWell, '0'));
    await tester.pump();

    expect(find.text('Taka: 6880'), findsOneWidget);
    expect(find.text('500: 13'), findsOneWidget);
    expect(find.text('100: 3'), findsOneWidget);
    expect(find.text('50: 1'), findsOneWidget);
    expect(find.text('20: 1'), findsOneWidget);
    expect(find.text('10: 1'), findsOneWidget);
  });
}
