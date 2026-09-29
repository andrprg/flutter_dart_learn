import 'package:test/test.dart';

import '../task_28_merge_sorted.dart' show mergeSortedAnswer;

void main() {
  group('Задача 28 — слияние отсортированных списков', () {
    test('чередует элементы', () {
      expect(mergeSortedAnswer([1, 3, 5], [2, 4, 6]), [1, 2, 3, 4, 5, 6]);
    });

    test('сохраняет дубликаты', () {
      expect(mergeSortedAnswer([1, 2, 2], [2, 3]), [1, 2, 2, 2, 3]);
    });

    test('один из списков пустой', () {
      expect(mergeSortedAnswer([], [1, 2]), [1, 2]);
      expect(mergeSortedAnswer([1, 2], []), [1, 2]);
      expect(mergeSortedAnswer([], []), isEmpty);
    });
  });
}
