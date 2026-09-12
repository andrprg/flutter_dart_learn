import 'package:test/test.dart';

import '../task_02_fizzbuzz.dart';


// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 02 — fizzBuzz', () {
    group('Базовый вывод', () {
      test('fizzBuzz(1) → ["1"]', () {
        expect(fizzBuzzAnswer(1), equals(['1']));
      });

      test('fizzBuzz(5) → ["1","2","Fizz","4","Buzz"]', () {
        expect(fizzBuzzAnswer(5), equals(['1', '2', 'Fizz', '4', 'Buzz']));
      });

      test('fizzBuzz(0) → пустой список', () {
        expect(fizzBuzzAnswer(0), isEmpty);
      });
    });

    group('Длина списка', () {
      test('fizzBuzz(15) имеет 15 элементов', () {
        expect(fizzBuzzAnswer(15).length, equals(15));
      });

      test('fizzBuzz(100) имеет 100 элементов', () {
        expect(fizzBuzzAnswer(100).length, equals(100));
      });
    });

    group('Элементы кратные 3 → "Fizz"', () {
      test('3-й элемент = "Fizz"', () {
        expect(fizzBuzzAnswer(10)[2], equals('Fizz'));
      });

      test('6-й элемент = "Fizz"', () {
        expect(fizzBuzzAnswer(10)[5], equals('Fizz'));
      });

      test('9-й элемент = "Fizz"', () {
        expect(fizzBuzzAnswer(10)[8], equals('Fizz'));
      });
    });

    group('Элементы кратные 5 → "Buzz"', () {
      test('5-й элемент = "Buzz"', () {
        expect(fizzBuzzAnswer(10)[4], equals('Buzz'));
      });

      test('10-й элемент = "Buzz"', () {
        expect(fizzBuzzAnswer(10)[9], equals('Buzz'));
      });
    });

    group('Элементы кратные 15 → "FizzBuzz"', () {
      test('15-й элемент = "FizzBuzz"', () {
        expect(fizzBuzzAnswer(15)[14], equals('Fizz' 'Buzz'));
      });

      test('30-й элемент = "FizzBuzz"', () {
        expect(fizzBuzzAnswer(30)[29], equals('FizzBuzz'));
      });
    });

    group('Обычные числа', () {
      test('1-й элемент = "1"', () {
        expect(fizzBuzzAnswer(10)[0], equals('1'));
      });

      test('2-й элемент = "2"', () {
        expect(fizzBuzzAnswer(10)[1], equals('2'));
      });

      test('7-й элемент = "7"', () {
        expect(fizzBuzzAnswer(10)[6], equals('7'));
      });
    });

    group('Подсчёт каждого типа в fizzBuzz(15)', () {
      late List<String> result;

      setUp(() => result = fizzBuzzAnswer(15));

      test('Ровно 4 элемента "Fizz" (3,6,9,12)', () {
        expect(result.where((e) => e == 'Fizz').length, equals(4));
      });

      test('Ровно 2 элемента "Buzz" (5,10)', () {
        expect(result.where((e) => e == 'Buzz').length, equals(2));
      });

      test('Ровно 1 элемент "FizzBuzz" (15)', () {
        expect(result.where((e) => e == 'FizzBuzz').length, equals(1));
      });

      test('Ровно 8 числовых элементов', () {
        expect(
          result.where((e) => int.tryParse(e) != null).length,
          equals(8),
        );
      });
    });
  });
}
