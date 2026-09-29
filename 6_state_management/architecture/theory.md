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

## 7. Вопросы с собеса (кратко)

1. Clean/layered? — UI / domain / data, зависимости внутрь.
2. JSON где? — data (DTO).
3. Repository? — абстракция источника для domain.
4. Use-case? — одна операция, тесты.
5. Ошибки? — sealed Failure + Either.
6. Domain + Flutter? — лучше нет.
7. Presentation state? — loading/data/error.
8. Interfaces? — фейки в тестах, слабая связанность.

Мост дальше: `riverpod/` (DI + UI), затем `fpdart_riverpod/` (TaskEither ↔ AsyncValue).
