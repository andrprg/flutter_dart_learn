import 'dart:async';

import 'package:test/test.dart';

import 'stream_task.dart';

void main() {
  group('Stream задачи', () {
    test('countStream отдает числа от 1 до count', () async {
      expect(await countStream(3).toList(), [1, 2, 3]);
    });

    test('collectStream собирает значения', () async {
      expect(await collectStream(Stream.fromIterable(['a', 'b'])), ['a', 'b']);
    });

    test('evenNumbers фильтрует четные', () async {
      expect(await evenNumbers(Stream.fromIterable([1, 2, 3, 4])).toList(), [
        2,
        4,
      ]);
    });

    test('multiplyStream умножает значения', () async {
      expect(await multiplyStream(Stream.fromIterable([1, 2, 3]), 3).toList(), [
        3,
        6,
        9,
      ]);
    });

    test('sumStream суммирует значения', () async {
      expect(await sumStream(Stream.fromIterable([1, 2, 3])), 6);
    });

    test('firstGreaterThan возвращает первое значение выше порога', () async {
      expect(await firstGreaterThan(Stream.fromIterable([1, 4, 2]), 3), 4);
      expect(await firstGreaterThan(Stream.fromIterable([1, 2]), 3), isNull);
    });

    test('recoverWith заменяет ошибку fallback значением', () async {
      final controller = StreamController<int>();
      final valuesFuture = recoverWith(controller.stream, -1).toList();

      controller
        ..add(1)
        ..addError(Exception('boom'))
        ..add(2);
      await controller.close();

      expect(await valuesFuture, [1, -1, 2]);
    });

    test('broadcastFrom создает broadcast stream', () async {
      final stream = broadcastFrom([1, 2, 3]);

      expect(stream.isBroadcast, isTrue);
      expect(await stream.toList(), [1, 2, 3]);
    });

    test('concatStreams склеивает stream последовательно', () async {
      expect(
        await concatStreams(Stream.fromIterable([1, 2]), Stream.value(3))
            .toList(),
        [1, 2, 3],
      );
    });

    test('mergeStreams объединяет события', () async {
      final merged = await mergeStreams(Stream.value(1), Stream.value(2))
          .toList();

      expect(merged, containsAll([1, 2]));
    });

    test('distinctAdjacent убирает соседние повторы', () async {
      expect(
        await distinctAdjacent(Stream.fromIterable([1, 1, 2, 1, 1])).toList(),
        [1, 2, 1],
      );
    });

    test('progressStream отдает прогресс до 100', () async {
      expect(await progressStream(40).toList(), [0, 40, 80, 100]);
    });

    test('searchStates преобразует запросы в состояния', () async {
      expect(
        await searchStates(Stream.fromIterable(['', 'dart'])).toList(),
        [
          const SearchState.idle(),
          const SearchState.loading('dart'),
          const SearchState.data('dart'),
        ],
      );
    });

    test('createCounterBus публикует значения', () async {
      final bus = createCounterBus();
      final valuesFuture = bus.stream.take(2).toList();

      bus.add(1);
      bus.add(2);

      expect(await valuesFuture, [1, 2]);
      await bus.close();
    });
  });
}
