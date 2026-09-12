import 'dart:isolate';
import 'package:test/test.dart';

// ─── Реализация (скопирована из task_09_isolates.dart) ───────────────────────

int heavySum(int n) {
  throw UnimplementedError();
}

void _isolateEntry(List<dynamic> args) {
  final sendPort = args[0] as SendPort;
  final n = args[1] as int;
  sendPort.send(heavySum(n));
}

Future<int> sumInIsolateAnswer(int n) async {
  throw UnimplementedError();
}

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
  throw UnimplementedError();
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 09 — Isolates', () {
    group('heavySum() — синхронная функция', () {
      test('heavySum(0) = 0', () {
        expect(heavySum(0), equals(0));
      });

      test('heavySum(1) = 1', () {
        expect(heavySum(1), equals(1));
      });

      test('heavySum(10) = 55 (1+2+...+10)', () {
        expect(heavySum(10), equals(55));
      });

      test('heavySum(100) = 5050', () {
        expect(heavySum(100), equals(5050));
      });

      test('heavySum(n) == n*(n+1)/2 (формула Гаусса)', () {
        for (final n in [5, 10, 50, 100, 1000]) {
          expect(heavySum(n), equals(n * (n + 1) ~/ 2));
        }
      });
    });

    group('sumInIsolate() — через Isolate', () {
      test('sumInIsolate(10) = 55', () async {
        expect(await sumInIsolateAnswer(10), equals(55));
      });

      test('sumInIsolate(100) = 5050', () async {
        expect(await sumInIsolateAnswer(100), equals(5050));
      });

      test('Совпадает с результатом heavySum', () async {
        const n = 500;
        expect(await sumInIsolateAnswer(n), equals(heavySum(n)));
      });

      test('sumInIsolate(0) = 0', () async {
        expect(await sumInIsolateAnswer(0), equals(0));
      });
    });

    group('primesInIsolate() — решето Эратосфена', () {
      test('Простые до 10: [2,3,5,7]', () async {
        expect(await primesInIsolate(10), equals([2, 3, 5, 7]));
      });

      test('Простые до 30: [2,3,5,7,11,13,17,19,23,29]', () async {
        expect(
          await primesInIsolate(30),
          equals([2, 3, 5, 7, 11, 13, 17, 19, 23, 29]),
        );
      });

      test('Простые до 2: [2]', () async {
        expect(await primesInIsolate(2), equals([2]));
      });

      test('До 1: пустой список (нет простых ≤ 1)', () async {
        expect(await primesInIsolate(1), isEmpty);
      });

      test('До 100: ровно 25 простых чисел', () async {
        final primes = await primesInIsolate(100);
        expect(primes.length, equals(25));
      });

      test('Все результаты действительно простые', () async {
        final primes = await primesInIsolate(50);
        for (final p in primes) {
          expect(_isPrime(p), isTrue, reason: '$p не является простым');
        }
      });

      test('Ни одно составное число не попало в список', () async {
        final primes = await primesInIsolate(20);
        const composites = [4, 6, 8, 9, 10, 12, 14, 15, 16, 18, 20];
        for (final c in composites) {
          expect(primes, isNot(contains(c)), reason: '$c не должно быть в списке');
        }
      });
    });
  });
}

bool _isPrime(int n) {
  if (n < 2) return false;
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) return false;
  }
  return true;
}
