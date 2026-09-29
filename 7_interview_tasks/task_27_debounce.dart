/// ЗАДАЧА 27 — Debounce и Throttle
/// Уровень: Mid
/// Тема: Timer, ограничение частоты вызовов
///
/// Частый вопрос: «Чем debounce отличается от throttle? Где что ставить?»
///
/// Реализуйте:
/// - [Debouncer] — откладывает вызов, пока события идут чаще, чем [delay].
///   Срабатывает только последнее действие после паузы.
///   Типично для поиска по мере ввода.
/// - [Throttler] — пропускает первый вызов сразу и игнорирует следующие,
///   пока не пройдёт [interval]. Типично для скролла и кнопок.
///
/// Оба класса должны уметь [dispose], чтобы отменить отложенный таймер.

import 'dart:async';

// ─── Ваше решение ────────────────────────────────────────────────────────────

class Debouncer {
  Debouncer({required Duration delay}) : _delay = delay;

  final Duration _delay;

  void call(void Function() action) {
    // TODO: отменяйте предыдущий таймер и ставьте новый
    throw UnimplementedError();
  }

  void dispose() {
    // TODO: отмените таймер
  }
}

class Throttler {
  Throttler({required Duration interval}) : _interval = interval;

  final Duration _interval;

  void call(void Function() action) {
    // TODO: выполните сразу, затем игнорируйте вызовы до конца интервала
    throw UnimplementedError();
  }

  void dispose() {
    // TODO: отмените таймер
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class DebouncerAnswer {
  DebouncerAnswer({required Duration delay}) : _delay = delay;

  final Duration _delay;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(_delay, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

class ThrottlerAnswer {
  ThrottlerAnswer({required Duration interval}) : _interval = interval;

  final Duration _interval;
  Timer? _timer;
  bool _locked = false;

  void call(void Function() action) {
    if (_locked) return;
    _locked = true;
    action();
    _timer = Timer(_interval, () => _locked = false);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _locked = false;
  }
}

// ─── Мини-демо ────────────────────────────────────────────────────────────────

void main() {
  final debouncer = DebouncerAnswer(delay: const Duration(milliseconds: 200));
  debouncer.call(() => print('поиск: a'));
  debouncer.call(() => print('поиск: ab'));
  debouncer.call(() => print('поиск: abc'));
  // В консоли будет только «поиск: abc».
}
