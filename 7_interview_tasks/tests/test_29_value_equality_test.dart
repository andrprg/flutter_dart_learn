import 'package:test/test.dart';

import '../task_29_value_equality.dart' show MoneyAnswer;

void main() {
  group('Задача 29 — ==, hashCode, copyWith', () {
    test('равные значения равны и имеют один hashCode', () {
      const a = MoneyAnswer(amount: 100, currency: 'RUB');
      const b = MoneyAnswer(amount: 100, currency: 'RUB');
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('разная валюта или сумма — не равны', () {
      const a = MoneyAnswer(amount: 100, currency: 'RUB');
      expect(a, isNot(const MoneyAnswer(amount: 100, currency: 'USD')));
      expect(a, isNot(const MoneyAnswer(amount: 50, currency: 'RUB')));
    });

    test('copyWith не меняет исходный объект', () {
      const original = MoneyAnswer(amount: 100, currency: 'RUB');
      final next = original.copyWith(amount: 250);
      expect(original.amount, 100);
      expect(next.amount, 250);
      expect(next.currency, 'RUB');
      expect(original.copyWith().currency, 'RUB');
    });

    test('одинаковые объекты схлопываются в Set', () {
      const a = MoneyAnswer(amount: 10, currency: 'EUR');
      const b = MoneyAnswer(amount: 10, currency: 'EUR');
      expect({a, b}, hasLength(1));
    });
  });
}
