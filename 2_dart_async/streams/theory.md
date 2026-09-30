# Шпаргалка: Streams в Dart

Прочитай перед задачами в `stream_task.dart`. Stream — это **последовательность** асинхронных событий (0…N значений + опционально ошибка + done). Future — одно значение; Stream — лента.

## 1. Future vs Stream

| | Future | Stream |
|---|---|---|
| Результатов | Один | Много |
| Завершение | value / error | события → `done` (или error) |
| Пример | HTTP-ответ | WebSocket, ввод, тики таймера |

```dart
Stream<int> countStream(int count) =>
    Stream.periodic(Duration.zero, (i) => i + 1).take(count);

await for (final n in countStream(3)) {
  print(n); // 1, 2, 3
}
```

Собрать всё в список: `stream.toList()`, сумма — `fold`, первое подходящее — `where(...).firstOrNull`.

## 2. Single-subscription vs broadcast

| Тип | Подписчиков | Поведение |
|---|---|---|
| **Single-subscription** | Один | Повторный `listen` — ошибка; события «про запас» не копятся для второго |
| **Broadcast** | Много | Каждый получает события **после** своей подписки; прошлые не догоняются |

```dart
final single = Stream.fromIterable([1, 2, 3]);
final multi = single.asBroadcastStream(); // или StreamController.broadcast()
```

Правило: I/O / генераторы — чаще single; шина событий UI / bus — broadcast.

## 3. StreamController

Контроллер — ручной источник: ты вызываешь `add` / `addError` / `close`, снаружи виден `stream`.

```dart
final c = StreamController<int>();
c.stream.listen(print);
c.add(1);
c.add(2);
await c.close();
```

В задачах — `CounterBus`: `add`, `stream`, `close`. Не забывай `close()` и отписку:

```dart
final sub = stream.listen(...);
// в dispose:
await sub.cancel();
```

Во Flutter: `StreamBuilder` сам отписывается; ручной `listen` в `State` — отмена в `dispose`.

## 4. `async*` / `yield` / `yield*`

```dart
Stream<int> progressStream(int step) async* {
  for (var p = 0; p <= 100; p += step) {
    yield p;
    await Future<void>.delayed(Duration(milliseconds: 50));
  }
}

Stream<int> both() async* {
  yield* countStream(2); // вшить другой stream
  yield 99;
}
```

`async*` возвращает Stream; `yield` — одно событие; `yield*` — делегирование другому Stream.

## 5. Трансформации

| Метод | Смысл |
|---|---|
| `map` | Преобразовать каждый элемент |
| `where` | Фильтр |
| `expand` / `asyncExpand` | 1 → N (или вложить Stream) |
| `take` / `skip` | Ограничить |
| `distinct` | Убрать повторы (часто соседние — руками) |
| `transform` | Низкоуровневый `StreamTransformer` |
| `fold` / `reduce` | Свернуть в Future |

```dart
source.where((n) => n.isEven).map((n) => n * 10);

// склейка: сначала first, потом second
Stream.fromIterable([first, second]).asyncExpand((s) => s);

// merge параллельно — package:async StreamGroup.merge
```

**Debounce** (задача 11): событие проходит, только если после него тишина `duration` — типично для поиска.

**Ошибки → fallback** через transformer:

```dart
source.transform(StreamTransformer.fromHandlers(
  handleError: (e, s, sink) => sink.add(fallback),
));
```

## 6. Backpressure и подписка

Producer быстрее consumer → нужна стратегия: буфер, пауза (`pause`/`resume` на subscription), дроп (debounce/sample). В Dart по умолчанию события буферизуются у single-subscription до обработки слушателя — при очень быстрых источниках память растёт.

Пауза:

```dart
final sub = stream.listen(print);
sub.pause();
sub.resume();
```

## 7. Тестирование

- `expectLater(stream, emitsInOrder([1, 2, emitsDone]))` (`package:test` / flutter_test).
- Собрать `await stream.toList()` и сравнить список.
- Для времени (debounce) — фейковые async / явные `Duration`.

## 8. Подписка, pause и ошибки в `listen`

```dart
final sub = stream.listen(
  (value) {},
  onError: (Object e, StackTrace st) {},
  onDone: () {},
  cancelOnError: false,
);
```

Без `onError` ошибка из single-subscription stream становится необработанной. `cancelOnError: true` закрывает подписку на первой ошибке.

`await for` сам подписывается и отписывается. `break` / `return` из цикла отменяет подписку. Ошибка потока вылетает из `await for` как обычное исключение — её берёт `try/catch`.

`pause` копит события у single-subscription (буфер). Долгая пауза на быстром источнике раздувает память. Broadcast при паузе одного слушателя остальным события не держит ради него: пауза локальна, пропущенное этот слушатель не догонит.

`distinct()` без аргумента сравнивает соседние элементы через `==`. Несоседние дубликаты остаются. Для «уникальные за всё время» нужен свой `Set` в `transform` или `where`.

## 9. Debounce своими руками

Идея: на каждое событие перезапускать таймер; в поток наружу писать значение, только если таймер дожил до конца.

```dart
Stream<T> debounce<T>(Stream<T> source, Duration duration) async* {
  T? pending;
  var has = false;
  await for (final value in source) {
    pending = value;
    has = true;
    await Future<void>.delayed(duration);
    // гонка: за duration источник мог прислать более новое
  }
}
```

Честный debounce не `await`-ит внутри `await for` без буфера: пока ты спишь, события копятся, а таймер должен сбрасываться. На практике хранят последнее значение и `Timer`: каждый `add` делает `timer.cancel()` + новый `Timer`, в колбэке — `sink.add(last)`. Именно это имеют в виду в задаче поиска. `Stream.periodic` + `where` debounce не заменяет.

`asyncExpand` ждёт внутренний stream до конца, потом берёт следующий элемент. Это concat, не merge. Параллельный merge — `StreamGroup.merge` из `package:async` или свой контроллер с несколькими подписками.

## 10. Закрытие и «уже слушают»

`StreamController.add` после `close` — ошибка. `close` дописывает `done`. Повторный `listen` на single-subscription — `StateError`, даже если первый уже `cancel`: поток одноразовый.

Broadcast создают сразу: `StreamController<int>.broadcast()`. Событие без слушателей у broadcast **пропадает**. Сначала `listen`, потом `add`, если событие нельзя потерять. У обычного контроллера событие без слушателя буферизуется до подписки.

`sync: true` у контроллера вызывает слушателя прямо в `add`, реентрантно. По умолчанию `add` планирует доставку. В задачах модуля синхронный контроллер не нужен и легче ловит «add во время listen».

## 11. Типичные ошибки

- `asBroadcastStream()` на уже слушаемом single-subscription — поздновато, если первый `listen` уже прошёл.
- Забыть `cancel` в `State.dispose` — колбэк зовёт `setState` после unmount.
- Считать `toList()` пригодным для бесконечного `Stream.periodic`. Он завершится только на `done`.
- Глотать ошибку в `listen` без `onError` и искать, почему UI пустой.
- Дебаунсить через `await Future.delayed` внутри `await for` и удивляться, что таймер не сбрасывается.

## 12. Зачем это знать

- Выбрать single vs broadcast до проектирования API.
- Всегда продумывать `cancel` / `close`.
- Собрать пайплайн `map/where/transform` вместо ручных флагов в `listen`.
- На собесе: Stream ≠ Future; Controller — мост «push API → Stream»; backpressure — что делать, когда событий слишком много.

Дальше: `stream_task.dart`, затем `isolates/theory.md`.
