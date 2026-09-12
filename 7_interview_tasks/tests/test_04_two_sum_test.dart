import 'package:test/test.dart';

import '../task_04_two_sum.dart';

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 04 — twoSum', () {
    group('Базовые случаи', () {
      test('[2,7,11,15], target=9 → [0,1]', () {
        expect(twoSum([2, 7, 11, 15], 9), equals([0, 1]));
      });

      test('[3,2,4], target=6 → [1,2]', () {
        expect(twoSum([3, 2, 4], 6), equals([1, 2]));
      });

      test('[3,3], target=6 → [0,1]', () {
        expect(twoSum([3, 3], 6), equals([0, 1]));
      });
    });

    group('Отрицательные числа', () {
      test('[-1,-2,-3,-4,-5], target=-8 → [2,4]', () {
        expect(twoSum([-1, -2, -3, -4, -5], -8), equals([2, 4]));
      });

      test('[-3,4,3,90], target=0 → [0,2]', () {
        expect(twoSum([-3, 4, 3, 90], 0), equals([0, 2]));
      });
    });

    group('Индексы', () {
      test('Первый индекс всегда меньше второго', () {
        final result = twoSum([1, 5, 3, 2], 7);
        expect(result[0], lessThan(result[1]));
      });

      test('Оба индекса в диапазоне списка', () {
        final nums = [2, 7, 11, 15];
        final result = twoSum(nums, 9);
        expect(result[0], greaterThanOrEqualTo(0));
        expect(result[1], lessThan(nums.length));
      });
    });

    group('Корректность результата', () {
      test('Числа на найденных индексах дают target', () {
        final nums = [4, 8, 3, 15, 7];
        final target = 11;
        final result = twoSum(nums, target);
        expect(nums[result[0]] + nums[result[1]], equals(target));
      });

      test('Работает с большим списком', () {
        final nums = List.generate(100, (i) => i);
        final result = twoSum(nums, 197);
        expect(nums[result[0]] + nums[result[1]], equals(197));
      });
    });

    group('Исключения', () {
      test('Бросает StateError если решения нет', () {
        expect(
          () => twoSum([1, 2, 3], 100),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
