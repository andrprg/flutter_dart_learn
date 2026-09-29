/// ЗАДАЧА 26 — Бинарный поиск (первое вхождение)
/// Уровень: Junior / Mid
/// Тема: Поиск в отсортированном списке, O(log n)
///
/// Напишите [binarySearch]: индекс первого вхождения [target]
/// в списке, отсортированном по возрастанию. Если элемента нет — верните -1.
///
/// Примеры:
///   binarySearch([1, 3, 5, 7], 5)     → 2
///   binarySearch([1, 2, 2, 2, 3], 2)  → 1
///   binarySearch([1, 3, 5], 4)        → -1
///   binarySearch([], 1)               → -1
///
/// Линейный перебор не засчитывается.

// ─── Ваше решение ────────────────────────────────────────────────────────────

int binarySearch(List<int> sorted, int target) {
  // TODO: реализуйте бинарный поиск первого вхождения
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

int binarySearchAnswer(List<int> sorted, int target) {
  var low = 0;
  var high = sorted.length - 1;
  var found = -1;

  while (low <= high) {
    final mid = low + ((high - low) >> 1);
    final value = sorted[mid];
    if (value == target) {
      found = mid;
      high = mid - 1;
    } else if (value < target) {
      low = mid + 1;
    } else {
      high = mid - 1;
    }
  }

  return found;
}

// ─── Мини-демо ────────────────────────────────────────────────────────────────

void main() {
  print('=== Задача 26: Бинарный поиск ===');
  print(binarySearchAnswer([1, 3, 5, 7], 5));
  print(binarySearchAnswer([1, 2, 2, 2, 3], 2));
  print(binarySearchAnswer([1, 3, 5], 4));
}
