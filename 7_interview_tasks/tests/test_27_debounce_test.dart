import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

import '../task_27_debounce.dart' show DebouncerAnswer, ThrottlerAnswer;

void main() {
  group('Задача 27 — debounce и throttle', () {
    test('debounce вызывает только последнее действие', () {
      fakeAsync((async) {
        final calls = <String>[];
        final debouncer = DebouncerAnswer(
          delay: const Duration(milliseconds: 300),
        );

        debouncer.call(() => calls.add('a'));
        async.elapse(const Duration(milliseconds: 100));
        debouncer.call(() => calls.add('ab'));
        async.elapse(const Duration(milliseconds: 299));
        expect(calls, isEmpty);

        async.elapse(const Duration(milliseconds: 1));
        expect(calls, ['ab']);
        debouncer.dispose();
      });
    });

    test('dispose отменяет отложенный вызов', () {
      fakeAsync((async) {
        final calls = <String>[];
        final debouncer = DebouncerAnswer(
          delay: const Duration(milliseconds: 300),
        );
        debouncer.call(() => calls.add('x'));
        debouncer.dispose();
        async.elapse(const Duration(seconds: 1));
        expect(calls, isEmpty);
      });
    });

    test('throttle пропускает первый вызов и режет следующие', () {
      fakeAsync((async) {
        final calls = <int>[];
        final throttler = ThrottlerAnswer(
          interval: const Duration(milliseconds: 200),
        );

        throttler.call(() => calls.add(1));
        throttler.call(() => calls.add(2));
        expect(calls, [1]);

        async.elapse(const Duration(milliseconds: 200));
        throttler.call(() => calls.add(3));
        expect(calls, [1, 3]);
        throttler.dispose();
      });
    });
  });
}
