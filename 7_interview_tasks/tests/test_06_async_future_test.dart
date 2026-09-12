import 'package:test/test.dart';

// ─── Реализация (скопирована из task_06_async_future.dart) ───────────────────

class User {
  final int id;
  final String name;
  final String email;
  const User({required this.id, required this.name, required this.email});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

Future<User> fetchUserDataAnswer(int userId, {bool shouldFail = false}) async {
  throw UnimplementedError();
}

Future<T> fetchWithRetryAnswer<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
}) async {
  throw UnimplementedError();
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 06 — Async/Future/Retry', () {
    group('fetchUserData', () {
      test('Возвращает User с правильным id', () async {
        final user = await fetchUserDataAnswer(42);
        expect(user.id, equals(42));
      });

      test('Возвращает User с именем', () async {
        final user = await fetchUserDataAnswer(1);
        expect(user.name, isNotEmpty);
      });

      test('Возвращает User с валидным email', () async {
        final user = await fetchUserDataAnswer(1);
        expect(user.email, contains('@'));
      });

      test('shouldFail=true → бросает NetworkException', () async {
        expect(
          () => fetchUserDataAnswer(1, shouldFail: true),
          throwsA(isA<NetworkException>()),
        );
      });

      test('Сообщение NetworkException не пустое', () async {
        try {
          await fetchUserDataAnswer(1, shouldFail: true);
          fail('Должно было выброситься исключение');
        } on NetworkException catch (e) {
          expect(e.message, isNotEmpty);
        }
      });
    });

    group('fetchWithRetry', () {
      test('Успешный запрос с первой попытки', () async {
        int calls = 0;
        final result = await fetchWithRetryAnswer(() async {
          calls++;
          return 'success';
        });
        expect(result, equals('success'));
        expect(calls, equals(1));
      });

      test('Успех после 2 неудач (maxRetries=3)', () async {
        int attempt = 0;
        final result = await fetchWithRetryAnswer(
          () async {
            attempt++;
            if (attempt < 3) throw Exception('fail');
            return 'ok';
          },
          maxRetries: 3,
        );
        expect(result, equals('ok'));
        expect(attempt, equals(3));
      });

      test('Бросает исключение после исчерпания всех попыток', () async {
        int calls = 0;
        await expectLater(
          () => fetchWithRetryAnswer(
            () async {
              calls++;
              throw const NetworkException('Ошибка');
            },
            maxRetries: 3,
          ),
          throwsA(isA<NetworkException>()),
        );
        expect(calls, equals(3));
      });

      test('maxRetries=1 → не повторяет попытку', () async {
        int calls = 0;
        await expectLater(
          () => fetchWithRetryAnswer(
            () async {
              calls++;
              throw Exception('fail');
            },
            maxRetries: 1,
          ),
          throwsException,
        );
        expect(calls, equals(1));
      });

      test('Работает с разными типами T', () async {
        final intResult = await fetchWithRetryAnswer(() async => 42);
        expect(intResult, equals(42));

        final listResult = await fetchWithRetryAnswer(() async => [1, 2, 3]);
        expect(listResult, equals([1, 2, 3]));
      });
    });

    group('Обработка ошибок', () {
      test('NetworkException реализует Exception', () {
        expect(const NetworkException('test'), isA<Exception>());
      });

      test('NetworkException.toString содержит сообщение', () {
        const e = NetworkException('тест сообщение');
        expect(e.toString(), contains('тест сообщение'));
      });
    });
  });
}
