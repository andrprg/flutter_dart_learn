# Шпаргалка: Event Loop в Dart

Dart в одном isolate выполняется **в одном потоке**. Параллельных колбэков нет: пока работает синхронный код, ничего из очередей не стартует. Асинхронность — это не второй поток, а **отложенный код**, который event loop запустит позже.

## 1. Две очереди

У isolate две очереди:

| Очередь | Приоритет | Что туда попадает |
|---|---|---|
| **Microtask queue** | Выше | `scheduleMicrotask`, `Future.microtask`, `.then()` / `await` у уже завершённого `Future` |
| **Event queue** | Ниже | `Future(() { ... })`, `Future.delayed`, таймеры, I/O, пользовательские события, кадры Flutter |

## 2. Как крутится цикл

```
1. Выполнить текущий синхронный код до конца
2. Выполнить ВСЕ microtask (включая те, что появились по дороге)
3. Взять ОДНО событие из event queue
4. Снова шаг 2
5. Снова шаг 3
   ...
```

Следствие: microtask может **бесконечно откладывать** события. Если в каждом microtask ставить следующий microtask, таймеры и I/O не выполнятся.

## 3. API и куда они попадают

```dart
import 'dart:async';

void demo() {
  print('sync-1');

  scheduleMicrotask(() => print('microtask'));
  Future.microtask(() => print('Future.microtask'));

  Future(() => print('event: Future()'));
  Future.delayed(Duration.zero, () => print('event: delayed(0)'));

  Future.value(1).then((_) => print('microtask: then у готового Future'));

  print('sync-2');
}

// Порядок:
// sync-1
// sync-2
// microtask
// Future.microtask
// microtask: then у готового Future
// event: Future()
// event: delayed(0)
```

Кратко:

- **Синхронный код** — сразу, в порядке написания.
- `scheduleMicrotask` / `Future.microtask` — очередь microtask, FIFO.
- `Future(() { ... })` и `Future.delayed` — очередь event.
- `Future.value` / `Future.sync` — колбэк выполняется **сразу** (для `sync`) или Future уже завершён; `.then` и продолжение после `await` идут как **microtask**, а не как event.
- `Completer.complete()` не вызывает `.then` синхронно: слушатели ставятся в microtask.

## 4. `async` / `await`

Тело `async`-функции выполняется **синхронно до первого `await`**.

```dart
Future<void> inner() async {
  print('async-start');          // ещё синхронно
  await Future<void>.value();    // дальше — microtask
  print('async-resume');
}

void main() {
  print('before');
  inner();                       // не await — inner только стартует
  print('after');
}

// before → async-start → after → async-resume
```

Даже `await Future.value(1)` **не продолжает функцию сразу**: продолжение всегда планируется отдельным microtask.

## 5. Вложенные задачи

Microtask, поставленный из другого microtask, выполняется **до** следующего event:

```dart
scheduleMicrotask(() {
  print('m1');
  scheduleMicrotask(() => print('m2'));
});
Future(() => print('event'));
// m1, m2, event
```

Event, поставленный из другого event, встаёт **в конец** event queue. Поэтому одного `await Future.delayed(Duration.zero)` может не хватить: он ждёт только события, которые уже стояли в очереди **перед** этим delayed.

```dart
Future(() {
  print('e1');
  Future(() => print('e2')); // встанет после текущего tick
});
await Future<void>.delayed(Duration.zero); // здесь будет только e1
await Future<void>.delayed(Duration.zero); // теперь e2
```

## 6. `Future.sync`, ошибки и «кто первый»

`Future.sync` выполняет тело **сразу**. Если тело вернуло значение — Future уже завершён, `.then` всё равно уйдёт в microtask. Если тело бросило — Future завершён с ошибкой, тоже без синхронного вызова слушателей.

```dart
Future<int> boom() => Future.sync(() => throw StateError('x'));
// до .then / await исключение ещё не всплыло как unhandled
```

Необработанная ошибка Future репортится, когда Future завершился и на нём нет обработчика к концу текущего microtask-хвоста. `await` и `.catchError` обработчик ставят. «Потерянный» `future()` без `await` в `main` — классика «uncaught async error» уже после `sync` логов.

`Timer.run` и `Future(() {})` оба кладут задачу в event queue. `Duration.zero` не значит «прямо сейчас»: это событие, и оно ждёт, пока очередь microtask опустеет.

## 7. Голодание event loop

```dart
void starve() {
  scheduleMicrotask(starve); // каждый microtask ставит следующий
}
```

Пока цепочка microtask не кончится, кадр Flutter, таймер и сокет не получат ход. То же с синхронным `while (true)` или парсингом огромного JSON на main isolate: очередь не крутится, UI замирает. Лечение — разбить работу (`Future(() {})` между кусками) или унести в isolate. `await Future.delayed(Duration.zero)` в длинном цикле отдаёт ход event queue, но это костыль, не параллелизм.

Flutter scheduler сам ставит кадр как событие. `setState` только помечает элемент dirty; `build` случится, когда event loop дойдёт до кадра и нет бесконечных microtask.

## 8. Как читать чужой порядок `print`

1. Выпиши всё, что происходит до первого `await` / конца синхронной функции — сверху вниз.
2. Выпиши microtask в порядке постановки. Если microtask ставит ещё microtask — он встаёт в хвост и выполнится до любого event.
3. Выпиши event queue. Один «тик» — одно событие, затем снова все накопившиеся microtask.
4. `await` на уже готовом Future — это microtask, не event. `await Future.delayed` и `await Future(() {})` — event.

На собеседовании не угадывай порядок «на глаз». Разложи по этим четырём шагам и только потом назови печать.

## 9. Типичные ошибки

- Считать `async` функцией, которая сразу уходит в фон. До первого `await` она синхронная.
- Ждать, что `Future.delayed(Duration.zero)` обойдёт microtask. Не обойдёт.
- Ставить тяжёлый разбор в `scheduleMicrotask` «чтобы не блокировать». Microtask как раз блокирует события сильнее, чем один event.
- Путать очередь isolate с потоками ОС. Второй isolate — второй event loop и другая память.

## 10. Зачем это знать

- Понять, почему `print` вокруг `Future` идут «не по порядку».
- Не блокировать isolate тяжёлым синхронным циклом — замирают и UI, и таймеры, и microtask.
- Отличать «выполнить сразу после текущего кода» (`scheduleMicrotask`) от «выполнить на следующем событии» (`Future(() {})`).
- Во Flutter кадр, жест, таймер и ответ сети — это события event queue; `setState` после `await` попадает в кадр только когда event loop до него дойдёт.

Дальше по маршруту: `2_dart_async/future/future_task.dart`.
