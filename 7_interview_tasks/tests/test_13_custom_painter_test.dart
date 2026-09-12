import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_13_custom_painter.dart) ─────────────────

class ChartData {
  final String label;
  final double value;
  const ChartData(this.label, this.value);
}

class BarChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double animationProgress;

  const BarChartPainter({required this.data, required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    throw UnimplementedError();
  }

  Color _colorForValue(double value, double max) {
    throw UnimplementedError();
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    throw UnimplementedError();
  }
}

class BarChart extends StatefulWidget {
  final List<ChartData> data;
  final double height;

  const BarChart({super.key, required this.data, this.height = 200});

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => CustomPaint(
        size: Size(double.infinity, widget.height),
        painter: BarChartPainter(
          data: widget.data,
          animationProgress: _animation.value,
        ),
      ),
    );
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 13 — CustomPainter: BarChart', () {
    group('BarChartPainter.shouldRepaint()', () {
      test('false когда анимация и данные одинаковы', () {
        const data = [ChartData('A', 10), ChartData('B', 20)];
        const painter = BarChartPainter(data: data, animationProgress: 0.5);
        const oldPainter = BarChartPainter(data: data, animationProgress: 0.5);
        expect(painter.shouldRepaint(oldPainter), isFalse);
      });

      test('true когда изменился animationProgress', () {
        const data = [ChartData('A', 10)];
        const painter = BarChartPainter(data: data, animationProgress: 0.8);
        const oldPainter = BarChartPainter(data: data, animationProgress: 0.5);
        expect(painter.shouldRepaint(oldPainter), isTrue);
      });

      test('true когда изменились данные', () {
        const painter = BarChartPainter(
          data: [ChartData('A', 10)],
          animationProgress: 1.0,
        );
        const oldPainter = BarChartPainter(
          data: [ChartData('B', 20)],
          animationProgress: 1.0,
        );
        expect(painter.shouldRepaint(oldPainter), isTrue);
      });
    });

    group('Цвет столбцов (_colorForValue)', () {
      late BarChartPainter painter;

      setUp(() {
        painter = const BarChartPainter(data: [], animationProgress: 1.0);
      });

      test('ratio > 0.7 → зелёный', () {
        expect(
          painter._colorForValueTest(80, 100),
          equals(Colors.green.shade400),
        );
      });

      test('0.4 < ratio <= 0.7 → оранжевый', () {
        expect(
          painter._colorForValueTest(50, 100),
          equals(Colors.orange.shade400),
        );
      });

      test('ratio <= 0.4 → красный', () {
        expect(
          painter._colorForValueTest(30, 100),
          equals(Colors.red.shade400),
        );
      });
    });

    // Хелпер для явного диспоза виджета с анимацией
    Future<void> disposeChart(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
      await tester.pump();
    }

    group('BarChart Widget', () {
      testWidgets('Рендерится без ошибок', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: BarChart(
              data: const [ChartData('A', 10), ChartData('B', 20), ChartData('C', 30)],
            ),
          ),
        ));
        await tester.pump();
        expect(tester.takeException(), isNull);
        await disposeChart(tester);
      });

      testWidgets('Пустые данные не вызывают ошибку', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: BarChart(data: const [])),
        ));
        await tester.pump();
        expect(tester.takeException(), isNull);
        await disposeChart(tester);
      });

      testWidgets('После 800ms анимация завершена', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: BarChart(data: const [ChartData('X', 50)])),
        ));
        await tester.pump(const Duration(milliseconds: 800));
        expect(tester.takeException(), isNull);
        await disposeChart(tester);
      });

      testWidgets('CustomPainter находится в дереве', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: BarChart(data: const [ChartData('Test', 100)])),
        ));
        await tester.pump();
        // BarChart создаёт CustomPaint — проверяем что хотя бы один есть
        expect(find.byType(CustomPaint), findsWidgets);
        await disposeChart(tester);
      });
    });

    group('ChartData', () {
      test('Хранит label и value', () {
        const d = ChartData('Янв', 45.0);
        expect(d.label, equals('Янв'));
        expect(d.value, equals(45.0));
      });
    });
  });
}

// ─── Расширение для тестирования приватного метода ────────────────────────────
extension _TestHelper on BarChartPainter {
  Color _colorForValueTest(double value, double max) =>
      _colorForValue(value, max);
}
