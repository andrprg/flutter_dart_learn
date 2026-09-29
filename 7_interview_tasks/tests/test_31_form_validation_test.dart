import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../task_31_form_validation.dart';

void main() {
  group('Задача 31 — валидация формы', () {
    testWidgets('пустые поля показывают ошибки', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SignUpFormAnswer())),
      );

      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(find.text('Введите email'), findsOneWidget);
      expect(find.text('Минимум 6 символов'), findsOneWidget);
      expect(find.text('Готово'), findsNothing);
    });

    testWidgets('валидные данные показывают «Готово»', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SignUpFormAnswer())),
      );

      await tester.enterText(find.byKey(const Key('email')), 'a@b.co');
      await tester.enterText(find.byKey(const Key('password')), 'secret');
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(find.text('Готово'), findsOneWidget);
      expect(find.text('Введите email'), findsNothing);
    });
  });
}
