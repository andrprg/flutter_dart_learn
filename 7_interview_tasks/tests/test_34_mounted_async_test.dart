import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../task_34_mounted_async.dart';

void main() {
  group('Задача 34 — mounted после await', () {
    testWidgets('показывает результат, если виджет ещё в дереве', (
      tester,
    ) async {
      final pending = Completer<String>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DelayedGreetingAnswer(loader: () => pending.future),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('load')));
      await tester.pump();
      expect(find.text('Ждём...'), findsOneWidget);

      pending.complete('Привет');
      await tester.pump();
      expect(find.byKey(const Key('message')), findsOneWidget);
      expect(find.text('Привет'), findsOneWidget);
    });

    testWidgets('не падает, если экран закрыли до завершения Future', (
      tester,
    ) async {
      final pending = Completer<String>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DelayedGreetingAnswer(loader: () => pending.future),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('load')));
      await tester.pump();

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      pending.complete('поздно');
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
