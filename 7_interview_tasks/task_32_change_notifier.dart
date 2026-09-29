/// ЗАДАЧА 32 — ChangeNotifier и ListenableBuilder
/// Уровень: Junior / Mid Flutter
/// Тема: ChangeNotifier, notifyListeners, dispose
///
/// Реализуйте [CounterModel] и экран [CounterScreen]:
/// - increment / decrement меняют [count] и уведомляют слушателей
/// - count не уходит ниже 0
/// - экран подписан через ListenableBuilder и показывает текущее значение
/// - в dispose контроллер модели освобождается
///
/// Вопрос: чем ChangeNotifier отличается от setState внутри одного виджета?

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ─── Ваше решение ────────────────────────────────────────────────────────────

class CounterModel extends ChangeNotifier {
  int get count => 0;

  void increment() {
    // TODO
  }

  void decrement() {
    // TODO: не ниже 0
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key, required this.model});

  final CounterModel model;

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: ListenableBuilder + кнопки + и −
    return const SizedBox.shrink();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class CounterModelAnswer extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count == 0) return;
    _count--;
    notifyListeners();
  }
}

class CounterScreenAnswer extends StatefulWidget {
  const CounterScreenAnswer({super.key, required this.model});

  final CounterModelAnswer model;

  @override
  State<CounterScreenAnswer> createState() => _CounterScreenAnswerState();
}

class _CounterScreenAnswerState extends State<CounterScreenAnswer> {
  @override
  void dispose() {
    widget.model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.model,
      builder: (context, _) {
        return Column(
          children: [
            Text('${widget.model.count}', key: const Key('count')),
            ElevatedButton(
              key: const Key('inc'),
              onPressed: widget.model.increment,
              child: const Text('+'),
            ),
            ElevatedButton(
              key: const Key('dec'),
              onPressed: widget.model.decrement,
              child: const Text('−'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: CounterScreenAnswer(model: CounterModelAnswer()),
      ),
    ),
  );
}
