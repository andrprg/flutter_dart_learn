/// ЗАДАЧА 3 — Анаграмма
/// Уровень: Junior
/// Тема: Строки, Map, коллекции
///
/// Напишите функцию [isAnagram], которая принимает две строки
/// и возвращает true, если одна является анаграммой другой
/// (содержит те же буквы в другом порядке).
/// Регистр и пробелы игнорировать.
///
/// Примеры:
///   isAnagram("listen", "silent")       → true
///   isAnagram("triangle", "integral")   → true
///   isAnagram("hello", "world")         → false
///   isAnagram("Astronomer", "Moon starer") → true

// ─── Ваше решение ────────────────────────────────────────────────────────────

bool isAnagram(String a, String b) {
  List<String> charsA = a.toLowerCase().replaceAll(' ', '').split('');
  charsA.sort(); 
  String sortA = charsA.join('');
  List<String> charsB = b.toLowerCase().replaceAll(' ', '').split('');
  charsB.sort(); 
  String sortB = charsB.join('');
 

  return sortA == sortB;
}



// ─── Эталонное решение ───────────────────────────────────────────────────────

Map<String, int> _charFrequency(String s) {
  final freq = <String, int>{};
  for (final ch in s.toLowerCase().replaceAll(' ', '').split('')) {
    freq[ch] = (freq[ch] ?? 0) + 1;
  }
  return freq;
}

bool isAnagramAnswer(String a, String b) {
  final freqA = _charFrequency(a);
  final freqB = _charFrequency(b);
  if (freqA.length != freqB.length) return false;
  for (final entry in freqA.entries) {
    if (freqB[entry.key] != entry.value) return false;
  }
  return true;
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  final cases = [
    ('listen', 'silent', true),
    ('triangle', 'integral', true),
    ('hello', 'world', false),
    ('Astronomer', 'Moon starer', true),
  ];

  print('=== Задача 3: Анаграмма ===');
  for (final (a, b, expected) in cases) {
    final result = isAnagramAnswer(a, b);
    final status = result == expected ? '✓' : '✗';
    print('$status isAnagram("$a", "$b") = $result');
  }
}
