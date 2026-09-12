import 'dart:async';
import 'package:test/test.dart';
import 'future_task.dart';

void main() {
  // ─── Задача 1 ──────────────────────────────────────────────────────
  group('fetchUserName', () {
    test('возвращает Future<String>', () {
      expect(fetchUserName(), isA<Future<String>>());
    });

    test('возвращает "Иван Иванов" (с задержкой около 2 секунд)', () async {
      final sw = Stopwatch()..start();
      final name = await fetchUserName();
      sw.stop();

      expect(name, 'Иван Иванов');
      expect(
        sw.elapsedMilliseconds,
        inInclusiveRange(1800, 6000),
        reason: 'Ожидалась задержка около 2 секунд',
      );
    });
  });

  // ─── Задача 2 ──────────────────────────────────────────────────────
  group('getNumber', () {
    test('возвращает Future<int>', () {
      expect(getNumber(), isA<Future<int>>());
    });

    test('значение равно 42', () async {
      expect(await getNumber(), 42);
    });

    test('выводит строки в правильном порядке', () async {
      final output = <String>[];

      await runZoned(
        () async {
          print('До запроса');
          final number = await getNumber();
          print(number);
          print('После запроса');
        },
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) {
            output.add(line);
          },
        ),
      );

      expect(output, equals(['До запроса', '42', 'После запроса']));
    });
  });
}
