import 'package:flutter_test/flutter_test.dart';

import 'forms_task.dart';

void main() {
  group('Forms validators', () {
    test('requiredValidator проверяет пустые значения', () {
      expect(requiredValidator(null), isNotNull);
      expect(requiredValidator('   '), isNotNull);
      expect(requiredValidator('Dart'), isNull);
    });

    test('emailValidator проверяет email', () {
      expect(emailValidator('user@example.com'), isNull);
      expect(emailValidator('bad-email'), isNotNull);
      expect(emailValidator(''), isNotNull);
    });

    test('passwordValidator требует длину и цифру', () {
      expect(passwordValidator('password1'), isNull);
      expect(passwordValidator('short1'), isNotNull);
      expect(passwordValidator('password'), isNotNull);
    });

    test('confirmPasswordValidator сравнивает пароли', () {
      expect(confirmPasswordValidator('password1', 'password1'), isNull);
      expect(confirmPasswordValidator('password2', 'password1'), isNotNull);
    });

    test('collectRegisterErrors собирает ошибки регистрации', () {
      final errors = collectRegisterErrors(
        const RegisterDraft(
          name: '',
          email: 'bad',
          password: 'short',
          confirmPassword: 'other',
          acceptedTerms: false,
        ),
      );

      expect(errors.length, greaterThanOrEqualTo(4));
    });
  });
}
