import 'package:test/test.dart';

import 'eventloop_task.dart';

void main() {
  group('пример', () {
    test('синхронный код раньше microtask', () async {
      expect(await exampleSyncThenMicrotask(), ['A', 'C', 'B']);
    });
  });

  group('orderSyncAndMicrotask', () {
    test('microtask выполняется после синхронного кода', () async {
      expect(await orderSyncAndMicrotask(), ['A', 'C', 'B']);
    });
  });

  group('orderSyncMicrotaskAndEvent', () {
    test('microtask раньше event', () async {
      expect(
        await orderSyncMicrotaskAndEvent(),
        ['sync', 'micro', 'event'],
      );
    });
  });

  group('orderIgnoresRegistrationTime', () {
    test('порядок регистрации event/microtask не важнее типа очереди',
        () async {
      expect(
        await orderIgnoresRegistrationTime(),
        ['sync', 'micro', 'event'],
      );
    });
  });

  group('nestedMicrotasksBeforeEvent', () {
    test('вложенный microtask всё ещё раньше event', () async {
      expect(
        await nestedMicrotasksBeforeEvent(),
        ['sync', 'm1', 'm2', 'event'],
      );
    });
  });

  group('completedFutureThenIsMicrotask', () {
    test('then у Future.value — это microtask', () async {
      expect(await completedFutureThenIsMicrotask(), ['sync', 'then']);
    });
  });

  group('asyncRunsSyncUntilAwait', () {
    test('async-тело синхронно до первого await', () async {
      expect(
        await asyncRunsSyncUntilAwait(),
        ['before', 'async-start', 'after', 'async-resume'],
      );
    });
  });

  group('eventsAreFifo', () {
    test('события event queue идут в порядке постановки', () async {
      expect(await eventsAreFifo(), ['sync', 'e1', 'e2']);
    });
  });

  group('microtaskBetweenEvents', () {
    test('microtask из event выполняется до следующего event', () async {
      expect(await microtaskBetweenEvents(), ['e1', 'micro', 'e2']);
    });
  });

  group('completerThenIsNotSync', () {
    test('complete() не вызывает then синхронно', () async {
      expect(
        await completerThenIsNotSync(),
        ['before-complete', 'after-complete', 'then'],
      );
    });
  });

  group('futureSyncRunsImmediately', () {
    test('Future.sync выполняет колбэк сразу', () async {
      expect(
        await futureSyncRunsImmediately(),
        ['sync-cb', 'sync', 'event'],
      );
    });
  });

  group('thenChainAfterEvent', () {
    test('цепочка then после event идёт как microtask', () async {
      expect(
        await thenChainAfterEvent(),
        ['sync', 'event', 'then-1', 'then-2'],
      );
    });
  });

  group('nestedEventNeedsExtraTick', () {
    test('вложенный Future() не успевает в том же tick', () async {
      expect(await nestedEventNeedsExtraTick(), ['e1', 'e2']);
    });
  });

  group('predictSimpleOrder', () {
    test('A, D синхронно, затем microtask C, затем event B', () {
      expect(predictSimpleOrder(), ['A', 'D', 'C', 'B']);
    });
  });

  group('predictAsyncFunctionOrder', () {
    test('foo стартует синхронно, resume после microtask', () {
      expect(predictAsyncFunctionOrder(), ['4', '1', '5', '2', '3']);
    });
  });

  group('predictComplexOrder', () {
    test('сначала все microtask в порядке постановки, затем events', () {
      expect(
        predictComplexOrder(),
        ['1', '5', '3', '4', '6', '8', '2', '7'],
      );
    });
  });
}
