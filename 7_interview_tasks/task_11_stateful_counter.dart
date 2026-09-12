/// ЗАДАЧА 11 — StatefulWidget: счётчик с историей
/// Уровень: Junior Flutter
/// Тема: StatefulWidget, setState, lifecycle
///
/// Реализуйте виджет [HistoryCounter]:
///   - Отображает текущее значение счётчика
///   - Кнопки: +1, -1, сброс
///   - Ведёт историю всех изменений (список строк)
///   - Кнопка "Отменить" (undo) — возвращает предыдущее значение
///   - История отображается в ListView
///
/// Вопрос на собеседовании:
///   Почему нельзя обновлять state напрямую (this._count++),
///   а нужно использовать setState?

import 'package:flutter/material.dart';

// ─── Ваше решение ────────────────────────────────────────────────────────────

class HistoryCounter extends StatefulWidget {
  const HistoryCounter({super.key});

  @override
  State<HistoryCounter> createState() => _HistoryCounterState();
}

class _HistoryCounterState extends State<HistoryCounter> {
  // TODO: реализуйте state
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('TODO: реализуйте виджет')),
    );
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

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
    setState(() {
      _history.add(_count);
      _count += delta;
      _log.insert(0, '$label → $_count');
    });
  }

  void _reset() {
    setState(() {
      _history.add(_count);
      _count = 0;
      _log.insert(0, 'Сброс → 0');
    });
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() {
      _count = _history.removeLast();
      _log.insert(0, 'Отмена → $_count');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Счётчик с историей')),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Text('$_count', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => _change(-1, '-1'), child: const Text('-1')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _reset, child: const Text('Сброс')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => _change(1, '+1'), child: const Text('+1')),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _history.isNotEmpty ? _undo : null,
                child: const Text('Undo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _log.length,
              itemBuilder: (_, i) => ListTile(
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

// ─── Точка входа ─────────────────────────────────────────────────────────────

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HistoryCounterAnswer(),
  ));
}
