import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../task_33_widget_keys.dart';

void main() {
  group('Задача 33 — ValueKey', () {
    testWidgets('текст остаётся у той же заметки после разворота', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotesReorderAnswer(
              notes: [
                Note(id: '1', title: 'Первая'),
                Note(id: '2', title: 'Вторая'),
              ],
            ),
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('field-1')), 'заметка 1');
      await tester.pump();

      await tester.tap(find.byKey(const Key('reverse')));
      await tester.pump();

      final firstField = tester.widget<TextField>(
        find.byKey(const Key('field-1')),
      );
      expect(firstField.controller?.text, 'заметка 1');

      final titles = tester.widgetList<Text>(find.byType(Text)).map((w) => w.data);
      expect(titles, containsAllInOrder(['Вторая', 'Первая']));
    });
  });
}
