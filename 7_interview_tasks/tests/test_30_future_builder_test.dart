import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../task_30_future_builder.dart';

void main() {
  group('Задача 30 — FutureBuilder', () {
    testWidgets('показывает загрузку, затем имя', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileLoaderAnswer(
            future: Future<UserCard>.delayed(
              const Duration(milliseconds: 50),
              () => const UserCard(name: 'Анна'),
            ),
          ),
        ),
      );

      expect(find.text('Загрузка...'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Анна'), findsOneWidget);
      expect(find.text('Загрузка...'), findsNothing);
    });

    testWidgets('показывает ошибку', (tester) async {
      final pending = Completer<UserCard>();
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileLoaderAnswer(future: pending.future),
        ),
      );

      pending.completeError(Exception('network'));
      await tester.pump();
      expect(find.text('Ошибка'), findsOneWidget);
    });
  });
}
