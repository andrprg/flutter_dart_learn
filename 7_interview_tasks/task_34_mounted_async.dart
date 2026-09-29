/// ЗАДАЧА 34 — mounted после await
/// Уровень: Mid Flutter
/// Тема: State.mounted, гонка dispose и setState
///
/// Допишите [DelayedGreeting]:
/// - по нажатию «Загрузить» ждёт [loader]
/// - если виджет ещё в дереве — показывает результат
/// - если экран уже закрыт — setState не вызывается
///
/// Вопрос: в какой момент mounted становится false и чем это грозит?

import 'package:flutter/material.dart';

// ─── Ваше решение ────────────────────────────────────────────────────────────

class DelayedGreeting extends StatefulWidget {
  const DelayedGreeting({super.key, required this.loader});

  final Future<String> Function() loader;

  @override
  State<DelayedGreeting> createState() => _DelayedGreetingState();
}

class _DelayedGreetingState extends State<DelayedGreeting> {
  @override
  Widget build(BuildContext context) {
    // TODO: кнопка, await, проверка mounted
    return const SizedBox.shrink();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class DelayedGreetingAnswer extends StatefulWidget {
  const DelayedGreetingAnswer({super.key, required this.loader});

  final Future<String> Function() loader;

  @override
  State<DelayedGreetingAnswer> createState() => _DelayedGreetingAnswerState();
}

class _DelayedGreetingAnswerState extends State<DelayedGreetingAnswer> {
  String? _message;
  var _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    final value = await widget.loader();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _message = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          key: const Key('load'),
          onPressed: _loading ? null : _load,
          child: const Text('Загрузить'),
        ),
        if (_loading) const Text('Ждём...'),
        if (_message != null) Text(_message!, key: const Key('message')),
      ],
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: DelayedGreetingAnswer(
          loader: () async {
            await Future<void>.delayed(const Duration(milliseconds: 200));
            return 'Привет';
          },
        ),
      ),
    ),
  );
}
