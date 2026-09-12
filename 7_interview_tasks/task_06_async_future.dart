/// ЗАДАЧА 6 — Async/Await и Future
/// Уровень: Mid
/// Тема: Асинхронное программирование, Future, обработка ошибок
///
/// Реализуйте функцию [fetchUserData], которая:
///   1. Симулирует задержку сети (1 секунда)
///   2. С вероятностью, управляемой [shouldFail], выбрасывает исключение
///   3. Возвращает объект [User] при успехе
///
/// Также реализуйте [fetchWithRetry] — функцию, которая повторяет
/// запрос до [maxRetries] раз при неудаче и возвращает результат
/// первого успешного вызова.

// ─── Модель ──────────────────────────────────────────────────────────────────

class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

// ─── Ваше решение ────────────────────────────────────────────────────────────

Future<User> fetchUserData(int userId, {bool shouldFail = false}) async {
  // TODO: реализуйте функцию
  throw UnimplementedError();
}

Future<T> fetchWithRetry<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
}) async {
  // TODO: реализуйте повтор при ошибке
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

Future<User> fetchUserDataAnswer(int userId, {bool shouldFail = false}) async {
  await Future.delayed(const Duration(milliseconds: 500));
  if (shouldFail) {
    throw const NetworkException('Сервер недоступен');
  }
  return User(id: userId, name: 'Иван Иванов', email: 'ivan@example.com');
}

Future<T> fetchWithRetryAnswer<T>(
  Future<T> Function() operation, {
  int maxRetries = 3,
}) async {
  int attempt = 0;
  while (true) {
    try {
      attempt++;
      return await operation();
    } catch (e) {
      if (attempt >= maxRetries) rethrow;
      print('Попытка $attempt не удалась, повтор...');
      await Future.delayed(Duration(milliseconds: 100 * attempt));
    }
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() async {
  print('=== Задача 6: Async/Future/Retry ===\n');

  // Успешный запрос
  final user = await fetchUserDataAnswer(1);
  print('Успех: $user');

  // Запрос с ретраем (первые 2 падают, 3-й успешен)
  int attempt = 0;
  final result = await fetchWithRetryAnswer(
    () async {
      attempt++;
      if (attempt < 3) throw const NetworkException('Ошибка');
      return await fetchUserDataAnswer(42);
    },
    maxRetries: 3,
  );
  print('С ретраем ($attempt попыток): $result');

  // Все попытки исчерпаны
  try {
    await fetchWithRetryAnswer(
      () => fetchUserDataAnswer(0, shouldFail: true),
      maxRetries: 2,
    );
  } on NetworkException catch (e) {
    print('Ожидаемая ошибка: $e');
  }
}
