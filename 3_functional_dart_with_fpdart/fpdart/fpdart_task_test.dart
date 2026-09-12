import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart';
import 'fpdart_task.dart';

void main() {
  group('Базовый уровень — Option (1–10)', () {
    test('Задача 1: toOption', () {
      expect(toOption(5), equals(const Some(5)));
      expect(toOption(null), equals(const None()));
    });

    test('Задача 2: safeDivide', () {
      expect(safeDivide(10, 2), equals(const Some(5)));
      expect(safeDivide(10, 0), equals(const None()));
    });

    test('Задача 3: doubleOption', () {
      expect(doubleOption(const Some(3)), equals(const Some(6)));
      expect(doubleOption(const None()), equals(const None()));
    });

    test('Задача 4: parsePositiveInt', () {
      // Раскомментируйте после реализации:
      // expect(parsePositiveInt("42"), equals(const Some(42)));
      // expect(parsePositiveInt("-1"), equals(const None()));
      // expect(parsePositiveInt("abc"), equals(const None()));
    });

    test('Задача 5: optionToLabel', () {
      // expect(optionToLabel(const Some("Dart")), equals("значение: Dart"));
      // expect(optionToLabel(const None()), equals("пусто"));
    });

    test('Задача 6: getOrDefault', () {
      // expect(getOrDefault(const Some(7), 0), equals(7));
      // expect(getOrDefault(const None(), 0), equals(0));
    });

    test('Задача 7: filterEven', () {
      // expect(filterEven(const Some(4)), equals(const Some(4)));
      // expect(filterEven(const Some(3)), equals(const None()));
      // expect(filterEven(const None()), equals(const None()));
    });

    test('Задача 8: firstPresent', () {
      // expect(firstPresent([const None(), const Some(1), const Some(2)]), equals(const Some(1)));
      // expect(firstPresent([const None(), const None()]), equals(const None()));
    });

    test('Задача 9: sumOptions', () {
      // expect(sumOptions(const Some(2), const Some(3)), equals(const Some(5)));
      // expect(sumOptions(const Some(2), const None()), equals(const None()));
      // expect(sumOptions(const None(), const Some(3)), equals(const None()));
    });

    test('Задача 10: sequenceOptions', () {
      // expect(sequenceOptions([const Some(1), const Some(2)]), equals(const Some([1, 2])));
      // expect(sequenceOptions([const Some(1), const None()]), equals(const None()));
    });
  });

  group('Средний уровень — Either и комбинации (11–20)', () {
    test('Задача 11: divideEither', () {
      // expect(divideEither(10, 2), equals(const Right(5.0)));
      // expect(divideEither(10, 0), equals(const Left("Деление на ноль")));
    });

    // Добавьте тесты для остальных задач по мере их решения!
  });
}
