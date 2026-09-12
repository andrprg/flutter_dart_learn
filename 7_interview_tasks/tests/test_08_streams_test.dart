import 'dart:async';
import 'package:test/test.dart';

// ─── Реализация (скопирована из task_08_streams.dart) ────────────────────────

Stream<int> numberStreamAnswer(int n,
    {Duration delay = const Duration(milliseconds: 5)}) async* {
  throw UnimplementedError();
}

Stream<double> runningAverageAnswer(Stream<int> source) async* {
  throw UnimplementedError();
}

class EventBus {
  final _controller = StreamController<Object>.broadcast();

  void emit(Object event) => throw UnimplementedError();
  Stream<T> on<T>() => throw UnimplementedError();
  void dispose() => _controller.close();
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 08 — Streams', () {
    group('numberStream(n)', () {
      test('numberStream(5) эмитит [1,2,3,4,5]', () async {
        final values = await numberStreamAnswer(5).toList();
        expect(values, equals([1, 2, 3, 4, 5]));
      });

      test('numberStream(1) эмитит [1]', () async {
        final values = await numberStreamAnswer(1).toList();
        expect(values, equals([1]));
      });

      test('numberStream(0) — пустой поток', () async {
        final values = await numberStreamAnswer(0).toList();
        expect(values, isEmpty);
      });

      test('numberStream(10) имеет 10 элементов', () async {
        final values = await numberStreamAnswer(10).toList();
        expect(values.length, equals(10));
      });

      test('Элементы идут по порядку', () async {
        final values = await numberStreamAnswer(8).toList();
        for (int i = 0; i < values.length - 1; i++) {
          expect(values[i + 1], equals(values[i] + 1));
        }
      });
    });

    group('runningAverage(stream)', () {
      test('Среднее для [1] = 1.0', () async {
        final values =
            await runningAverageAnswer(Stream.fromIterable([1])).toList();
        expect(values, equals([1.0]));
      });

      test('Среднее для [1,2] = [1.0, 1.5]', () async {
        final values =
            await runningAverageAnswer(Stream.fromIterable([1, 2])).toList();
        expect(values, equals([1.0, 1.5]));
      });

      test('Среднее для [1,2,3,4,5] = [1.0, 1.5, 2.0, 2.5, 3.0]', () async {
        final values =
            await runningAverageAnswer(Stream.fromIterable([1, 2, 3, 4, 5]))
                .toList();
        expect(values, equals([1.0, 1.5, 2.0, 2.5, 3.0]));
      });

      test('Количество выходных элементов = количеству входных', () async {
        final input = [10, 20, 30, 40];
        final values =
            await runningAverageAnswer(Stream.fromIterable(input)).toList();
        expect(values.length, equals(input.length));
      });

      test('Последний элемент = реальное среднее всего потока', () async {
        final input = [4, 8, 12, 16];
        final values =
            await runningAverageAnswer(Stream.fromIterable(input)).toList();
        final expected = input.reduce((a, b) => a + b) / input.length;
        expect(values.last, closeTo(expected, 0.001));
      });

      test('Работает с потоком numberStream', () async {
        final avgs =
            await runningAverageAnswer(numberStreamAnswer(5)).toList();
        expect(avgs.length, equals(5));
        expect(avgs.first, equals(1.0));
        expect(avgs.last, closeTo(3.0, 0.001));
      });
    });

    group('EventBus', () {
      late EventBus bus;

      setUp(() => bus = EventBus());
      tearDown(() => bus.dispose());

      test('Подписчик получает событие своего типа', () async {
        final received = <String>[];
        bus.on<String>().listen(received.add);
        bus.emit('hello');
        bus.emit('world');
        await Future.delayed(Duration.zero);
        expect(received, equals(['hello', 'world']));
      });

      test('Подписчик не получает события другого типа', () async {
        final strings = <String>[];
        final ints = <int>[];
        bus.on<String>().listen(strings.add);
        bus.on<int>().listen(ints.add);
        bus.emit('text');
        bus.emit(42);
        bus.emit('more');
        await Future.delayed(Duration.zero);
        expect(strings, equals(['text', 'more']));
        expect(ints, equals([42]));
      });

      test('Несколько подписчиков одного типа получают все события', () async {
        final sub1 = <String>[];
        final sub2 = <String>[];
        bus.on<String>().listen(sub1.add);
        bus.on<String>().listen(sub2.add);
        bus.emit('event');
        await Future.delayed(Duration.zero);
        expect(sub1, contains('event'));
        expect(sub2, contains('event'));
      });

      test('Пользовательские классы маршрутизируются правильно', () async {
        final logins = <_LoginEvent>[];
        final logouts = <_LogoutEvent>[];
        bus.on<_LoginEvent>().listen(logins.add);
        bus.on<_LogoutEvent>().listen(logouts.add);
        bus.emit(_LoginEvent('alice'));
        bus.emit(_LogoutEvent('bob'));
        bus.emit(_LoginEvent('charlie'));
        await Future.delayed(Duration.zero);
        expect(logins.map((e) => e.user), equals(['alice', 'charlie']));
        expect(logouts.map((e) => e.user), equals(['bob']));
      });
    });
  });
}

class _LoginEvent {
  final String user;
  _LoginEvent(this.user);
}

class _LogoutEvent {
  final String user;
  _LogoutEvent(this.user);
}
