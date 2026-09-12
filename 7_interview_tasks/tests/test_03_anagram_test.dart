import 'package:test/test.dart';
import '../task_03_anagram.dart' show isAnagram;

// Алиас — тест-вызовы используют это имя
bool isAnagramAnswer(String a, String b) => isAnagram(a, b);

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 03 — isAnagram', () {
    group('Классические анаграммы', () {
      test('listen / silent → true', () {
        expect(isAnagram('listen', 'silent'), isTrue);
      });

      test('triangle / integral → true', () {
        expect(isAnagram('triangle', 'integral'), isTrue);
      });

      test('enlist / inlets → true', () {
        expect(isAnagram('enlist', 'inlets'), isTrue);
      });
    });

    group('Регистр и пробелы игнорируются', () {
      test('Astronomer / Moon starer → true', () {
        expect(isAnagram('Astronomer', 'Moon starer'), isTrue);
      });

      test('LISTEN / SILENT → true', () {
        expect(isAnagram('LISTEN', 'SILENT'), isTrue);
      });

      test('  abc  /  cba  → true (пробелы)', () {
        expect(isAnagram('  abc  ', '  cba  '), isTrue);
      });
    });

    group('Не анаграммы', () {
      test('hello / world → false', () {
        expect(isAnagram('hello', 'world'), isFalse);
      });

      test('flutter / dart → false', () {
        expect(isAnagram('flutter', 'dart'), isFalse);
      });

      test('abc / abcd → false (разная длина)', () {
        expect(isAnagram('abc', 'abcd'), isFalse);
      });

      test('aab / abb → false (разные частоты)', () {
        expect(isAnagram('aab', 'abb'), isFalse);
      });
    });

    group('Граничные случаи', () {
      test('пустые строки → true', () {
        expect(isAnagram('', ''), isTrue);
      });

      test('один символ → true (a/a)', () {
        expect(isAnagram('a', 'a'), isTrue);
      });

      test('один символ → false (a/b)', () {
        expect(isAnagram('a', 'b'), isFalse);
      });

      test('одинаковые строки — анаграмма самой себя', () {
        expect(isAnagram('dart', 'dart'), isTrue);
      });
    });

    group('Симметричность', () {
      test('isAnagram(a,b) == isAnagram(b,a)', () {
        expect(
          isAnagram('silent', 'listen'),
          equals(isAnagram('listen', 'silent')),
        );
      });
    });
  });
}
