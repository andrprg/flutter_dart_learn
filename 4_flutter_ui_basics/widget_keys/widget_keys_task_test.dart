import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_keys_task.dart';

void main() {
  group('Widget keys helpers', () {
    test('key factories и policy', () {
      const item = Item('1', 'One');
      expect(valueKeyForItem(item).value, '1');
      expect(objectKeyForItem(item).value, same(item));

      final a = newUniqueKey();
      final b = newUniqueKey();
      expect(a, isNot(b));

      expect(createFormKey(), isA<GlobalKey<FormState>>());
      expect(isIndexSafeAsKey(), isFalse);

      expect(keyKindFor('entity_id'), 'value');
      expect(keyKindFor('reset_state'), 'unique');
      expect(keyKindFor('form_state'), 'global');
    });

    test('toggleChecked', () {
      expect(toggleChecked({}, 'a'), {'a': true});
      expect(toggleChecked({'a': true}, 'a'), {'a': false});
    });

    testWidgets('LabeledCheckItem использует ValueKey id', (tester) async {
      const item = Item('42', 'Milk');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabeledCheckItem(
              item: item,
              checked: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('42')), findsOneWidget);
      expect(find.text('Milk'), findsOneWidget);
    });

    testWidgets('ItemsChecklist рендерит все элементы', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemsChecklist(
              items: const [Item('1', 'A'), Item('2', 'B')],
              checkedMap: const {'1': true},
              onChanged: (_, __) {},
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.byKey(const ValueKey('1')), findsOneWidget);
    });

    testWidgets('SwappableCounters с keys сохраняет state', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SwappableCounters())),
      );

      // + у первого (A)
      await tester.tap(find.text('+').first);
      await tester.pump();

      await tester.tap(find.text('swap'));
      await tester.pump();

      // После swap с ValueKey состояние должно переехать с виджетом A.
      final states = tester.stateList<CounterBoxState>(find.byType(CounterBox));
      expect(states.any((s) => s.count == 1), isTrue);
    });

    testWidgets('validateForm через GlobalKey', (tester) async {
      final key = createFormKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: key,
              child: TextFormField(
                validator: (v) => (v == null || v.isEmpty) ? 'err' : null,
              ),
            ),
          ),
        ),
      );

      expect(validateForm(key), isFalse);
    });
  });
}
