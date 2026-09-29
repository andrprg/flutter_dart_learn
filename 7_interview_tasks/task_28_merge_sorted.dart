/// ЗАДАЧА 28 — Слияние двух отсортированных списков
/// Уровень: Junior / Mid
/// Тема: Два указателя, O(n + m)
///
/// Напишите [mergeSorted]: новый список из элементов [left] и [right].
/// Оба входа уже отсортированы по возрастанию. Результат тоже по возрастанию.
/// Дубликаты сохраняйте.
///
/// Примеры:
///   mergeSorted([1, 3, 5], [2, 4, 6]) → [1, 2, 3, 4, 5, 6]
///   mergeSorted([1, 2, 2], [2, 3])    → [1, 2, 2, 2, 3]
///   mergeSorted([], [1])               → [1]
///
/// Не используйте sort() по объединённому списку.

// ─── Ваше решение ────────────────────────────────────────────────────────────

List<int> mergeSorted(List<int> left, List<int> right) {
  // TODO: два указателя
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

List<int> mergeSortedAnswer(List<int> left, List<int> right) {
  final result = <int>[];
  var i = 0;
  var j = 0;

  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      result.add(left[i]);
      i++;
    } else {
      result.add(right[j]);
      j++;
    }
  }

  if (i < left.length) result.addAll(left.sublist(i));
  if (j < right.length) result.addAll(right.sublist(j));
  return result;
}

// ─── Мини-демо ────────────────────────────────────────────────────────────────

void main() {
  print(mergeSortedAnswer([1, 3, 5], [2, 4, 6]));
  print(mergeSortedAnswer([1, 2, 2], [2, 3]));
}
