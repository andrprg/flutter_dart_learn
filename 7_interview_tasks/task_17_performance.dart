/// ЗАДАЧА 17 — Оптимизация производительности Flutter
/// Уровень: Senior Flutter
/// Тема: const, RepaintBoundary, ListView.builder, мемоизация, профилирование
///
/// Найдите и исправьте проблемы производительности в коде ниже.
/// После каждого исправления — объясните, почему это ускоряет приложение.
///
/// Проблемы для поиска (8 штук):
///   1. Отсутствие const у неизменяемых виджетов
///   2. Использование Column + SingleChildScrollView вместо ListView.builder
///   3. Ненужный rebuild дерева из-за setState в родителе
///   4. Отсутствие RepaintBoundary для часто перерисовываемых виджетов
///   5. Использование Image.network без кэширования
///   6. Тяжёлые вычисления в build()
///   7. Отсутствие ключей у элементов списка
///   8. Ненужный MediaQuery.of(context) в глубоко вложенном виджете

import 'package:flutter/material.dart';

// ─── ПЛОХОЙ КОД (найдите проблемы) ───────────────────────────────────────────

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

class BadPerformanceScreen extends StatefulWidget {
  // ПРОБЛЕМА 1: нет const конструктора
  BadPerformanceScreen({super.key});

  @override
  State<BadPerformanceScreen> createState() => _BadPerformanceScreenState();
}

class _BadPerformanceScreenState extends State<BadPerformanceScreen> {
  int _counter = 0;
  List<int> _items = List.generate(1000, (i) => i);

  // ПРОБЛЕМА 7: тяжёлые вычисления прямо в build
  int _expensiveCalc() {
    int sum = 0;
    for (int i = 0; i < 10000; i++) sum += i;
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    // ПРОБЛЕМА 6: вызов тяжёлой функции в build
    final computed = _expensiveCalc();

    return Scaffold(
      appBar: AppBar(
        // ПРОБЛЕМА 1: нет const
        title: Text('Плохая производительность'),
      ),
      body: Column(
        children: [
          Text('Счётчик: $_counter, сумма: $computed'),
          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: Text('Увеличить'),
          ),
          // ПРОБЛЕМА 2: Column+SingleChildScrollView вместо ListView.builder
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _items.map((i) => _BadListItem(index: i)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadListItem extends StatelessWidget {
  final int index;
  // ПРОБЛЕМА 3: нет const конструктора
  _BadListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    // ПРОБЛЕМА 8: MediaQuery в каждом элементе
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 50,
      color: index.isEven ? Colors.blue.shade100 : Colors.grey.shade100,
      child: Text('Элемент $index'),
    );
  }
}

// ─── ХОРОШИЙ КОД (эталонное решение) ─────────────────────────────────────────

class GoodPerformanceScreen extends StatefulWidget {
  const GoodPerformanceScreen({super.key}); // ✓ const конструктор

  @override
  State<GoodPerformanceScreen> createState() => _GoodPerformanceScreenState();
}

class _GoodPerformanceScreenState extends State<GoodPerformanceScreen> {
  int _counter = 0;
  final List<int> _items = List.generate(1000, (i) => i);

  // ✓ Кэшируем результат: вычисляем один раз
  late final int _computed = _expensiveCalc();

  int _expensiveCalc() {
    int sum = 0;
    for (int i = 0; i < 10000; i++) sum += i;
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Хорошая производительность')), // ✓ const
      body: Column(
        children: [
          Text('Счётчик: $_counter, сумма: $_computed'),
          ElevatedButton(
            onPressed: () => setState(() => _counter++),
            child: const Text('Увеличить'), // ✓ const
          ),
          // ✓ ListView.builder — строит только видимые элементы
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (ctx, i) => _GoodListItem(
                key: ValueKey(_items[i]), // ✓ ключи
                index: _items[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoodListItem extends StatelessWidget {
  final int index;
  const _GoodListItem({super.key, required this.index}); // ✓ const

  @override
  Widget build(BuildContext context) {
    // ✓ Ширину не читаем из MediaQuery — используем double.infinity
    return RepaintBoundary( // ✓ RepaintBoundary изолирует перерисовку
      child: Container(
        width: double.infinity,
        height: 50,
        color: index.isEven ? Colors.blue.shade100 : Colors.grey.shade100,
        child: Text('Элемент $index'),
      ),
    );
  }
}

/// ШПАРГАЛКА: Правила производительности Flutter
/// ──────────────────────────────────────────────
/// 1. const везде, где возможно — Flutter не пересоздаёт const-виджеты
/// 2. ListView.builder вместо Column+map — строит только видимые элементы
/// 3. Избегайте тяжёлых вычислений в build() — используйте late final или Provider
/// 4. RepaintBoundary — ограничивает зону перерисовки
/// 5. ValueKey/ObjectKey — помогает Flutter переиспользовать элементы
/// 6. MediaQuery.of(context) → только в корне, передавайте значения вниз
/// 7. Используйте профилировщик Flutter DevTools для поиска janks

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GoodPerformanceScreen(),
  ));
}
