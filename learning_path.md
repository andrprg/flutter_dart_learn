# Learning Path: Dart, Flutter, fpdart

Этот маршрут помогает проходить проект последовательно: сначала язык и базовые структуры данных, затем асинхронность, Flutter UI, state management, функциональный стиль и мини-приложения.

## 1. Dart Core

Цель: уверенно писать чистую логику без Flutter.

1. `1_dart_core/List/list_task.dart`
2. `1_dart_core/map_set/map_set_task.dart`
3. `1_dart_core/strings/string_task.dart`
4. `1_dart_core/dart3_patterns/theory.md` + `patterns_task.dart`
5. `1_dart_core/eventloop/eventloop_task.dart`

Что освоить:
- `List`, `Map`, `Set`;
- частоты, группировка, индексы;
- обработка строк и `RegExp`;
- records, patterns, `if-case`, switch-выражения, object patterns, `when`, sealed classes (по [Codelab](https://codelabs.developers.google.com/codelabs/dart-patterns-records));
- event loop: синхронный код, microtask queue и event queue.

Проверка:

```bash
flutter test 1_dart_core/List/list_task_test.dart
flutter test 1_dart_core/map_set/map_set_task_test.dart
flutter test 1_dart_core/strings/string_task_test.dart
flutter test 1_dart_core/dart3_patterns/patterns_task_test.dart
flutter test 1_dart_core/eventloop/eventloop_task_test.dart
```

## 2. Dart Async

Цель: понять, как строить асинхронные сценарии до подключения UI.

1. `2_dart_async/future/future_task.dart`
2. `2_dart_async/streams/stream_task.dart`

Что освоить:
- `Future`, `async` / `await` (после event loop из раздела 1);
- обработка ошибок;
- `Stream`, `StreamController`, broadcast;
- debounce, merge, concat, recover.

Проверка:

```bash
flutter test 2_dart_async/future/future_task_test.dart
flutter test 2_dart_async/streams/stream_task_test.dart
```

## 3. Functional Dart With fpdart

Цель: научиться описывать отсутствие значения, ошибки и async pipeline явно.

1. `3_functional_dart_with_fpdart/fpdart/fpdart_task.dart`
2. `3_functional_dart_with_fpdart/fpdart/fpdart_validation_task.dart`
3. `3_functional_dart_with_fpdart/fpdart/fpdart_repository_task.dart`

Что освоить:
- `Option`;
- `Either`;
- `Task` и `TaskEither`;
- накопление ошибок формы;
- repository layer без исключений в UI.

Проверка:

```bash
flutter test 3_functional_dart_with_fpdart/fpdart/fpdart_task_test.dart
flutter test 3_functional_dart_with_fpdart/fpdart/fpdart_validation_task_test.dart
```

## 4. Flutter UI Basics

Цель: научиться собирать интерфейсы из виджетов и понимать layout constraints.

1. `4_flutter_ui_basics/layout/layout_task.dart`
2. `4_flutter_ui_basics/flutter_widgets_task.dart`
3. `4_flutter_ui_basics/forms/forms_task.dart`
4. `4_flutter_ui_basics/theming/theming_task.dart`

Что освоить:
- `Row`, `Column`, `Stack`, `Expanded`, `Flexible`;
- `ListView`, `GridView`, `FutureBuilder`, `StreamBuilder`;
- формы и валидаторы;
- Material 3 themes и `ThemeExtension`.

Проверка:

```bash
flutter test 4_flutter_ui_basics/layout/layout_task_test.dart
flutter test 4_flutter_ui_basics/flutter_widgets_task_test.dart
flutter test 4_flutter_ui_basics/forms/forms_task_test.dart
flutter test 4_flutter_ui_basics/theming/theming_task_test.dart
```

## 5. Flutter App Skills

Цель: перейти от отдельных виджетов к поведению приложения.

1. `5_flutter_app_skills/navigation/go_router_task.dart`
2. `5_flutter_app_skills/responsive/responsive_task.dart`
3. `5_flutter_app_skills/accessibility/a11y_task.dart`
4. `5_flutter_app_skills/errors_juniors/flutter_erros.dart`

Что освоить:
- `go_router`, redirect, query/path params;
- responsive breakpoints;
- accessibility и `Semantics`;
- типичные Flutter-ошибки junior-разработчиков.

Проверка:

```bash
flutter test 5_flutter_app_skills/navigation/go_router_task_test.dart
flutter test 5_flutter_app_skills/responsive/responsive_task_test.dart
flutter test 5_flutter_app_skills/accessibility/a11y_task_test.dart
flutter test 5_flutter_app_skills/errors_juniors/errors_juniors_test.dart
```

## 6. State Management

Цель: научиться хранить состояние, отделять UI от бизнес-логики и работать с async state.

1. `6_state_management/riverpod/riverpod_task.dart`
2. `6_state_management/fpdart_riverpod/fpdart_riverpod_task.dart`

Что освоить:
- providers;
- generated Riverpod;
- `AsyncValue`;
- мост `Either` / `TaskEither` -> UI state;
- обработка ошибок через SnackBar и retry.

Проверка:

```bash
flutter test 6_state_management/riverpod/riverpod_task_test.dart
flutter test 6_state_management/fpdart_riverpod/fpdart_riverpod_task_test.dart
```

## 7. Interview Tasks

Цель: закрепить алгоритмы, Dart и Flutter-вопросы для собеседований.

1. `7_interview_tasks/task_01_palindrome.dart` ... `task_24_state_restoration.dart`
2. `7_interview_tasks/README.md`
3. `7_interview_tasks/tests/`

Особое внимание:
- streams;
- isolates;
- custom painter;
- animations;
- navigation;
- performance;
- slivers;
- state restoration.

Проверка:

```bash
flutter test 7_interview_tasks/tests
```

## 8. Prompt Engineering

Цель: освоить техники составления эффективных запросов для LLM, работу с системными промптами (system prompts), few-shot prompting и chain of thought на практике в Cursor.

1. `8_prompt_engineering/prompt_engineering_task.dart`

Что освоить:
- базовые принципы написания промптов (ясность, специфика);
- шаблон ROLE + TASK + FORMAT;
- chain of thought (CoT) и few-shot prompting;
- prompt chaining и мета-промпты;
- генерация кода, дебаггинг и рефакторинг с помощью AI.

Проверка:
Выполняй задания прямо в файле, оценивай результаты генерации и улучшай свои промпты.

## 9. Оркестрация агентов и ИИ во Flutter

Цель: понять принципы работы AI-агентов, их оркестрации и научиться интегрировать LLM с использованием инструментов (tools) во Flutter-приложения.

1. `9_ai_agents_in_flutter/llm_basics_task.dart`
2. `9_ai_agents_in_flutter/langchain_dart_task.dart`
3. `9_ai_agents_in_flutter/agent_state_task.dart`
4. `9_ai_agents_in_flutter/tools_execution_task.dart`

Что освоить:
- Базовые концепции LLM, промпт-инжиниринг и потоковая передача ответов (streaming).
- Оркестрация: использование LangChain.dart (или аналогов) для построения цепочек (chains) и агентов.
- Интеграция инструментов (Function Calling / Tools): как позволить агенту вызывать Dart-код (например, API, локальную БД).
- Управление состоянием агента: отображение процесса "размышления" (thinking), выполнения шагов и финального ответа в UI (через Riverpod + AsyncValue).
- Архитектура AI-приложений: разделение логики агента и Flutter UI.

Проверка:

```bash
flutter test 9_ai_agents_in_flutter/llm_basics_task_test.dart
flutter test 9_ai_agents_in_flutter/langchain_dart_task_test.dart
flutter test 9_ai_agents_in_flutter/agent_state_task_test.dart
```

## 10. Задания по созданию мини-приложений (Mini Apps)

Цель: закрепить теорию на практике, создавая небольшие, но полноценные проекты. 

Ниже описаны мини-приложения и **после каких разделов** их рекомендуется создавать:

### 1. Консольный менеджер задач (CLI Todo)
**Когда создавать:** После раздела **"3. Functional Dart With fpdart"**
- **Описание:** Консольное приложение для добавления, выполнения и удаления задач.
- **Что тренируем:** Базовый Dart, коллекции, `Future`/`Stream` (для чтения ввода), обработку ошибок через `Either` и `Option`.
- **Задание:** Сделай так, чтобы задачи хранились в памяти, а ошибки (например, "задача не найдена") обрабатывались в функциональном стиле без выброса исключений.

### 2. UI-only Погодное приложение (Weather UI)
**Когда создавать:** После раздела **"4. Flutter UI Basics"**
- **Описание:** Чистая верстка погодного приложения (без реальных данных и сложной логики).
- **Что тренируем:** `Row`, `Column`, `ListView`, `GridView`, работу с темами (Material 3) и формами (например, поиск города).
- **Задание:** Сверстай главный экран с текущей погодой, список прогноза на неделю и экран настроек темы.

### 3. Приложение с авторизацией (Auth Flow App)
**Когда создавать:** После раздела **"5. Flutter App Skills"**
- **Описание:** Приложение с экранами логина, регистрации и защищенной зоной (Home).
- **Что тренируем:** Навигацию с `go_router` (особенно `redirect` для неавторизованных пользователей), адаптивную верстку и доступность (a11y).
- **Задание:** Настрой роутинг так, чтобы при запуске приложения проверялся статус авторизации (пока можно использовать заглушку) и пользователя перекидывало либо на экран логина, либо на главный экран.

### 4. Корзина товаров (Shopping Cart)
**Когда создавать:** После раздела **"6. State Management"**
- **Описание:** Каталог товаров с возможностью добавления в корзину, изменения количества и подсчетом итоговой суммы.
- **Что тренируем:** Riverpod (провайдеры, `Notifier`), разделение UI и бизнес-логики.
- **Задание:** Реализуй глобальное состояние корзины. Убедись, что при добавлении товара счетчик на иконке корзины обновляется на всех экранах.

### 5. Полноценный Todo App с "сетью" (Advanced Todo App)
**Когда создавать:** После раздела **"6. State Management"** (как финальный проект перед подготовкой к собеседованиям)
- **Описание:** Менеджер задач с имитацией запросов к серверу (задержки `Future.delayed`).
- **Что тренируем:** Связку fpdart + Riverpod, `AsyncValue`, обработку состояний загрузки/ошибки/успеха.
- **Задание:** Сделай слой репозитория, возвращающий `TaskEither`. В UI используй Riverpod для конвертации `TaskEither` в `AsyncValue` и показывай `CircularProgressIndicator` при загрузке или `SnackBar` при ошибке.

### 6. Умный AI-ассистент (Agentic Chat)
**Когда создавать:** После раздела **"9. Оркестрация агентов и ИИ во Flutter"**
- **Описание:** Чат-бот, который не просто отвечает на вопросы, но и может выполнять действия на устройстве (например, добавлять задачи в Todo-лист, узнавать погоду).
- **Что тренируем:** Function calling, потоковый вывод (streaming UI), управление сложным асинхронным состоянием агента.
- **Задание:** Реализуй агента, которому доступны 2-3 инструмента (tools). Настрой UI так, чтобы пользователь видел, когда агент вызывает инструмент, а когда генерирует текстовый ответ.

---

**Рекомендуемый подход к разработке мини-приложений:**
1. Сначала реализуй чистую логику (модели, репозитории) и напиши для нее тесты.
2. Затем добавь Riverpod providers для управления состоянием.
3. Потом собери UI и свяжи его с провайдерами.
4. В конце добавь обработку краевых состояний: loading, error, empty.
