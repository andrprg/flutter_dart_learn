/// ЗАДАЧА 13 — CustomPainter: диаграмма
/// Уровень: Mid Flutter
/// Тема: CustomPainter, Canvas, Paint, анимация
///
/// Реализуйте виджет [BarChart] — простую столбчатую диаграмму:
///   - Принимает список [ChartData] (label + value)
///   - Рисует столбцы с подписями через CustomPainter
///   - Анимация появления (высота столбцов растёт с 0 до значения)
///   - Цвет столбца зависит от значения (зелёный/жёлтый/красный)
///
/// Вопрос: в чём разница между repaint и rebuild?
/// Когда использовать CustomPainter vs обычные виджеты?

import 'package:flutter/material.dart';

// ─── Модель данных ────────────────────────────────────────────────────────────

class ChartData {
  final String label;
  final double value;
  const ChartData(this.label, this.value);
}

// ─── CustomPainter ────────────────────────────────────────────────────────────

class BarChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double animationProgress; // 0.0 – 1.0

  const BarChartPainter({required this.data, required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / (data.length * 2);
    final gap = barWidth;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final normalizedHeight = (item.value / maxValue) * (size.height - 40) * animationProgress;
      final x = i * (barWidth + gap) + gap / 2;
      final rect = Rect.fromLTWH(
        x,
        size.height - 40 - normalizedHeight,
        barWidth,
        normalizedHeight,
      );

      final color = _colorForValue(item.value, maxValue);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        Paint()..color = color,
      );

      // Значение над столбцом
      textPainter
        ..text = TextSpan(
          text: item.value.toStringAsFixed(0),
          style: const TextStyle(color: Colors.black87, fontSize: 11),
        )
        ..layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, rect.top - 16),
      );

      // Подпись под столбцом
      textPainter
        ..text = TextSpan(
          text: item.label,
          style: const TextStyle(color: Colors.black54, fontSize: 11),
        )
        ..layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, size.height - 36),
      );
    }
  }

  Color _colorForValue(double value, double max) {
    final ratio = value / max;
    if (ratio > 0.7) return Colors.green.shade400;
    if (ratio > 0.4) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress || oldDelegate.data != data;
}

// ─── Виджет ───────────────────────────────────────────────────────────────────

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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
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

// ─── Точка входа ─────────────────────────────────────────────────────────────

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(title: const Text('CustomPainter: BarChart')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BarChart(
          height: 300,
          data: const [
            ChartData('Янв', 45),
            ChartData('Фев', 80),
            ChartData('Мар', 35),
            ChartData('Апр', 95),
            ChartData('Май', 60),
            ChartData('Июн', 75),
          ],
        ),
      ),
    ),
  ));
}
