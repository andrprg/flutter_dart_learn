# Шпаргалка: Architecture (domain / data / presentation)

Слоистая архитектура отделяет бизнес-логику от JSON и UI. В этом модуле domain/data живут **без Flutter**, ошибки — как значения (`Either` / `TaskEither`). Практика: `architecture_task.dart`.

## 1. Три слоя и направление зависимостей

```
presentation  →  domain  ←  data
     UI            entity           DTO / API / DB
  ViewState      use-case         RepositoryImpl
                 ports
```

| Слой | Знает про | Не знает про |
|---|---|---|
| **domain** | entity, ports, use-case, `Failure` | JSON, Dio, SnackBar, Widgets |
| **data** | DTO, remote/local sources, маппинг в domain | Flutter UI |
| **presentation** | ViewState, виджеты, маппинг Failure → message | детали HTTP/JSON |

Правило из задач: JSON принадлежит слою **`data`**, SnackBar — **`presentation`**.

## 2. Entity vs DTO

```dart
/// Domain — чистая модель
class Todo {
  const Todo({required this.id, required this.title, required this.done});
  final String id;
  final String title;
  final bool done;
  Todo copyWith({String? title, bool? done}) => /* ... */;
}

/// Data — сериализация на границе
class TodoDto {
  factory TodoDto.fromJson(Map<String, dynamic> json) => /* ... */;
  Map<String, dynamic> toJson() => /* ... */;
}

Either<Failure, Todo> todoFromDto(TodoDto dto) {
  // валидация полей → Right(Todo) или Left(ValidationFailure)
}
```

Domain не импортирует `fromJson`. Маппинг DTO → entity — на границе data/domain.

## 3. Ports и Repository

```dart
abstract interface class TodoRemoteSource {
  Future<List<Map<String, dynamic>>> fetchAll();
  Future<Map<String, dynamic>> create(String title);
}

abstract interface class TodoRepository {
  DomainTask<List<Todo>> getTodos();
  DomainTask<Todo> addTodo(String title);
}

typedef DomainTask<T> = TaskEither<Failure, T>;
```

- **Port** (интерфейс) в domain — «что нужно бизнесу».
- **Impl** в data — «как достаём» (API, кэш, fake).
- Зачем: подмена в тестах, независимость от Dio/SharedPreferences.

## 4. Ошибки как значения

```dart
sealed class Failure {
  const Failure();
}
class ValidationFailure extends Failure { /* message */ }
class DataFailure extends Failure { /* message */ }

Either<Failure, String> validateTitle(String title) {
  final t = title.trim();
  if (t.isEmpty) return Left(ValidationFailure('empty'));
  return Right(t);
}
```

Через слои предпочитаем `Either` / `TaskEither`, а не «голый» `throw`. Use-case склеивает шаги:

```dart
DomainTask<List<Todo>> addAndLoad(TodoRepository repo, String title) {
  // addTodo → затем getTodos (flatMap / andThen)
}
```

## 5. Presentation state без Flutter

```dart
sealed class TodosViewState {
  const TodosViewState();
}
class TodosLoading extends TodosViewState { const TodosLoading(); }
class TodosData extends TodosViewState { /* items */ }
class TodosError extends TodosViewState { /* message */ }

TodosViewState eitherToViewState(Either<Failure, List<Todo>> result) =>
  result.fold(
    (f) => TodosError(failureToMessage(f)),
    (items) => TodosData(items),
  );

Future<TodosViewState> runTodos(DomainTask<List<Todo>> task) async {
  final either = await task.run();
  return eitherToViewState(either);
}
```

`loading` обычно выставляют снаружи (до `run`); сюда приходит уже результат. Во Flutter это же станет `AsyncValue`.

## 6. Use-case зачем

Одна бизнес-операция (`AddTodo`, `AddAndLoad`): переиспользование, тест без UI, явный сценарий. Не обязательно класс на каждый чих — функция/`DomainTask` тоже ок на старте.

## 7. Границы, которые реально ломаются

Domain не импортирует `package:flutter/material.dart`. Как только entity знает про `Color` и `BuildContext`, слой нельзя прогнать тестом `dart test` без Flutter и нельзя переиспользовать в CLI. `DateTime` и свои типы — нормально. `IconData` — уже UI.

Data может зависеть от domain (реализует порт). Domain не зависит от data. Нарушение выглядит как `import` DTO в use-case «для удобства». Тогда смена ключа JSON правит бизнес-правило.

Presentation зависит от domain (вызывает use-case, показывает entity). Прямой вызов `Dio` из виджета обходит и ошибки-значения, и подмену в тесте.

Маппинг DTO → entity возвращает `Either`, если JSON бывает битым. Бросать из `fromJson` тоже можно на границе data, но наружу из репозитория всё равно выходит `Left(DataFailure)`, не сырой `FormatException`. UI не матчит текст исключения.

Use-case — функция над портами. Ему передают `TodoRepository`, не глобальный синглтон. Так тест подставляет фейк без DI-фреймворка.

Кэш, ретраи HTTP и разбор JSON живут в data. «Пустой title нельзя добавить» — domain, это правило не про сеть. Если проверка только в кнопке, второй клиент (виджет и фоновый синк) разъедется.

## 8. Поток одной команды

1. Виджет вызывает `addTodo(title)` у контроллера / use-case.
2. Use-case `validateTitle`. `Left` сразу возвращается, запроса нет.
3. `Right` — `repository.add` как `TaskEither`.
4. Impl мапит DTO, сеть, таймаут в `Failure`.
5. Presentation делает `fold` в `TodosError` / `TodosData`.
6. Успех списка не означает «форма чистая»: это разные состояния. Форма может закрыться, список — перезагрузиться отдельной задачей `addAndLoad`.

`TaskEither` не запускается, пока нет `.run()`. Собрать цепочку в use-case и запустить один раз в presentation — норма. Запустить в use-case и ещё раз снаружи — два запроса.

Состояние загрузки не выводят из `Either`: пока Future не завершился, результата нет. `TodosLoading` ставят до `run`. Пустой список — это `TodosData([])`, не loading и не error. Пустая корзина и «не смогли загрузить» для человека разные экраны.

## 9. Типичные ошибки

- Entity с `fromJson`.
- `throw` в domain и `try/catch` в каждой кнопке.
- Репозиторий возвращает DTO в виджет, виджет сам вытаскивает `json['title']`.
- Один класс `Todo` и для базы, и для экрана, и для запроса создания — любое новое поле API становится полем UI.
- Тест use-case поднимает реальный HTTP.
- Делить слои папками, но импортировать куда угодно. Граница — это направление import, не имена каталогов.

## 10. Вопросы с собеса (кратко)

1. Clean/layered? — UI / domain / data, зависимости внутрь.
2. JSON где? — data (DTO).
3. Repository? — абстракция источника для domain.
4. Use-case? — одна операция, тесты.
5. Ошибки? — sealed Failure + Either.
6. Domain + Flutter? — лучше нет.
7. Presentation state? — loading/data/error.
8. Interfaces? — фейки в тестах, слабая связанность.

Мост дальше: `riverpod/` (DI + UI), затем `fpdart_riverpod/` (TaskEither ↔ AsyncValue).
