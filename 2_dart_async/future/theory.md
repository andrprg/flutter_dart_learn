# Шпаргалка: Future в Dart

Прочитай перед задачами в `future_task.dart`. Future — это **один** результат (успех или ошибка), который появится позже. Это не второй поток: колбэки выполняет event loop того же isolate (подробнее — `1_dart_core/eventloop/theory.md`).

## 1. Что такое Future

`Future<T>` — обещание значения типа `T`. Состояния:

| Состояние | Смысл |
|---|---|
| **Uncompleted** | Ещё не завершён |
| **Completed with value** | Успех, есть `T` |
| **Completed with error** | Ошибка |

```dart
Future<String> fetchName() =>
    Future.delayed(Duration(seconds: 1), () => 'Иван');

fetchName().then((name) => print(name)); // Иван
```

## 2. Создание Future

| API | Когда использовать |
|---|---|
| `Future.value(x)` | Уже готовое значение (`.then` / `await` → microtask) |
| `Future.error(e)` | Уже готовая ошибка |
| `Future.delayed(d, fn)` | Отложить на время (event queue) |
| `Future(() { ... })` | Отложить на следующий event |
| `Future.microtask(...)` | Как можно скорее после sync-кода |
| `async`-функция | Самый частый способ |

```dart
Future<int> getNumber() async => 42; // то же, что Future.value(42) по смыслу
```

## 3. `async` / `await` vs `.then`

Тело `async` идёт **синхронно до первого `await`**. Дальше — продолжение через event loop.

```dart
Future<void> demo() async {
  print('До');
  final n = await getNumber();
  print(n);
  print('После');
}
// До → 42 → После
```

| Подход | Плюс | Минус |
|---|---|---|
| `await` | Линейный код, `try/catch` | Нужна `async`-функция |
| `.then` / `.catchError` | Цепочки без `async` | Легко «провалиться» в callback hell |

Цепочка через `.then`:

```dart
fetchPrice()
    .then(applyDiscount)
    .then(applyTax)
    .then(print); // 108.0
```

## 4. Ошибки

```dart
Future<double> divide(int a, int b) async {
  if (b == 0) throw Exception('Деление на ноль');
  return a / b;
}

// await + try/catch
try {
  await divide(1, 0);
} catch (e) {
  print('Ошибка: $e');
}

// или цепочка
divide(1, 0).catchError((e) => print('Ошибка: $e'));
```

`try/catch/finally` в `async`: `finally` выполнится и при успехе, и при ошибке.  
`whenComplete` — аналог `finally` для Future: колбэк всегда после завершения (value или error), результат/ошибка пробрасываются дальше.

```dart
await loadUserData().whenComplete(() => print('Загрузка завершена'));
```

**Не «забывай» Future** во Flutter: без `await` / `.then` / `.ignore()` ошибка может стать unhandled и уронить isolate / показать красный экран.

Отмены «из коробки» нет: обычно флаг/`Completer` + не вызывать побочные эффекты после cancel (см. `raceWithCancel` в задачах).

## 5. Параллель vs последовательно

```dart
// параллельно (~1 с)
final names = await Future.wait([fetchFirstName(), fetchLastName()]);

// race — первый успешный
final fastest = await Future.any([
  fetchFromServer('Медленный', 3),
  fetchFromServer('Быстрый', 1),
]);

// последовательно
for (final url in urls) {
  await loadUrl(url);
}
```

| Метод | Поведение |
|---|---|
| `Future.wait` | Ждёт все; по умолчанию падает на первой ошибке |
| `Future.any` | Первый завершившийся (успех или ошибка) |
| цикл `await` | Строгий порядок, суммарное время |

Полезные паттерны из задач: `retry`, `timeout` / `TimeoutException`, кэш `Map<String, Future<T>>`, `Completer` для ручного завершения.

## 6. Completer

Когда результат приходит «снаружи» (таймер, колбэк, сокет):

```dart
Future<String> fetchWithCompleter() {
  final c = Completer<String>();
  Future.delayed(Duration(seconds: 2), () => c.complete('Готово!'));
  return c.future;
}
```

`complete` / `completeError` не вызывают слушателей синхронно — они уходят в microtask.

## 7. `Future.wait`: ошибки и `eagerError`

По умолчанию `Future.wait` запускает все Future сразу и, если один упал, завершается ошибкой. Остальные при этом **не отменяются**: они доработают, просто их значения никто не прочитает. Повторный запрос «потому что wait упал» может ударить в API второй раз.

`eagerError: true` — отдать первую ошибку, не дожидаясь остальных. `eagerError: false` (по умолчанию) — дождаться всех и вернуть первую ошибку. Успешные значения при ошибке всё равно выбрасываются, если не собрать их вручную.

Для «все результаты, включая падения» оборачивай каждый Future в тип, который не бросает:

```dart
Future<Object?> safe(Future<Object?> f) async {
  try {
    return await f;
  } catch (e) {
    return e;
  }
}
```

`Future.any` завершается на **первом** завершении, успех это или ошибка. Медленные соперники не отменяются.

## 8. Timeout, retry, кэш одного полёта

`future.timeout(duration)` — если исходный Future не успел, получаешь `TimeoutException`. Исходная операция при этом не останавливается: таймер только перестаёт её ждать. Отмена — отдельный контракт (флаг, `CancelableOperation` из `package:async`).

Retry имеет смысл на временных сбоях (сеть, 503), не на `FormatException`. Между попытками — пауза, лучше с потолком. Лимит попыток обязателен, иначе цикл живёт до убийства процесса.

Кэш «один запрос на ключ»:

```dart
final inflight = <String, Future<User>>{};

Future<User> load(String id) {
  return inflight.putIfAbsent(id, () async {
    try {
      return await api.fetch(id);
    } finally {
      inflight.remove(id); // или оставить, если кэшируешь успех
    }
  });
}
```

Два одновременных вызова `load(id)` делят один Future. Без `putIfAbsent` уйдут два HTTP.

## 9. `async` и значение ошибки

`throw` внутри `async` превращается в Future с ошибкой, не в синхронное исключение у вызывающего. `try/catch` вокруг вызова без `await` ошибку **не** поймает:

```dart
try {
  boom(); // Future создан, ошибка ещё «внутри»
} catch (_) {}
```

Ловить нужно `await boom()` или `.catchError`. `rethrow` сохраняет stack trace; `throw e` его подменяет.

`finally` в `async` выполнится до того, как внешний `await` получит значение. Если в `finally` сделать `return` или `throw`, они перебьют исходный результат. Для «лог в конце, результат не трогать» — `whenComplete`.

## 10. Типичные ошибки

- `await Future.wait` на пустом списке. Это успешный пустой список, не зависание.
- Забыть, что `then` без `onError` / `catchError` пробрасывает ошибку дальше. Цепочка «молча» не глотает сбой.
- Стартовать Future в `build`. Каждый rebuild — новый запрос.
- Считать `Future.delayed` изолятом. Колбэк всё равно на том же event loop.
- Двойной `complete` у `Completer` — `StateError`.

## 11. Зачем это знать

- Отличать «один результат» (Future) от «потока событий» (Stream).
- Выбирать `wait` vs последовательный `await` по latency.
- Обрабатывать ошибки явно; помнить про `whenComplete` / `finally`.
- На собеседовании: Future ≈ Promise (JS), но API и event loop Dart свои; cancellation — ручной контракт.

Дальше: `future_task.dart`, затем `streams/theory.md`.
