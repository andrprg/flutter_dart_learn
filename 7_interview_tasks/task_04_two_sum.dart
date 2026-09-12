/// ЗАДАЧА 4 — Two Sum
/// Уровень: Junior / Mid
/// Тема: Список, Map, алгоритмы поиска
///
/// Напишите функцию [twoSum], которая принимает список целых чисел [nums]
/// и целевое число [target]. Верните индексы двух чисел, сумма которых
/// равна target. Каждое число используется только один раз.
/// Гарантируется, что решение всегда существует.
///
/// Примеры:
///   twoSum([2, 7, 11, 15], 9)  → [0, 1]   (2 + 7 = 9)
///   twoSum([3, 2, 4], 6)       → [1, 2]   (2 + 4 = 6)
///   twoSum([3, 3], 6)          → [0, 1]
///
/// Требование: решение за O(n), не O(n²)

// ─── Ваше решение ────────────────────────────────────────────────────────────
// Решено верно
List<int> twoSum(List<int> nums, int target) {
  // TODO: реализуйте функцию
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

List<int> twoSumAnswer(List<int> nums, int target) {
  final seen = <int, int>{};
  for (int i = 0; i < nums.length; i++) {
    final complement = target - nums[i];
    if (seen.containsKey(complement)) {
      return [seen[complement]!, i];
    }
    seen[nums[i]] = i;
  }
  throw StateError('No solution found');
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  final cases = [
    ([2, 7, 11, 15], 9, [0, 1]),
    ([3, 2, 4], 6, [1, 2]),
    ([3, 3], 6, [0, 1]),
  ];

  print('=== Задача 4: Two Sum ===');
  for (final (nums, target, expected) in cases) {
    final result = twoSumAnswer(nums, target);
    final status = result.toString() == expected.toString() ? '✓' : '✗';
    print('$status twoSum($nums, $target) = $result (ожидалось: $expected)');
  }
}
