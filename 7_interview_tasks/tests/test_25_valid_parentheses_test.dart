import 'package:test/test.dart';

import '../task_25_valid_parentheses.dart' show isValidParenthesesAnswer;

void main() {
  group('Задача 25 — валидные скобки', () {
    test('пустая строка валидна', () {
      expect(isValidParenthesesAnswer(''), isTrue);
    });

    test('парные скобки', () {
      expect(isValidParenthesesAnswer('()'), isTrue);
      expect(isValidParenthesesAnswer('()[]{}'), isTrue);
      expect(isValidParenthesesAnswer('{[]()}'), isTrue);
    });

    test('неправильный порядок и лишние скобки', () {
      expect(isValidParenthesesAnswer('(]'), isFalse);
      expect(isValidParenthesesAnswer('([)]'), isFalse);
      expect(isValidParenthesesAnswer('('), isFalse);
      expect(isValidParenthesesAnswer(')'), isFalse);
      expect(isValidParenthesesAnswer('({)}'), isFalse);
    });
  });
}
