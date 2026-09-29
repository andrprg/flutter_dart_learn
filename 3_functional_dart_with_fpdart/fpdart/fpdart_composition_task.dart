import 'package:fpdart/fpdart.dart';

// ============================================================
// 12 ЗАДАЧ ПО КОМПОЗИЦИИ FPDART
// ============================================================
// Цель: sealed-ошибки, traverse/sequence, parallel TaskEither,
// swap/bimap, Option↔Either — паттерны реальных пайплайнов.

sealed class AppError {
  const AppError();
}

class ValidationError extends AppError {
  const ValidationError(this.messages);
  final List<String> messages;

  @override
  bool operator ==(Object other) =>
      other is ValidationError &&
      messages.length == other.messages.length &&
      ListEquality().equals(messages, other.messages);

  @override
  int get hashCode => Object.hashAll(messages);
}

class NetworkError extends AppError {
  const NetworkError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      other is NetworkError && other.message == message;

  @override
  int get hashCode => message.hashCode;
}

class NotFoundError extends AppError {
  const NotFoundError(this.entity);
  final String entity;

  @override
  bool operator ==(Object other) =>
      other is NotFoundError && other.entity == entity;

  @override
  int get hashCode => entity.hashCode;
}

/// Простое сравнение списков без package:collection.
class ListEquality {
  bool equals(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

typedef AppEither<T> = Either<AppError, T>;
typedef AppTask<T> = TaskEither<AppError, T>;

// ЗАДАЧА 1
// Сообщение для UI по sealed AppError.
String errorMessage(AppError error) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// nonEmpty: пустая/blank строка → Left(ValidationError(['empty'])), иначе Right.
AppEither<String> nonEmpty(String value) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// positiveInt: парсинг и > 0, иначе ValidationError.
AppEither<int> positiveInt(String raw) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// traverse Option: все Some → Some(list), иначе None.
Option<List<A>> traverseOption<A>(List<Option<A>> items) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// sequence Either: первая Left останавливает, иначе Right(list).
AppEither<List<A>> sequenceEither<A>(List<AppEither<A>> items) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// zip2: оба Right → Right((a,b)), иначе первая Left.
AppEither<(A, B)> zip2<A, B>(AppEither<A> a, AppEither<B> b) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// optionToEither с NotFoundError(entity).
AppEither<T> optionToAppEither<T>(Option<T> option, String entity) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// bimap: Left → mapError, Right → mapValue.
AppEither<R> bimapApp<T, R>(
  AppEither<T> either, {
  required AppError Function(AppError e) mapError,
  required R Function(T v) mapValue,
}) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// fromFuture: tryCatch → NetworkError(e.toString()) при ошибке.
AppTask<T> fromFuture<T>(Future<T> Function() run) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// parallel2: выполни оба TaskEither (Future.wait по сути через fpdart),
// собери Right((a,b)) или первую Left.
AppTask<(A, B)> parallel2<A, B>(AppTask<A> a, AppTask<B> b) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// recoverNotFound: NotFoundError → Right(fallback), остальное без изменений.
AppEither<T> recoverNotFound<T>(AppEither<T> either, T fallback) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Пайплайн регистрации:
// nonEmpty(email), nonEmpty(password), password length >= 8
// успех → Right('ok:$email')
AppEither<String> register(String email, String password) {
  throw UnimplementedError();
}
