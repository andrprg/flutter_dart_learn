/// ЗАДАЧА 9 — Isolate и параллельные вычисления
/// Уровень: Senior
/// Тема: Dart Isolates, compute, тяжёлые вычисления
///
/// Dart — однопоточный язык, но поддерживает параллелизм через Isolate.
/// Задача: реализуйте тяжёлые вычисления в отдельном Isolate,
/// чтобы не блокировать главный поток.
///
/// Задачи:
///   1. [heavyComputation] — вычисляет сумму чисел от 1 до n (имитация тяжёлой работы)
///   2. [runInIsolate] — запускает функцию в отдельном Isolate через Isolate.spawn
///   3. [primeNumbers] — находит все простые числа до n (решето Эратосфена)
///      и запускает это в отдельном Isolate

import 'dart:isolate';

// ─── Ваше решение ────────────────────────────────────────────────────────────

Future<int> sumInIsolate(int n) async {
  // TODO: запустите heavySum в отдельном Isolate и верните результат
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

int heavySum(int n) {
  int sum = 0;
  for (int i = 1; i <= n; i++) {
    sum += i;
  }
  return sum;
}

void _isolateEntry(List<dynamic> args) {
  final sendPort = args[0] as SendPort;
  final n = args[1] as int;
  sendPort.send(heavySum(n));
}

Future<int> sumInIsolateAnswer(int n) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_isolateEntry, [receivePort.sendPort, n]);
  final result = await receivePort.first as int;
  receivePort.close();
  return result;
}

// Решето Эратосфена
void _sieveEntry(List<dynamic> args) {
  final sendPort = args[0] as SendPort;
  final n = args[1] as int;

  final sieve = List<bool>.filled(n + 1, true);
  sieve[0] = sieve[1] = false;
  for (int i = 2; i * i <= n; i++) {
    if (sieve[i]) {
      for (int j = i * i; j <= n; j += i) {
        sieve[j] = false;
      }
    }
  }
  sendPort.send([for (int i = 2; i <= n; i++) if (sieve[i]) i]);
}

Future<List<int>> primesInIsolate(int n) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_sieveEntry, [receivePort.sendPort, n]);
  final result = await receivePort.first as List<int>;
  receivePort.close();
  return result;
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() async {
  print('=== Задача 9: Isolates ===\n');

  final sw = Stopwatch()..start();

  final sum = await sumInIsolateAnswer(1000000);
  print('Сумма 1..1000000 = $sum (формула: ${1000000 * 1000001 ~/ 2})');
  print('Время: ${sw.elapsedMilliseconds}ms\n');

  sw.reset();
  final primes = await primesInIsolate(100);
  print('Простые числа до 100 (${primes.length} штук):');
  print(primes);
  print('Время: ${sw.elapsedMilliseconds}ms');
}
