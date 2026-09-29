import 'package:test/test.dart';

import '../task_26_binary_search.dart' show binarySearchAnswer;

void main() {
  group('Задача 26 — бинарный поиск', () {
    test('находит единственный элемент', () {
      expect(binarySearchAnswer([1, 3, 5, 7], 5), 2);
      expect(binarySearchAnswer([1, 3, 5, 7], 1), 0);
      expect(binarySearchAnswer([1, 3, 5, 7], 7), 3);
    });

    test('возвращает первое вхождение дубликата', () {
      expect(binarySearchAnswer([1, 2, 2, 2, 3], 2), 1);
    });

    test('нет элемента и пустой список', () {
      expect(binarySearchAnswer([1, 3, 5], 4), -1);
      expect(binarySearchAnswer([], 1), -1);
      expect(binarySearchAnswer([2], 1), -1);
    });
  });
}
