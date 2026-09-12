import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_17_performance.dart) ────────────────────

class GoodPerformanceScreen extends StatefulWidget {
  const GoodPerformanceScreen({super.key});

  @override
  State<GoodPerformanceScreen> createState() => _GoodPerformanceScreenState();
}

class _GoodPerformanceScreenState extends State<GoodPerformanceScreen> {
  int _counter = 0;
  final List<int> _items = List.generate(100, (i) => i);
  late final int _computed = _expensiveCalc();

  int _expensiveCalc() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class _GoodListItem extends StatelessWidget {
  final int index;
  const _GoodListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 17 — Оптимизация производительности', () {
    group('GoodPerformanceScreen', () {
      testWidgets('Рендерится без ошибок', (tester) async {
        await tester.pumpWidget(
            const MaterialApp(home: GoodPerformanceScreen()));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Начальный счётчик = 0', (tester) async {
        await tester.pumpWidget(
            const MaterialApp(home: GoodPerformanceScreen()));
        expect(find.textContaining('Счётчик: 0'), findsOneWidget);
      });

      testWidgets('Кнопка Увеличить работает', (tester) async {
        await tester.pumpWidget(
            const MaterialApp(home: GoodPerformanceScreen()));
        await tester.tap(find.byKey(const Key('incBtn')));
        await tester.pump();
        expect(find.textContaining('Счётчик: 1'), findsOneWidget);
      });

      testWidgets('Использует ListView.builder (не Column)', (tester) async {
        await tester.pumpWidget(
            const MaterialApp(home: GoodPerformanceScreen()));
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('Элементы списка имеют ValueKey', (tester) async {
        await tester.pumpWidget(
            const MaterialApp(home: GoodPerformanceScreen()));
        // Первый видимый элемент должен иметь ключ ValueKey(0)
        expect(find.byKey(const ValueKey(0)), findsOneWidget);
      });

      testWidgets('Элементы используют RepaintBoundary', (tester) async {
        await tester.pumpWidget(
            const MaterialApp(home: GoodPerformanceScreen()));
        expect(find.byType(RepaintBoundary), findsWidgets);
      });

      testWidgets('Вычисление суммы выполняется один раз (late final)', (tester) async {
        // Если _computed — late final, то вычисляется ровно один раз при первом обращении.
        // Тест проверяет, что после нескольких tap счётчик отображается,
        // а сумма не меняется (она кэшируется).
        await tester.pumpWidget(
            const MaterialApp(home: GoodPerformanceScreen()));

        final textBefore = find.byKey(const Key('infoText'));
        final valueBefore = (tester.widget<Text>(textBefore)).data!;

        await tester.tap(find.byKey(const Key('incBtn')));
        await tester.pump();

        final valueAfter =
            (tester.widget<Text>(find.byKey(const Key('infoText')))).data!;

        // Число после "сумма: " должно быть одинаковым
        final sumBefore =
            RegExp(r'сумма: (\d+)').firstMatch(valueBefore)?.group(1);
        final sumAfter =
            RegExp(r'сумма: (\d+)').firstMatch(valueAfter)?.group(1);
        expect(sumBefore, equals(sumAfter));
      });
    });

    group('GoodListItem', () {
      testWidgets('Чётный элемент имеет синий фон', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: _GoodListItem(key: ValueKey(0), index: 0),
          ),
        ));
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, equals(Colors.blue.shade100));
      });

      testWidgets('Нечётный элемент имеет серый фон', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: _GoodListItem(key: ValueKey(1), index: 1),
          ),
        ));
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.color, equals(Colors.grey.shade100));
      });

      testWidgets('Показывает текст "Элемент N"', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: _GoodListItem(key: ValueKey(42), index: 42),
          ),
        ));
        expect(find.text('Элемент 42'), findsOneWidget);
      });
    });

    group('Правила производительности (концептуальные)', () {
      test('const конструктор GoodPerformanceScreen существует', () {
        const widget = GoodPerformanceScreen();
        expect(widget, isA<GoodPerformanceScreen>());
      });

      test('const конструктор _GoodListItem существует', () {
        const item = _GoodListItem(index: 5);
        expect(item, isA<_GoodListItem>());
      });
    });
  });
}
