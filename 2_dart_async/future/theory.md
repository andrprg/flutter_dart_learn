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

## 7. Зачем это знать

- Отличать «один результат» (Future) от «потока событий» (Stream).
- Выбирать `wait` vs последовательный `await` по latency.
- Обрабатывать ошибки явно; помнить про `whenComplete` / `finally`.
- На собеседовании: Future ≈ Promise (JS), но API и event loop Dart свои; cancellation — ручной контракт.

Дальше: `future_task.dart`, затем `streams/theory.md`.
