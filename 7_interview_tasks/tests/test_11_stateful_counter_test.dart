import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_11_stateful_counter.dart) ───────────────

class HistoryCounterAnswer extends StatefulWidget {
  const HistoryCounterAnswer({super.key});

  @override
  State<HistoryCounterAnswer> createState() => _HistoryCounterAnswerState();
}

class _HistoryCounterAnswerState extends State<HistoryCounterAnswer> {
  int _count = 0;
  final List<int> _history = [];
  final List<String> _log = [];

  void _change(int delta, String label) {
    throw UnimplementedError();
  }

  void _reset() {
    throw UnimplementedError();
  }

  void _undo() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Счётчик с историей')),
      body: Column(
        children: [
          Text('$_count', key: const Key('counter'), style: Theme.of(context).textTheme.displayLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(key: const Key('dec'), onPressed: () => _change(-1, '-1'), child: const Text('-1')),
              const SizedBox(width: 8),
              ElevatedButton(key: const Key('reset'), onPressed: _reset, child: const Text('Сброс')),
              const SizedBox(width: 8),
              ElevatedButton(key: const Key('inc'), onPressed: () => _change(1, '+1'), child: const Text('+1')),
              const SizedBox(width: 8),
              OutlinedButton(
                key: const Key('undo'),
                onPressed: _history.isNotEmpty ? _undo : null,
                child: const Text('Undo'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              key: const Key('history'),
              itemCount: _log.length,
              itemBuilder: (_, i) => ListTile(
                key: ValueKey('log_$i'),
                leading: Text('${_log.length - i}'),
                title: Text(_log[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

Widget _buildTestApp() => const MaterialApp(home: HistoryCounterAnswer());

void main() {
  group('Задача 11 — StatefulWidget: HistoryCounter', () {
    testWidgets('Начальное значение счётчика = 0', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      expect(find.text('0'), findsOneWidget);
    });

    String _counterText(WidgetTester tester) =>
        (tester.widget<Text>(find.byKey(const Key('counter')))).data!;

    testWidgets('Кнопка +1 увеличивает счётчик', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.tap(find.byKey(const Key('inc')));
      await tester.pump();
      expect(_counterText(tester), equals('1'));
    });

    testWidgets('Кнопка -1 уменьшает счётчик', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('dec')));
      await tester.pump();
      expect(_counterText(tester), equals('1'));
    });

    testWidgets('Счётчик может уходить в отрицательные', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.tap(find.byKey(const Key('dec')));
      await tester.pump();
      expect(_counterText(tester), equals('-1'));
    });

    testWidgets('Кнопка Сброс устанавливает 0', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('inc')));
      await tester.pump();
      expect(_counterText(tester), equals('3'));

      await tester.tap(find.byKey(const Key('reset')));
      await tester.pump();
      expect(_counterText(tester), equals('0'));
    });

    testWidgets('Undo недоступен при пустой истории', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.pump();
      final undoButton = tester.widget<OutlinedButton>(find.byKey(const Key('undo')));
      expect(undoButton.onPressed, isNull);
    });

    testWidgets('После действия Undo становится активным', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.tap(find.byKey(const Key('inc')));
      await tester.pump();
      final undoButton = tester.widget<OutlinedButton>(find.byKey(const Key('undo')));
      expect(undoButton.onPressed, isNotNull);
    });

    testWidgets('Undo отменяет последнее действие', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('inc')));
      await tester.pump();
      final counterText = (tester.widget<Text>(find.byKey(const Key('counter')))).data!;
      expect(counterText, equals('2'));

      await tester.tap(find.byKey(const Key('undo')));
      await tester.pump();
      final after = (tester.widget<Text>(find.byKey(const Key('counter')))).data!;
      expect(after, equals('1'));
    });

    testWidgets('История пополняется после каждого действия', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('dec')));
      await tester.pump();
      // В истории должны быть 3 записи
      expect(find.byKey(const ValueKey('log_0')), findsOneWidget);
      expect(find.byKey(const ValueKey('log_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('log_2')), findsOneWidget);
    });

    testWidgets('Несколько Undo подряд откатывают историю', (tester) async {
      await tester.pumpWidget(_buildTestApp());
      // 0 → 1 → 2 → 3
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('inc')));
      await tester.tap(find.byKey(const Key('inc')));
      await tester.pump();

      // Откат до 0
      await tester.tap(find.byKey(const Key('undo')));
      await tester.tap(find.byKey(const Key('undo')));
      await tester.tap(find.byKey(const Key('undo')));
      await tester.pump();
      final text = (tester.widget<Text>(find.byKey(const Key('counter')))).data!;
      expect(text, equals('0'));
    });
  });
}
