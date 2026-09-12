import 'dart:async';

// ============================================================
// 15 ЗАДАЧ ПО EVENT LOOP В DART
// ============================================================
// Цель: научиться предсказывать порядок выполнения синхронного кода,
// microtask и event. Перед задачами прочитай theory.md.
//
// Подсказка: дождаться уже стоящих event-задач и всех microtask:
//   await Future<void>.delayed(Duration.zero);
// Если внутри event ставится ещё один Future(() {}), нужен второй await.

// ─── Пример (не редактируй) ──────────────────────────────────
// Синхронный код всегда заканчивается раньше microtask.
// Ожидаемый порядок: [A, C, B]
Future<List<String>> exampleSyncThenMicrotask() async {
  final log = <String>[];
  log.add('A');
  scheduleMicrotask(() => log.add('B'));
  log.add('C');
  await Future<void>.delayed(Duration.zero);
  return log;
}

/// Базовый уровень (1–5)

// ЗАДАЧА 1
// Собери лог:
// 1. Добавь 'A'
// 2. Поставь microtask, который добавит 'B' (scheduleMicrotask или Future.microtask)
// 3. Добавь 'C'
// 4. Дождись очередей и верни лог.
// Ожидаемый порядок: [A, C, B]
Future<List<String>> orderSyncAndMicrotask() async {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Собери лог:
// 1. Добавь 'sync'
// 2. Поставь microtask → 'micro'
// 3. Поставь event через Future(() { ... }) → 'event'
// 4. Дождись очередей и верни лог.
// Ожидаемый порядок: [sync, micro, event]
Future<List<String>> orderSyncMicrotaskAndEvent() async {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Порядок регистрации НЕ обязан совпадать с порядком выполнения.
// Сначала поставь event → 'event', затем microtask → 'micro',
// затем синхронно добавь 'sync'. Дождись очередей.
// Ожидаемый порядок: [sync, micro, event]
Future<List<String>> orderIgnoresRegistrationTime() async {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Поставь microtask, который:
// - пишет 'm1'
// - внутри себя ставит ещё один microtask → 'm2'
// Рядом поставь event → 'event'. Синхронно добавь 'sync'.
// Ожидаемый порядок: [sync, m1, m2, event]
Future<List<String>> nestedMicrotasksBeforeEvent() async {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Создай уже завершённый Future через Future.value(...) и повесь .then(),
// который добавит 'then'. Синхронно добавь 'sync'. Дождись очередей.
// Ожидаемый порядок: [sync, then]
Future<List<String>> completedFutureThenIsMicrotask() async {
  throw UnimplementedError();
}

/// Средний уровень (6–10)

// ЗАДАЧА 6
// Создай локальную async-функцию inner():
// 1. пишет 'async-start'
// 2. делает await Future<void>.value()
// 3. пишет 'async-resume'
// В основной функции: добавь 'before', вызови inner() без await,
// сразу добавь 'after', затем дождись Future из inner().
// Ожидаемый порядок: [before, async-start, after, async-resume]
Future<List<String>> asyncRunsSyncUntilAwait() async {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Поставь два event подряд: Future(() => 'e1') и Future(() => 'e2').
// Синхронно добавь 'sync'. Очередь event — FIFO.
// Ожидаемый порядок: [sync, e1, e2]
Future<List<String>> eventsAreFifo() async {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Поставь event, который:
// - пишет 'e1'
// - ставит microtask → 'micro'
// Затем поставь второй event → 'e2'.
// Microtask между событиями выполняется раньше следующего event.
// Ожидаемый порядок: [e1, micro, e2]
Future<List<String>> microtaskBetweenEvents() async {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Создай Completer<void>. На completer.future повесь .then() → 'then'.
// Добавь 'before-complete', вызови complete(), добавь 'after-complete'.
// Дождись очередей. .then не выполняется внутри complete().
// Ожидаемый порядок: [before-complete, after-complete, then]
Future<List<String>> completerThenIsNotSync() async {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Сначала поставь event → 'event'.
// Затем Future.sync(() => ...), внутри колбэка добавь 'sync-cb'.
// Затем синхронно добавь 'sync'. Дождись очередей.
// Future.sync выполняет колбэк сразу, Future(() {}) — нет.
// Ожидаемый порядок: [sync-cb, sync, event]
Future<List<String>> futureSyncRunsImmediately() async {
  throw UnimplementedError();
}

/// Продвинутый уровень (11–15)

// ЗАДАЧА 11
// Поставь Future(() => 'event') и повесь цепочку:
//   .then((_) => 'then-1').then((_) => 'then-2')
// Синхронно добавь 'sync'. Дождись очередей.
// После event оба then идут как microtask, до следующего event.
// Ожидаемый порядок: [sync, event, then-1, then-2]
Future<List<String>> thenChainAfterEvent() async {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Поставь event, который пишет 'e1' и внутри ставит ещё один
// Future(() => 'e2'). Дождись обоих. Одного delayed(Duration.zero)
// недостаточно: вложенный Future() встаёт после текущего tick.
// Ожидаемый порядок: [e1, e2]
Future<List<String>> nestedEventNeedsExtraTick() async {
  throw UnimplementedError();
}

// ЗАДАЧА 13
// Предскажи порядок print. Код запускать не обязательно — верни список.
//
// print('A');
// Future(() => print('B'));
// scheduleMicrotask(() => print('C'));
// print('D');
//
// Ожидаемый порядок: [A, D, C, B]
List<String> predictSimpleOrder() {
  throw UnimplementedError();
}

// ЗАДАЧА 14
// Предскажи порядок. foo() вызывается без await.
//
// Future<void> foo() async {
//   print('1');
//   await Future.microtask(() => print('2'));
//   print('3');
// }
// print('4');
// foo();
// print('5');
//
// Ожидаемый порядок: [4, 1, 5, 2, 3]
List<String> predictAsyncFunctionOrder() {
  throw UnimplementedError();
}

// ЗАДАЧА 15
// Предскажи порядок.
//
// print('1');
// Future(() => print('2'));
// scheduleMicrotask(() => print('3'));
// Future.microtask(() => print('4'));
// print('5');
// Future.value(null).then((_) => print('6'));
// Future(() => print('7'));
// scheduleMicrotask(() => print('8'));
//
// Ожидаемый порядок: [1, 5, 3, 4, 6, 8, 2, 7]
List<String> predictComplexOrder() {
  throw UnimplementedError();
}
