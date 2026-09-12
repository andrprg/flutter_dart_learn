/// ЗАДАЧА 2 — FizzBuzz
/// Уровень: Junior
/// Тема: Циклы, условная логика
///
/// Напишите функцию [fizzBuzz], которая принимает число n
/// и возвращает список строк от 1 до n, где:
///   - кратные 3 → "Fizz"
///   - кратные 5 → "Buzz"
///   - кратные и 3, и 5 → "FizzBuzz"
///   - остальные → строковое представление числа
///
/// Примеры:
///   fizzBuzz(5)  → ["1", "2", "Fizz", "4", "Buzz"]
///   fizzBuzz(15) → [..., "FizzBuzz"]

// ─── Ваше решение ────────────────────────────────────────────────────────────

List<String> fizzBuzz(int n) {  
    return List.generate(n, (int i) {
    var result = switch(i) {
        _ when i % 15 == 0 => 'FizzBuzz',
        _ when i % 3 == 0 => 'Fizz',
        _ when i % 5 == 0 => 'Buzz',
        _ => i
    };
    return result.toString();
  });
}



// ─── Эталонное решение ───────────────────────────────────────────────────────

List<String> fizzBuzzAnswer(int n) {
  return List.generate(n, (i) {
    final num = i + 1;
    if (num % 15 == 0) return 'FizzBuzz';
    if (num % 3 == 0) return 'Fizz';
    if (num % 5 == 0) return 'Buzz';
    return '$num';
  });
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  print('=== Задача 2: FizzBuzz ===');
  final result = fizzBuzzAnswer(15);
  for (int i = 0; i < result.length; i++) {
    print('${i + 1}: ${result[i]}');
  }
  // Ожидаемый вывод для 15: FizzBuzz
  print('\nПроверка 15-го элемента: ${result[14] == "FizzBuzz" ? "✓" : "✗"}');
}
