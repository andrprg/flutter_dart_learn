/// ЗАДАЧА 1 — Проверка палиндрома
/// Уровень: Junior
/// Тема: Строки, базовая логика
///
/// Напишите функцию [isPalindrome], которая принимает строку
/// и возвращает true, если строка является палиндромом
/// (читается одинаково слева направо и справа налево).
/// Регистр букв игнорировать.
///
/// Примеры:
///   isPalindrome("racecar") → true
///   isPalindrome("Madam")   → true
///   isPalindrome("hello")   → false
///   isPalindrome("А роза упала на лапу Азора") → true (без пробелов)

// ─── Ваше решение ────────────────────────────────────────────────────────────

bool isPalindrome(String text) {
  var reverse = text.toLowerCase().replaceAll(RegExp(r'\s+'), ''); 
  return reverse == reverse.split('').reversed.join('');
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

bool isPalindromeAnswer(String text) {
  final normalized = text.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  return normalized == normalized.split('').reversed.join('');
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  final cases = [
    ('racecar', true),
    ('Madam', true),
    ('hello', false),
    ('А роза упала на лапу Азора', true),
    ('', true),
  ];

  print('=== Задача 1: Палиндром ===');
  for (final (input, expected) in cases) {
    final result = isPalindromeAnswer(input);
    final status = result == expected ? '✓' : '✗';
    print('$status isPalindrome("$input") = $result (ожидалось: $expected)');
  }
}
