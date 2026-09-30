# Flutter & Dart Learning Project 🚀

Добро пожаловать в проект для изучения Dart и Flutter! Этот репозиторий представляет собой сборник практических задач, тестов и упражнений, разделенных по темам и уровням сложности. Он идеально подходит для подготовки к собеседованиям и глубокого погружения в экосистему Flutter.

## 📂 Структура проекта

Проект разделен на несколько основных разделов:

### 1. `dart/` — Глубокое изучение Dart
- **`null_safety/`**: `?`, `??`, `??=`, promotion, lazy init.
- **`oop/`**: классы, factory, abstract, implements, mixin, equality.
- **`generics/`**: generic-типы, `extends`, extensions, zip/mapIndexed.
- **`List/`**: Задачи на работу со списками и коллекциями.
- **`map_set/`**: Частоты, индексы, группировка, пересечения и работа с `Map`/`Set`.
- **`strings/`**: Обработка строк, `RegExp`, slug, query string, маскирование данных.
- **`json/`**: `dart:convert`, fromJson/toJson, dig, pretty print.
- **`dart3_patterns/`**: Records, patterns, `if-case`, switch-выражения, object patterns и sealed classes. Модуль по [Google Codelab](https://codelabs.developers.google.com/codelabs/dart-patterns-records): теория + 15 задач на разбор JSON-документа.
- **`eventloop/`**: microtask/event queue.
- **`future/`**: Асинхронное программирование (Future, async/await).
- **`streams/`**: `Stream`, `StreamController`, broadcast streams, debounce и обработка ошибок.
- **`isolates/`**: `Isolate.run`, worker messages, safe payloads.
- **`fpdart/`**: Функциональное программирование в Dart с использованием библиотеки `fpdart` (Option, Either, Task, IO и др.). Содержит 30 задач от базового до продвинутого уровня.
  - **`fpdart_repository_task.dart`**: Репозиторий на `TaskEither`.
  - **`fpdart_validation_task.dart`**: Валидация с накоплением ошибок через `Either<List<String>, T>`.
  - **`fpdart_composition_task.dart`**: sealed errors, traverse/sequence, parallel, recover.

### 2. `flutter/` — Практика Flutter
- **`constraints/`**: tight/loose/unbounded, flex extent, стратегия скролла в Column.
- **`layout/`**: Задачи на верстку и позиционирование виджетов.
- **`flutter_widgets/`**: Изучение базовых и продвинутых виджетов.
- **`scrolling/`**: `ScrollController`, RefreshIndicator, PageView, load more.
- **`images/`**: `BoxFit`, AspectRatio, placeholder/error, network image.
- **`forms/`**: Формы, валидаторы, `TextEditingController`, debounce и async submit.
- **`overlays/`**: SnackBar, Dialog, BottomSheet, confirm flow.
- **`navigation/`**: Навигация через `go_router`, path/query params, redirect и shell routes.
- **`theming/`**: Material 3, `ThemeData`, `ColorScheme`, `ThemeExtension`.
- **`widget_keys/`**: `ValueKey`, `ObjectKey`, `UniqueKey`, `GlobalKey` в списках и формах.
- **`animations/`**: implicit/explicit, `AnimationController`, Tween, `AnimatedBuilder`.
- **`responsive/`**: `LayoutBuilder`, breakpoints, adaptive navigation и master-detail layout.
- **`accessibility/`**: `Semantics`, screen reader labels, tap targets и keyboard focus.
- **`focus/`**: `FocusNode`, `requestFocus` / `unfocus`, dispose, `TextInputAction.next` и traversal.
- **`networking/`**: HTTP-клиент, статусы, URI, JSON, `ApiClient`, retry.
- **`local_storage/`**: key-value storage, токен, `UserSettings`, onboarding, миграция ключей.
- **`local_notifications/`**: каналы Android, actions, payload, permissions (логика без плагина).
- **`push_notifications/`**: FCM-токен, notification/data, foreground/background/terminated, collapse (логика без плагина).
- **`permissions/`**: статусы, request, rationale, settings, feature → permission.
- **`app_lifecycle/`**: resume/pause/hidden, сохранение черновика, sync pause/resume.
- **`deep_links/`**: custom scheme / universal links, route match, auth redirect.
- **`localization/`**: locale resolution, fallback, plural, interpolate, `AppLocalizations`.
- **`change_notifier/`**: `ChangeNotifier`, `ValueNotifier`, `Listenable.merge`.
- **`architecture/`**: domain/data/presentation + `TaskEither`.
- **`riverpod/`**: Задачи на стейт-менеджмент с использованием `flutter_riverpod` и `riverpod_annotation`.
- **`fpdart_riverpod/`**: Связка `Either` / `TaskEither` с `AsyncValue`, Riverpod и Flutter UI.
- **`errors_juniors/`**: 30 типичных ошибок Junior Flutter-разработчиков и чеклист-тесты.

### 3. `sobes_tasks/` — Задачи с собеседований
Содержит 34 классических задачи, которые часто встречаются на технических интервью:
- Алгоритмы (Палиндромы, FizzBuzz, Анаграммы, Two Sum, Связные списки, LRU Cache).
- Специфика Dart (Isolates, Mixins, Extensions, Streams, Generics).
- Специфика Flutter (InheritedWidget, CustomPainter, Animations, Navigation, Performance, Platform Channels, Slivers, State Restoration).
- Внутри папки `tests/` находятся unit-тесты для проверки ваших решений.

### 4. `PromtEngineering/` — Промпт-инжиниринг в Cursor
Уникальный раздел из 20 задач для тренировки навыков работы с AI-ассистентами (Cursor Chat / Composer). Вы научитесь писать эффективные промпты (Few-Shot, Chain of Thought, ограничения, рефакторинг, создание тестов и архитектуры).

### 5. `mini_apps/` — Сквозные мини-проекты
Набор мини-приложений для закрепления тем в реалистичных сценариях:
- Todo App: формы, списки, фильтры, Riverpod.
- Weather Mock App: fake API, `TaskEither`, loading/error/data.
- Auth Flow: формы, сессия, redirect через `go_router`.
- Shopping Cart: `Map`, derived state, validation и totals.

### 6. `learning_path.md` — Маршрут обучения
Рекомендуемый порядок прохождения проекта: от базового Dart до Flutter-архитектуры, fpdart и мини-приложений.

## 🛠 Как работать с проектом

1. **Установка зависимостей:**
   Перед началом работы убедитесь, что у вас установлены все пакеты:
   ```bash
   flutter pub get
   ```

2. **Генерация кода (для Riverpod и др.):**
   Если вы работаете с задачами, требующими кодогенерации (например, `riverpod_annotation`), запустите build_runner:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Решение задач:**
   - Откройте интересующий вас файл (например, `sobes_tasks/task_01_palindrome.dart`).
   - Найдите функцию, которая возвращает `throw UnimplementedError();` или требует доработки.
   - Напишите свою реализацию.

4. **Проверка решений (Тесты):**
   Большинство задач покрыты тестами. Чтобы проверить свое решение, запустите тесты:
   
   Запуск всех тестов в проекте:
   ```bash
   flutter test
   ```
   
   Запуск конкретного теста:
   ```bash
   flutter test sobes_tasks/tests/test_01_palindrome_test.dart
   ```

## 💡 Рекомендации для обучения
- **Не смотрите в эталонные решения сразу!** Постарайтесь решить задачу самостоятельно.
- **Используйте TDD (Test-Driven Development):** Сначала запустите тест (он упадет), затем напишите код, чтобы тест прошел.
- **Вопросы с собеседований:** В каждом модуле есть `interview_questions.md` и `interview_answers.md` — сначала ответьте сами.
- **Практикуйте Prompt Engineering:** В папке `PromtEngineering` используйте Cursor для генерации виджетов и анализируйте, как изменение промпта влияет на результат.

Удачи в изучении Flutter и Dart! 🎉
