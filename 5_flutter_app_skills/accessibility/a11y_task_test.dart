import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'a11y_task.dart';

void main() {
  group('Accessibility helpers', () {
    test('isTapTargetTooSmall проверяет размер 48x48', () {
      expect(isTapTargetTooSmall(const Size(40, 48)), isTrue);
      expect(isTapTargetTooSmall(const Size(48, 48)), isFalse);
    });

    test('deleteButtonLabel описывает действие', () {
      expect(deleteButtonLabel('Заметка'), 'Удалить: Заметка');
    });

    test('orderStatusSemanticLabel возвращает понятный текст', () {
      expect(orderStatusSemanticLabel(OrderStatus.created), 'Заказ создан');
      expect(orderStatusSemanticLabel(OrderStatus.delivered), 'Заказ доставлен');
    });

    test('sortKeyForIndex создает возрастающий sort key', () {
      expect(sortKeyForIndex(2).order, 2);
    });
  });
}
