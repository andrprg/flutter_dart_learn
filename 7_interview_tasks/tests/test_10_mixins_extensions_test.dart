import 'package:test/test.dart';

// ─── Реализация (скопирована из task_10_mixins_extensions.dart) ──────────────

mixin Loggable {
  final _logs = <String>[];

  void log(String message) {
    throw UnimplementedError();
  }

  List<String> get logs => throw UnimplementedError();
}

extension StringExtensions on String {
  String toTitleCase() {
    throw UnimplementedError();
  }

  String toSnakeCase() {
    throw UnimplementedError();
  }

  bool get isValidEmail => throw UnimplementedError();

  String truncate(int maxLength, {String ellipsis = '...'}) {
    throw UnimplementedError();
  }
}

extension ListExtensions<T> on List<T> {
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    throw UnimplementedError();
  }

  List<T> distinct() {
    throw UnimplementedError();
  }
}

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
  throw UnimplementedError();
}

class _LoggableService with Loggable {
  void doWork(String task) => log('Выполняю: $task');
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 10 — Mixins & Extensions', () {
    group('StringExtensions.toTitleCase()', () {
      test('"hello world" → "Hello World"', () {
        expect('hello world'.toTitleCase(), equals('Hello World'));
      });

      test('"dart flutter" → "Dart Flutter"', () {
        expect('dart flutter'.toTitleCase(), equals('Dart Flutter'));
      });

      test('"HELLO WORLD" → "Hello World" (нормализует регистр)', () {
        expect('HELLO WORLD'.toTitleCase(), equals('Hello World'));
      });

      test('Одно слово → первая буква заглавная', () {
        expect('hello'.toTitleCase(), equals('Hello'));
      });

      test('Пустая строка → пустая строка', () {
        expect(''.toTitleCase(), equals(''));
      });
    });

    group('StringExtensions.toSnakeCase()', () {
      test('"camelCase" → "camel_case"', () {
        expect('camelCase'.toSnakeCase(), equals('camel_case'));
      });

      test('"camelCaseString" → "camel_case_string"', () {
        expect('camelCaseString'.toSnakeCase(), equals('camel_case_string'));
      });

      test('"myFunctionName" → "my_function_name"', () {
        expect('myFunctionName'.toSnakeCase(), equals('my_function_name'));
      });

      test('Уже snake_case не меняется', () {
        expect('snake_case'.toSnakeCase(), equals('snake_case'));
      });

      test('Строчная без заглавных → без изменений', () {
        expect('simple'.toSnakeCase(), equals('simple'));
      });
    });

    group('StringExtensions.isValidEmail', () {
      test('"user@example.com" → true', () {
        expect('user@example.com'.isValidEmail, isTrue);
      });

      test('"test.name@domain.org" → true', () {
        expect('test.name@domain.org'.isValidEmail, isTrue);
      });

      test('"user@sub.domain.com" → true', () {
        expect('user@sub.domain.com'.isValidEmail, isTrue);
      });

      test('"notanemail" → false', () {
        expect('notanemail'.isValidEmail, isFalse);
      });

      test('"@no-local.com" → false', () {
        expect('@no-local.com'.isValidEmail, isFalse);
      });

      test('"no-at-sign" → false', () {
        expect('no-at-sign'.isValidEmail, isFalse);
      });

      test('"user@.com" → false', () {
        expect('user@.com'.isValidEmail, isFalse);
      });
    });

    group('StringExtensions.truncate()', () {
      test('Строка короче maxLength → без изменений', () {
        expect('hello'.truncate(10), equals('hello'));
      });

      test('Строка равна maxLength → без изменений', () {
        expect('hello'.truncate(5), equals('hello'));
      });

      test('Строка длиннее → обрезается с "..."', () {
        expect('Hello World'.truncate(8), equals('Hello...'));
      });

      test('Кастомный ellipsis', () {
        // truncate(7, ellipsis:'…') → substring(0, 7-1)+'…' = 'Hello …'
        expect('Hello World'.truncate(7, ellipsis: '…'), equals('Hello …'));
      });

      test('maxLength = длина ellipsis → только ellipsis', () {
        expect('Hello World'.truncate(3), equals('...'));
      });
    });

    group('ListExtensions.groupBy()', () {
      test('Группировка чисел по чётности', () {
        final result = [1, 2, 3, 4, 5, 6].groupBy((n) => n.isEven ? 'even' : 'odd');
        expect(result['even'], equals([2, 4, 6]));
        expect(result['odd'], equals([1, 3, 5]));
      });

      test('Группировка строк по длине', () {
        final result = ['a', 'bb', 'c', 'dd', 'eee'].groupBy((s) => s.length);
        expect(result[1], equals(['a', 'c']));
        expect(result[2], equals(['bb', 'dd']));
        expect(result[3], equals(['eee']));
      });

      test('Пустой список → пустая Map', () {
        final result = <int>[].groupBy((n) => n);
        expect(result, isEmpty);
      });

      test('Все элементы одной группы', () {
        final result = [1, 2, 3].groupBy((_) => 'all');
        expect(result['all'], equals([1, 2, 3]));
      });
    });

    group('ListExtensions.distinct()', () {
      test('[1,2,2,3,3,3] → [1,2,3]', () {
        expect([1, 2, 2, 3, 3, 3].distinct(), equals([1, 2, 3]));
      });

      test('Порядок сохраняется', () {
        expect([3, 1, 2, 1, 3].distinct(), equals([3, 1, 2]));
      });

      test('Без дубликатов → без изменений', () {
        expect([1, 2, 3].distinct(), equals([1, 2, 3]));
      });

      test('Пустой список → пустой список', () {
        expect(<int>[].distinct(), isEmpty);
      });

      test('Все одинаковые → один элемент', () {
        expect([5, 5, 5, 5].distinct(), equals([5]));
      });
    });

    group('Result<T> (Sealed class)', () {
      test('tryRun возвращает Success при успехе', () {
        final result = tryRun(() => 42);
        expect(result, isA<Success<int>>());
        expect((result as Success).data, equals(42));
      });

      test('tryRun возвращает Failure при исключении', () {
        final result = tryRun<int>(() => throw Exception('oops'));
        expect(result, isA<Failure<int>>());
        expect((result as Failure).error, contains('oops'));
      });

      test('Switch exhaustive по Success/Failure', () {
        final result = tryRun(() => 'hello');
        final msg = switch (result) {
          Success(:final data) => 'ok: $data',
          Failure(:final error) => 'err: $error',
        };
        expect(msg, equals('ok: hello'));
      });

      test('Failure содержит StackTrace', () {
        final result = tryRun<int>(() => throw Exception('test'));
        expect((result as Failure).stackTrace, isNotNull);
      });
    });

    group('Mixin Loggable', () {
      test('Начально логи пусты', () {
        final svc = _LoggableService();
        expect(svc.logs, isEmpty);
      });

      test('log() добавляет запись в logs', () {
        final svc = _LoggableService();
        svc.log('тест');
        expect(svc.logs.length, equals(1));
      });

      test('Лог содержит переданное сообщение', () {
        final svc = _LoggableService();
        svc.log('важное сообщение');
        expect(svc.logs.first, contains('важное сообщение'));
      });

      test('Лог содержит временную метку ISO8601', () {
        final svc = _LoggableService();
        svc.log('событие');
        expect(svc.logs.first, matches(RegExp(r'\d{4}-\d{2}-\d{2}T')));
      });

      test('Несколько вызовов накапливают логи', () {
        final svc = _LoggableService();
        svc.doWork('задача 1');
        svc.doWork('задача 2');
        svc.doWork('задача 3');
        expect(svc.logs.length, equals(3));
      });

      test('logs — неизменяемый список (UnmodifiableListView)', () {
        final svc = _LoggableService();
        svc.log('test');
        expect(() => svc.logs.add('hack'), throwsUnsupportedError);
      });
    });
  });
}
