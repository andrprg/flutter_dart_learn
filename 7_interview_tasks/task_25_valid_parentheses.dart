/// ЗАДАЧА 25 — Валидные скобки
/// Уровень: Junior / Mid
/// Тема: Стек, строки
///
/// Напишите функцию [isValidParentheses], которая возвращает true, если
/// скобки в строке расставлены корректно.
///
/// Учитываются пары: `()`, `[]`, `{}`.
/// Других символов во входе нет.
/// Пустая строка считается валидной.
///
/// Примеры:
///   isValidParentheses("()")     → true
///   isValidParentheses("()[]{}") → true
///   isValidParentheses("(]")     → false
///   isValidParentheses("([)]")   → false
///   isValidParentheses("{[]}")   → true
///
/// Требование: один проход по строке, O(n) по времени.

// ─── Ваше решение ────────────────────────────────────────────────────────────

bool isValidParentheses(String input) {
  // TODO: реализуйте через стек
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

bool isValidParenthesesAnswer(String input) {
  const pairs = <String, String>{')': '(', ']': '[', '}': '{'};
  final stack = <String>[];

  for (final char in input.split('')) {
    final opener = pairs[char];
    if (opener == null) {
      stack.add(char);
      continue;
    }
    if (stack.isEmpty || stack.removeLast() != opener) return false;
  }

  return stack.isEmpty;
}

// ─── Мини-демо ────────────────────────────────────────────────────────────────

void main() {
  const cases = ['()', '()[]{}', '(]', '([)]', '{[]}', ''];
  print('=== Задача 25: Валидные скобки ===');
  for (final input in cases) {
    print('"$input" → ${isValidParenthesesAnswer(input)}');
  }
}
