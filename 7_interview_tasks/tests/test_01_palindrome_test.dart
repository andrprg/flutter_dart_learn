import 'package:test/test.dart';

import '../task_01_palindrome.dart' show isPalindrome;

// Алиас — тест-вызовы используют это имя
bool isPalindromeAnswer(String text) => isPalindrome(text);

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 01 — isPalindrome', () {
    group('Простые палиндромы', () {
      test('racecar → true', () {
        expect(isPalindromeAnswer('racecar'), isTrue);
      });

      test('a → true (один символ)', () {
        expect(isPalindromeAnswer('a'), isTrue);
      });

      test('пустая строка → true', () {
        expect(isPalindromeAnswer(''), isTrue);
      });

      test('aa → true', () {
        expect(isPalindromeAnswer('aa'), isTrue);
      });

      test('aba → true', () {
        expect(isPalindromeAnswer('aba'), isTrue);
      });
    });

    group('Регистронезависимость', () {
      test('Madam → true (разный регистр)', () {
        expect(isPalindromeAnswer('Madam'), isTrue);
      });

      test('RaceCar → true', () {
        expect(isPalindromeAnswer('RaceCar'), isTrue);
      });

      test('LEVEL → true', () {
        expect(isPalindromeAnswer('LEVEL'), isTrue);
      });
    });

    group('Пробелы игнорируются', () {
      test('А роза упала на лапу Азора → true', () {
        expect(isPalindromeAnswer('А роза упала на лапу Азора'), isTrue);
      });

      test('never odd or even → true', () {
        expect(isPalindromeAnswer('never odd or even'), isTrue);
      });
    });

    group('Не палиндромы', () {
      test('hello → false', () {
        expect(isPalindromeAnswer('hello'), isFalse);
      });

      test('ab → false', () {
        expect(isPalindromeAnswer('ab'), isFalse);
      });

      test('flutter → false', () {
        expect(isPalindromeAnswer('flutter'), isFalse);
      });

      test('dart → false', () {
        expect(isPalindromeAnswer('dart'), isFalse);
      });
    });

    group('Числа и спецсимволы', () {
      test('12321 → true', () {
        expect(isPalindromeAnswer('12321'), isTrue);
      });

      test('12345 → false', () {
        expect(isPalindromeAnswer('12345'), isFalse);
      });
    });
  });
}
