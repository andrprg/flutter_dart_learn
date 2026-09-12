import 'package:fpdart/fpdart.dart';
import 'package:test/test.dart';

import 'fpdart_validation_task.dart';

void main() {
  group('fpdart validation', () {
    test('validateName возвращает Right для корректного имени', () {
      expect(validateName('Alex'), isA<Right<List<String>, String>>());
    });

    test('validateEmail возвращает Left для некорректного email', () {
      expect(validateEmail('bad-email'), isA<Left<List<String>, String>>());
    });

    test('combine2 накапливает ошибки обеих Validation', () {
      final result = combine2<String, int>(
        left(['name']),
        left(['age']),
      );

      expect(result, isA<Left<List<String>, (String, int)>>());
      result.match(
        (errors) => expect(errors, ['name', 'age']),
        (_) => fail('Ожидались ошибки'),
      );
    });

    test('collectValidationErrors возвращает список ошибок', () {
      final errors = collectValidationErrors(
        const RegisterFormDraft(
          name: '',
          email: 'bad',
          password: '123',
          confirmPassword: '321',
          age: 10,
        ),
      );

      expect(errors.length, greaterThanOrEqualTo(4));
    });
  });
}
