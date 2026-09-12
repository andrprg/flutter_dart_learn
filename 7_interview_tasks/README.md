# 24 задачи с собеседований по Dart и Flutter

Задачи сгруппированы по уровню сложности и теме.
Каждый файл содержит: описание задачи, заготовку для решения и эталонный ответ.

---

## Dart — основы (Junior)

| # | Файл | Тема | Уровень |
|---|------|------|---------|
| 01 | `task_01_palindrome.dart` | Проверка палиндрома (строки, логика) | Junior |
| 02 | `task_02_fizzbuzz.dart` | FizzBuzz (циклы, условия) | Junior |
| 03 | `task_03_anagram.dart` | Анаграмма (Map, коллекции) | Junior |
| 04 | `task_04_two_sum.dart` | Two Sum O(n) (Map, алгоритмы) | Junior/Mid |
| 05 | `task_05_linked_list.dart` | Реверс связного списка (структуры данных) | Junior/Mid |

---

## Dart — продвинутый (Mid/Senior)

| # | Файл | Тема | Уровень |
|---|------|------|---------|
| 06 | `task_06_async_future.dart` | Async/Await, Future, Retry | Mid |
| 07 | `task_07_generics_repository.dart` | Generics, паттерн Repository | Mid/Senior |
| 08 | `task_08_streams.dart` | Stream, StreamController, EventBus | Mid/Senior |
| 09 | `task_09_isolates.dart` | Isolate, параллельные вычисления | Senior |
| 10 | `task_10_mixins_extensions.dart` | Mixin, Extension, Sealed classes | Mid/Senior |
| 21 | `task_21_json_models.dart` | Парсинг JSON в модели (enum, вложенные объекты) | Mid |
| 22 | `task_22_lru_cache.dart` | LRU Cache (LinkedHashMap, O(1)) | Mid/Senior |

---

## Flutter — основы (Junior/Mid)

| # | Файл | Тема | Уровень |
|---|------|------|---------|
| 11 | `task_11_stateful_counter.dart` | StatefulWidget, setState, lifecycle | Junior |
| 12 | `task_12_inherited_widget.dart` | InheritedWidget, передача данных в дереве | Mid |
| 13 | `task_13_custom_painter.dart` | CustomPainter, Canvas, анимация | Mid |
| 14 | `task_14_animations.dart` | AnimationController, Hero, Implicit animations | Mid |
| 15 | `task_15_navigation.dart` | Навигация, именованные маршруты, аргументы | Mid |

---

## Flutter — продвинутый (Senior)

| # | Файл | Тема | Уровень |
|---|------|------|---------|
| 16 | `task_16_riverpod_state.dart` | Riverpod: StateNotifier, Provider, фильтры | Mid/Senior |
| 17 | `task_17_performance.dart` | Оптимизация: const, ListView.builder, RepaintBoundary | Senior |
| 18 | `task_18_testing.dart` | Unit и Widget тесты, мокирование | Mid/Senior |
| 19 | `task_19_riverpod_annotations.dart` | Riverpod + аннотации (@riverpod, AsyncNotifier, family) | Mid/Senior |
| 20 | `task_20_platform_channels.dart` | Platform Channels, MethodChannel, EventChannel | Senior |
| 23 | `task_23_slivers.dart` | Slivers: CustomScrollView, SliverAppBar, SliverList | Mid/Senior |
| 24 | `task_24_state_restoration.dart` | State Restoration: RestorationMixin, Restorable* | Senior |

---

## Популярные вопросы на собеседованиях

### Dart
- В чём разница `final` vs `const`?
  - Ответ: `final` — значение присваивается **один раз** во время выполнения (runtime); `const` — **константа времени компиляции** (compile-time), объект канонизируется (один экземпляр для одинаковых литералов).
- Что такое `late` и когда его использовать?
  - Ответ: обещание инициализировать поле/переменную **позже**. Используют для ленивой инициализации, зависимостей, которые нельзя задать в конструкторе, и для `late final` (однократная инициализация). Ошибка `LateInitializationError`, если прочитать до присваивания.
- Как работает `null safety` в Dart?
  - Ответ: типы делятся на non-nullable (`String`) и nullable (`String?`). Компилятор не даёт использовать `null` там, где его быть не должно; доступны проверки/операторы `?`, `??`, `??=`, `!`, flow analysis и промоут типов после `if (x != null)`.
- `Future` vs `Stream` — когда что использовать?
  - Ответ: `Future` — **одно** значение/ошибка в будущем (HTTP-запрос, чтение файла). `Stream` — **последовательность** событий (сокеты, таймер, изменения БД/UI). `Stream` бывает single-subscription и broadcast.
- Что такое `Isolate` и зачем он нужен?
  - Ответ: отдельная «потокоподобная» сущность с **собственной памятью и event loop**. Нужен для тяжёлых вычислений без фризов UI; общение — сообщениями через `SendPort/ReceivePort` (без общей памяти).
- Объясните `async*` / `yield` / `yield*`
  - Ответ: `async*` объявляет **асинхронный генератор** и возвращает `Stream<T>` (внутри можно делать `await`, а наружу — «стримить» значения). `yield` добавляет **одно** событие в поток. `yield*` **делегирует** другому `Stream` и прокидывает **все** его события (и ошибки) дальше — удобно для композиции потоков.

Пример `async*` + `yield` (генерируем числа с задержкой):

```dart
Stream<int> countWithDelay(int n) async* {
  for (var i = 1; i <= n; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    yield i; // отправили одно событие в Stream
  }
}

Future<void> main() async {
  await for (final value in countWithDelay(3)) {
    print(value); // 1, затем 2, затем 3
  }
}
```

Пример `yield*` (склейка/композиция стримов):

```dart
Stream<int> odds(int n) async* {
  for (var i = 1; i <= n; i += 2) {
    yield i;
  }
}

Stream<int> evens(int n) async* {
  for (var i = 2; i <= n; i += 2) {
    yield i;
  }
}

Stream<int> oddsThenEvens(int n) async* {
  yield* odds(n);  // прокидываем все события odds(...)
  yield* evens(n); // затем все события evens(...)
}
```

Практическое правило: если вам нужно вернуть **одно** значение — это обычно `async` + `Future<T>`. Если нужно вернуть **последовательность** значений во времени — `async*` + `Stream<T>`; для «подключения» готового стрима внутрь своего используйте `yield*`.

### Flutter
- Stateless vs Stateful widget — жизненный цикл?
  - Ответ: `StatelessWidget` не хранит изменяемое состояние, пересоздаётся при rebuild, логика в `build`. `StatefulWidget` имеет `State`: `initState` → `didChangeDependencies` → `build` (много раз) → `didUpdateWidget` → `dispose`; состояние меняют обычно через `setState`.
- Как Flutter рендерит UI (Widget → Element → RenderObject)?
  - Ответ: `Widget` — неизменяемое описание. `Element` — «инстанс в дереве», связывает widget со своим местом и держит state. `RenderObject` — layout/paint/hit-test. Обновления обычно меняют widgets, framework сравнивает и обновляет элементы/рендер-объекты.
- `BuildContext` — что это и зачем?
  - Ответ: это ссылка на `Element` в дереве. Нужен для поиска зависимостей вверх по дереву (`Theme.of`, `Navigator`, `Provider/Riverpod` и т.п.) и для позиционирования (навигация/диалоги). Важно: не использовать context «после dispose» и аккуратно с `async` (проверять `mounted`).
- Почему `const` важен для производительности?
  - Ответ: `const`-виджеты не пересоздаются как новые объекты, могут быть канонизированы и быстрее сравниваются, уменьшают аллокации и работу GC; это упрощает диффинг дерева при rebuild.
- `key` в Flutter — зачем и когда использовать?
  - Ответ: `Key` помогает Flutter **сопоставлять** элементы при перестановках/удалениях, сохраняя корректное состояние. `ValueKey` — для списков, `ObjectKey` — по объекту, `UniqueKey` — принудительно новый элемент, `GlobalKey` — доступ к State/контексту и перенос поддерева (использовать редко, т.к. дороже).
- В чём разница `setState` / `Provider` / `Riverpod` / `BLoC`?
  - Ответ: `setState` — локальное состояние внутри одного `State`, простой rebuild. `Provider` — DI + подписки на `ChangeNotifier`/значения, зависит от `BuildContext`. `Riverpod` — провайдеры без необходимости в context, лучше тестируемость/скоупы/async, строгие зависимости. `BLoC` — событийно-состоянийная модель (events → states), часто через streams, дисциплина архитектуры и предсказуемость.
- Чем `@riverpod` отличается от `@Riverpod(keepAlive: true)`?
  - Ответ: обе аннотации относятся к codegen Riverpod. `@riverpod` — современный стиль (генерит провайдер с авто-dispose по умолчанию в зависимости от типа). `keepAlive: true` отключает auto-dispose для провайдера (состояние не сбрасывается при уходе слушателей), полезно для кэшей/долгоживущих задач.
- Когда использовать `Notifier` vs `AsyncNotifier` vs `StreamNotifier`?
  - Ответ: `Notifier` — синхронное состояние (`State`) и императивные методы. `AsyncNotifier` — состояние как `AsyncValue<T>` для загрузок/ошибок (`build` async), удобно для API. `StreamNotifier` — когда источник — поток событий и нужно `AsyncValue` на основе stream.
- Как передать параметр в провайдер (family) через аннотацию?
  - Ответ: объявить параметр в функции/классе провайдера, и генератор сделает `.family`. Пример: `@riverpod Future<User> user(UserRef ref, int id) async { ... }`, затем использовать `ref.watch(userProvider(id))`.
- Что такое `RepaintBoundary` и когда применять?
  - Ответ: граница для перерисовки: изолирует поддерево в отдельный слой, чтобы при изменениях рядом не перерисовывать всё. Применять при дорогом `paint`/анимациях/скролле, когда часть UI часто меняется, а соседняя — нет (не ставить везде без измерений).
- Implicit vs Explicit анимации — в чём разница?
  - Ответ: implicit (`AnimatedContainer`, `AnimatedOpacity`…) — проще, анимируют переходы свойств автоматически. explicit (`AnimationController`, `Tween`, `AnimatedBuilder`) — полный контроль над таймингом, кривыми, несколькими анимациями и сложными сценариями.

---

## Как работать с задачами

1. Открой нужный `.dart` файл
2. Прочитай условие задачи в комментариях вверху
3. Реализуй функцию/класс в секции `// ─── Ваше решение ───`
4. Запусти файл: `dart run <filename>.dart`
5. Сравни с секцией `// ─── Эталонное решение ───`

```bash
# Запуск Dart-файла
dart run sobes_tasks/task_01_palindrome.dart

# Запуск Flutter-задачи
flutter run sobes_tasks/task_11_stateful_counter.dart
```
