/// ЗАДАЧА 10 — Миксины и Extension-методы
/// Уровень: Mid / Senior
/// Тема: Mixin, extension, sealed classes (Dart 3)
///
/// Реализуйте:
///   1. Миксин [Serializable] — добавляет метод toJson() для любого класса
///   2. Миксин [Loggable] — добавляет логирование всех действий
///   3. Extension [StringExtensions] на String с полезными методами
///   4. Extension [ListExtensions] на List<T> с методом [groupBy]
///   5. Sealed class [Result<T>] — Success / Failure паттерн

// ─── 1. Миксины ──────────────────────────────────────────────────────────────

mixin Loggable {
  final _logs = <String>[];

  void log(String message) {
    final entry = '[${DateTime.now().toIso8601String()}] $message';
    _logs.add(entry);
    print(entry);
  }

  List<String> get logs => List.unmodifiable(_logs);
}

// ─── 2. Extension на String ───────────────────────────────────────────────────

extension StringExtensions on String {
  /// "hello world" → "Hello World"
  String toTitleCase() {
    return split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  /// "camelCaseString" → "camel_case_string"
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '_${m.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Возвращает true если строка — валидный email
  bool get isValidEmail => RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(this);

  /// Обрезает строку до [maxLength] и добавляет "..." если она длиннее
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
}

// ─── 3. Extension на List ─────────────────────────────────────────────────────

extension ListExtensions<T> on List<T> {
  /// Группирует элементы списка по ключу
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final result = <K, List<T>>{};
    for (final item in this) {
      final key = keySelector(item);
      (result[key] ??= []).add(item);
    }
    return result;
  }

  /// Возвращает список без дубликатов (с сохранением порядка)
  List<T> distinct() {
    final seen = <T>{};
    return where(seen.add).toList();
  }
}

// ─── 4. Sealed class Result<T> ───────────────────────────────────────────────

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String error;
  final StackTrace? stackTrace;
  const Failure(this.error, [this.stackTrace]);
}

Result<T> tryRun<T>(T Function() fn) {
  try {
    return Success(fn());
  } catch (e, st) {
    return Failure(e.toString(), st);
  }
}

// ─── Пример использования ────────────────────────────────────────────────────

class UserService with Loggable {
  Result<String> getUsername(int id) {
    log('Запрос пользователя #$id');
    return tryRun(() {
      if (id <= 0) throw ArgumentError('ID должен быть положительным');
      return 'User_$id';
    });
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  print('=== Задача 10: Mixins & Extensions ===\n');

  // String extensions
  print('toTitleCase: ${'hello world'.toTitleCase()}');
  print('toSnakeCase: ${'camelCaseString'.toSnakeCase()}');
  print('isValidEmail: ${'user@example.com'.isValidEmail}');
  print('truncate: ${'Очень длинная строка для примера'.truncate(15)}');

  // List extensions
  final nums = [1, 2, 3, 4, 5, 6, 7, 8];
  final grouped = nums.groupBy((n) => n % 2 == 0 ? 'чётные' : 'нечётные');
  print('\ngroupBy: $grouped');

  final withDups = [1, 2, 2, 3, 3, 3, 4];
  print('distinct: ${withDups.distinct()}');

  // Result sealed class
  print('\nResult pattern:');
  final service = UserService();
  switch (service.getUsername(5)) {
    case Success(:final data):
      print('Успех: $data');
    case Failure(:final error):
      print('Ошибка: $error');
  }
  switch (service.getUsername(-1)) {
    case Success(:final data):
      print('Успех: $data');
    case Failure(:final error):
      print('Ошибка: $error');
  }
}
