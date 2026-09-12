/// ЗАДАЧА 5 — Реверс связного списка
/// Уровень: Junior / Mid
/// Тема: Структуры данных, классы, ссылки
///
/// Реализуйте класс [ListNode] и функцию [reverseList],
/// которая разворачивает односвязный список.
///
/// Пример:
///   1 → 2 → 3 → 4 → 5  →  5 → 4 → 3 → 2 → 1
///
/// Дополнительно: реализуйте итеративно И рекурсивно.

// ─── Модель ──────────────────────────────────────────────────────────────────

class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val, [this.next]);
}

// ─── Ваше решение (итеративное) ──────────────────────────────────────────────

ListNode? reverseList(ListNode? head) {
  // TODO: реализуйте итеративно
  throw UnimplementedError();
}

// ─── Ваше решение (рекурсивное) ──────────────────────────────────────────────

ListNode? reverseListRecursive(ListNode? head) {
  // TODO: реализуйте рекурсивно
  throw UnimplementedError();
}












// ─── Эталонное решение ───────────────────────────────────────────────────────

ListNode? reverseListAnswer(ListNode? head) {
  ListNode? prev;
  ListNode? curr = head;
  while (curr != null) {
    final next = curr.next;
    curr.next = prev;
    prev = curr;
    curr = next;
  }
  return prev;
}

ListNode? reverseListRecursiveAnswer(ListNode? head) {
  if (head == null || head.next == null) return head;
  final newHead = reverseListRecursiveAnswer(head.next);
  head.next!.next = head;
  head.next = null;
  return newHead;
}

// ─── Утилиты ─────────────────────────────────────────────────────────────────

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
  print('=== Задача 5: Реверс связного списка ===');

  final list1 = fromList([1, 2, 3, 4, 5]);
  final reversed1 = reverseListAnswer(list1);
  print('Итеративно: ${toList(reversed1)}');   // [5, 4, 3, 2, 1]

  final list2 = fromList([1, 2, 3, 4, 5]);
  final reversed2 = reverseListRecursiveAnswer(list2);
  print('Рекурсивно: ${toList(reversed2)}');   // [5, 4, 3, 2, 1]
}
