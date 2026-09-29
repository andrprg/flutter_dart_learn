import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../task_32_change_notifier.dart';

void main() {
  group('Задача 32 — ChangeNotifier', () {
    test('decrement не уходит ниже нуля', () {
      final model = CounterModelAnswer();
      model.decrement();
      expect(model.count, 0);
      model.increment();
      model.increment();
      model.decrement();
      expect(model.count, 1);
      model.dispose();
    });

    testWidgets('экран обновляется по notifyListeners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CounterScreenAnswer(model: CounterModelAnswer())),
        ),
      );

      expect(find.byKey(const Key('count')), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.byKey(const Key('inc')));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byKey(const Key('dec')));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });
  });
}
