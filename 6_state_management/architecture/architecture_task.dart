import 'package:fpdart/fpdart.dart';

// ============================================================
// 12 ЗАДАЧ ПО АРХИТЕКТУРЕ (domain / data / presentation)
// ============================================================
// Цель: слои + fpdart TaskEither — мост к Flutter/Riverpod без UI-зависимостей
// в domain/data.

sealed class Failure {
  const Failure();
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      other is ValidationFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

class DataFailure extends Failure {
  const DataFailure(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      other is DataFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

typedef DomainTask<T> = TaskEither<Failure, T>;

/// Domain entity.
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.done,
  });

  final String id;
  final String title;
  final bool done;

  Todo copyWith({String? title, bool? done}) {
    throw UnimplementedError();
  }
}

/// DTO на границе data.
class TodoDto {
  const TodoDto({
    required this.id,
    required this.title,
    required this.done,
  });

  final String id;
  final String title;
  final bool done;

  factory TodoDto.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

/// Data source.
abstract interface class TodoRemoteSource {
  Future<List<Map<String, dynamic>>> fetchAll();
  Future<Map<String, dynamic>> create(String title);
}

/// Domain port.
abstract interface class TodoRepository {
  DomainTask<List<Todo>> getTodos();
  DomainTask<Todo> addTodo(String title);
}

// ЗАДАЧА 1
// Todo.copyWith — см. класс.

// ЗАДАЧА 2–3
// TodoDto fromJson/toJson — см. класс.

// ЗАДАЧА 4
// DTO → domain.
Either<Failure, Todo> todoFromDto(TodoDto dto) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Валидация title: trim, не пустой, иначе ValidationFailure.
Either<Failure, String> validateTitle(String title) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Реализация репозитория.
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this.source);

  final TodoRemoteSource source;

  @override
  DomainTask<List<Todo>> getTodos() {
    throw UnimplementedError();
  }

  @override
  DomainTask<Todo> addTodo(String title) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 7
// Use-case: добавить и вернуть обновлённый список (add + get).
DomainTask<List<Todo>> addAndLoad(TodoRepository repo, String title) {
  throw UnimplementedError();
}

/// Presentation state (без Flutter).
sealed class TodosViewState {
  const TodosViewState();
}

class TodosLoading extends TodosViewState {
  const TodosLoading();
}

class TodosData extends TodosViewState {
  const TodosData(this.items);
  final List<Todo> items;
}

class TodosError extends TodosViewState {
  const TodosError(this.message);
  final String message;
}

// ЗАДАЧА 8
// Failure → сообщение.
String failureToMessage(Failure failure) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Either → view state.
TodosViewState eitherToViewState(Either<Failure, List<Todo>> result) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Выполни task и верни view state (с loading снаружи — здесь только result).
Future<TodosViewState> runTodos(DomainTask<List<Todo>> task) async {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Какой слой знает про json? верни 'data'.
String jsonBelongsToLayer() {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Какой слой знает про SnackBar? верни 'presentation'.
String snackBarBelongsToLayer() {
  throw UnimplementedError();
}
