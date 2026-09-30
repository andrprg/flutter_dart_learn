# Шпаргалка: fpdart (Option, Either, Task…)

Прочитай перед задачами: `fpdart_task.dart`, `fpdart_validation_task.dart`, `fpdart_repository_task.dart`, `fpdart_composition_task.dart`. Пакет [fpdart](https://pub.dev/packages/fpdart) даёт типы для **явных** отсутствий, ошибок и эффектов вместо «голого» `null` / `throw` / разрозненных `try/catch`.

## 1. Option — вместо null

`Option<T>` = `Some(T)` | `None`. Нет значения — это значение типа, а не `null`.

```dart
Option<int> toOption(int? v) => Option.fromNullable(v);

Option<int> safeDivide(int a, int b) =>
    b == 0 ? const Option.none() : Option.of(a ~/ b);

opt.map((x) => x * 2);           // None остаётся None
opt.filter((x) => x.isEven);      // Some только если предикат true
opt.flatMap((x) => ...);          // цепочка Option-returning
opt.fold(() => 'пусто', (x) => 'значение: $x');
opt.getOrElse(() => 0);
```

| Когда | Что брать |
|---|---|
| Может не быть значения, ошибки нет | `Option` |
| Нужна причина неудачи | `Either` |

`sequence` / `traverse`: список `Option` → `Option` списка (любой `None` → `None`).

## 2. Either — ошибка как значение

`Either<L, R>`: `Left(L)` — ошибка, `Right(R)` — успех (в fpdart «правильный» путь — Right).

```dart
Either<String, double> divideEither(int a, int b) =>
    b == 0 ? Either.left('Деление на ноль') : Either.right(a / b);

e.map((x) => x * 2);              // трогает только Right
e.flatMap((x) => next(x));        // цепочка с короткой остановкой на Left
e.fold((err) => 'Ошибка: $err', (v) => 'OK: $v');
e.getOrElse((err) => 0);
```

**map vs flatMap:** `map` — `R → R2`; `flatMap`/`bind` — `R → Either<L, R2>` (склеивает вложенность).

Exceptions vs Either: исключения — скрытый канал управления; Either заставляет обработать `L` в типе. На UI часто `fold` → сообщение / состояние.

## 3. Накопление ошибок валидации

`flatMap` на Either **останавливается** на первой `Left`. Для формы нужно `Either<List<String>, T>` и комбинаторы, которые **склеивают** списки ошибок (`combine2`, ручной merge Left’ов) — см. `fpdart_validation_task.dart`.

```dart
typedef Validation<T> = Either<List<String>, T>;

Validation<String> validateName(String value) {
  final errors = <String>[];
  if (value.trim().isEmpty) errors.add('имя пустое');
  if (value.trim().length < 2) errors.add('имя короткое');
  return errors.isEmpty ? Either.right(value.trim()) : Either.left(errors);
}

// combine2: обе Left → Left(e1 + e2); одна Left → она; обе Right → Right((a,b))
```

Паттерн: валидировать поля независимо → накопить `List<String>` → один `Left` со всеми сообщениями для формы / `FieldInvalid`.

## 4. Task и TaskEither

| Тип | Смысл |
|---|---|
| `Task<A>` | Ленивый `() → Future<A>` без ошибки в типе |
| `TaskEither<L, R>` | Ленивый async + `Either` (сеть, БД, репозиторий) |
| `IO<A>` | Синхронный эффект, ленивый до `.run()` |

```dart
Task<String> taskGreeting() => Task(() async => 'Привет из Task');
await taskGreeting().run();

TaskEither<String, String> fetchUserTask(int id) {
  if (id <= 0) return TaskEither.left('Неверный id');
  return TaskEither.tryCatch(
    () async {
      await Future<void>.delayed(Duration(milliseconds: 100));
      if (id == 404) throw Exception('not found');
      return 'User#$id';
    },
    (e, _) => e.toString(),
  );
}
```

**Task vs Future:** Future стартует при создании; Task — описание, запускается на `.run()` (удобно композировать до выполнения).

Типичный use-case TaskEither (репозиторий):

```dart
typedef AppTask<T> = TaskEither<AppFailure, T>;

// fetch → decode → parse DTO → domain, без try/catch в UI
AppTask<User> fetchUser(...) => fetchJsonTask(...)
    .flatMap((raw) => TaskEither.fromEither(decodeObject(raw)))
    .flatMap((map) => TaskEither.fromEither(parseUser(map)))
    .flatMap((dto) => TaskEither.fromEither(userFromDto(dto)));
```

`tryCatch` ловит исключения Future и кладёт в `Left`. В UI: `await task.run()` → `either.fold` / `UiSuccess`/`UiFailure`.

## 5. Композиция: sequence, zip, parallel, bimap

Из `fpdart_composition_task.dart`:

| Паттерн | Поведение |
|---|---|
| `sequence` Either | Первая `Left` останавливает |
| `traverse` Option | Все `Some` → `Some(list)`, иначе `None` |
| `zip2` | Два Either → пара или первая ошибка |
| `parallel2` TaskEither | Оба `.run()` «параллельно», собрать пару / Left |
| `bimap` | Преобразовать и Left, и Right |
| `optionToEither` | `None` → доменная ошибка (`NotFoundError`) |
| sealed `AppError` | `ValidationError` / `NetworkError` / `NotFoundError` + `errorMessage` |

```dart
AppEither<T> optionToAppEither<T>(Option<T> o, String entity) =>
    o.toEither(() => NotFoundError(entity));
```

Do-нотация (`Option.Do`, `Either.Do`): императивный вид цепочки `flatMap` без пирамиды.

## 6. IO / Reader / State (кратко)

- **IO** — отложенный sync-эффект (`print`, чистое вычисление с явным «это эффект»).
- **Reader\<Env, A\>** — вычисление с зависимостью от контекста (`run(env)`).
- **State\<S, A\>** — `(S) → (S, A)`; счётчики, редьюсеры без внешней мутации.

В задачах базового курса достаточно узнать сигнатуры; основной упор — Option / Either / TaskEither.

## 7. Do-нотация и короткая остановка

`flatMap` останавливает цепочку на `Left` / `None`: следующий шаг не вызывается. Do-нотация делает то же без вложенности:

```dart
final result = Either<String, int>.Do(($) {
  final a = $(divideEither(10, 2));
  final b = $(divideEither(a.toInt(), 1));
  return b.toInt();
});
```

`$(...)` на `Left` прерывает блок. Это не `try/catch`: тип ошибки остаётся в сигнатуре.

`mapLeft` / `bimap` меняют ошибку, не трогая успех (`mapLeft`) или оба канала (`bimap`). Нужны на границе слоёв: `FormatException` внутри data → `ValidationFailure` в domain.

`swap` меняет Left и Right местами. Редко, но полезно, когда «ошибка» следующего API — это твоё успешное значение.

`getOrElse` на Either принимает функцию от ошибки: запасное значение может зависеть от `Left`. На Option — функция без аргумента.

## 8. Ленивость Task и повторный `run`

`Task` и `TaskEither` ничего не делают в конструкторе. Каждый `.run()` — новый запуск. Два `await task.run()` — два запроса, если внутри HTTP.

Это плюс для retry: тот же `TaskEither` можно `run` снова. Это минус, если положить запуск в `build` или вызвать `run` и в логе, и в UI.

`TaskEither.right(value)` и `.left(error)` — уже решённый результат, `run` завершается сразу. `fromEither` оборачивает синхронный `Either` без `Future`. `tryCatch` нужен, когда внутри именно бросают.

`flatMap` у TaskEither последовательный: второй запрос стартует после успеха первого, потому что ему нужен результат. Независимые запросы — `parallel2` / `Future.wait` двух `run()`, иначе ты зря суммируешь задержки.

Ошибка внутри `tryCatch` становится `Left`. Ошибка **вне** колбэка, например в `map`, который сам бросил, снова обычное исключение. Не бросай внутри `map` — возвращай `Left` через `flatMap`.

## 9. Валидация: fail-fast и накопление

| Комбинатор | Поведение на двух ошибках |
|---|---|
| `flatMap` / `zip` | остаётся первая |
| `combine2` списка строк | оба списка склеиваются |

Накапливать нужно именно на типе `Either<List<E>, T>` (или `Validation`). `Either<String, T>` физически не умеет вторую ошибку: в `Left` одна строка. Сначала подними ошибку до списка, потом комбинируй.

Поля валидируют независимо, без раннего `return`, иначе пользователь чинит форму по одной ошибке за сабмит. Зависимые поля («подтверждение пароля») проверяют после того, как оба значения есть, отдельным шагом.

`sequence` списка `Either` — fail-fast по первому `Left` и удобен для «все id нашлись». Для формы это как раз не то.

## 10. Типичные ошибки

- `Option.of(nullable)` — `of` не принимает отсутствие; для `T?` нужен `fromNullable`. `of(null)` на `Option<String?>` даст `Some(null)`, и `None` ты уже не отличишь.
- Путать `map` и `flatMap` и получать `Either<L, Either<L, R>>`.
- Вызвать `.run()` внутри репозитория и вернуть наружу голый `Future`, потеряв `Left` в `throw`.
- Считать Task кэшем. Кэш — отдельное решение вокруг `run`.
- Тащить `Either` в текст кнопки через `toString()`. На границе UI — `fold` в строку.

## 11. Зачем это знать

- Типы тащат отсутствие и ошибку в сигнатуру API.
- Валидация форм → `Either<List<String>, T>`; репозиторий → `TaskEither<AppFailure, T>`.
- UI стыкуется через `fold` / маппинг в `UiResult`, без размазанного `try/catch`.
- На собесе: map/flatMap, sequence/traverse, ленивость Task, накопление ошибок vs fail-fast flatMap.

Дальше по файлам задач в этой папке — от Option к validation → repository → composition.
