import 'package:test/test.dart';

// ─── Реализация (скопирована из task_05_linked_list.dart) ────────────────────

class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val, [this.next]);
}

ListNode? reverseListAnswer(ListNode? head) {
  throw UnimplementedError();
}

ListNode? reverseListRecursiveAnswer(ListNode? head) {
  throw UnimplementedError();
}

ListNode? fromList(List<int> values) {
  if (values.isEmpty) return null;
  final head = ListNode(values.first);
  ListNode curr = head;
  for (int i = 1; i < values.length; i++) {
    curr.next = ListNode(values[i]);
    curr = curr.next!;
  }
  return head;
}

List<int> toList(ListNode? head) {
  final result = <int>[];
  while (head != null) {
    result.add(head.val);
    head = head.next;
  }
  return result;
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 05 — Реверс связного списка', () {
    // ── Вспомогательные матчеры ────────────────────────────────────────────
    Matcher listEquals(List<int> expected) =>
        predicate<ListNode?>((node) => toList(node).toString() == expected.toString());

    group('Итеративный реверс (reverseListAnswer)', () {
      test('null → null', () {
        expect(reverseListAnswer(null), isNull);
      });

      test('[1] → [1] (один элемент)', () {
        expect(toList(reverseListAnswer(fromList([1]))), equals([1]));
      });

      test('[1,2] → [2,1]', () {
        expect(toList(reverseListAnswer(fromList([1, 2]))), equals([2, 1]));
      });

      test('[1,2,3,4,5] → [5,4,3,2,1]', () {
        expect(
          toList(reverseListAnswer(fromList([1, 2, 3, 4, 5]))),
          equals([5, 4, 3, 2, 1]),
        );
      });

      test('[10,20,30] → [30,20,10]', () {
        expect(
          toList(reverseListAnswer(fromList([10, 20, 30]))),
          equals([30, 20, 10]),
        );
      });

      test('Двойной реверс возвращает исходный список', () {
        final original = [1, 2, 3, 4, 5];
        final list = fromList(original);
        final reversed = reverseListAnswer(list);
        final doubleReversed = reverseListAnswer(reversed);
        expect(toList(doubleReversed), equals(original));
      });
    });

    group('Рекурсивный реверс (reverseListRecursiveAnswer)', () {
      test('null → null', () {
        expect(reverseListRecursiveAnswer(null), isNull);
      });

      test('[1] → [1] (один элемент)', () {
        expect(toList(reverseListRecursiveAnswer(fromList([1]))), equals([1]));
      });

      test('[1,2] → [2,1]', () {
        expect(
          toList(reverseListRecursiveAnswer(fromList([1, 2]))),
          equals([2, 1]),
        );
      });

      test('[1,2,3,4,5] → [5,4,3,2,1]', () {
        expect(
          toList(reverseListRecursiveAnswer(fromList([1, 2, 3, 4, 5]))),
          equals([5, 4, 3, 2, 1]),
        );
      });

      test('Двойной реверс возвращает исходный список', () {
        final original = [7, 3, 9, 1];
        final list = fromList(original);
        final reversed = reverseListRecursiveAnswer(list);
        final doubleReversed = reverseListRecursiveAnswer(reversed);
        expect(toList(doubleReversed), equals(original));
      });
    });

    group('Итеративный == Рекурсивный', () {
      test('Оба дают одинаковый результат для [1..10]', () {
        final values = List.generate(10, (i) => i + 1);
        final iterResult = toList(reverseListAnswer(fromList(values)));
        final recurResult = toList(reverseListRecursiveAnswer(fromList(values)));
        expect(iterResult, equals(recurResult));
      });
    });

    group('Вспомогательные функции', () {
      test('fromList([]) → null', () {
        expect(fromList([]), isNull);
      });

      test('toList(null) → []', () {
        expect(toList(null), isEmpty);
      });

      test('fromList → toList сохраняет порядок', () {
        final values = [1, 2, 3, 4, 5];
        expect(toList(fromList(values)), equals(values));
      });
    });
  });
}
