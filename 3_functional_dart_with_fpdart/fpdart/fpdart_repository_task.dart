import 'package:fpdart/fpdart.dart';

// ============================================================
// 12 ЗАДАЧ: REPOSITORY НА TaskEither
// ============================================================
// Цель: научиться описывать ошибки как значения и строить async pipeline
// без try/catch в UI-слое.

typedef AppTask<T> = TaskEither<AppFailure, T>;

// ЗАДАЧА 1
// Преобразуй raw JSON в UserDto. Ошибки структуры -> Left(ParseFailure).
Either<AppFailure, UserDto> parseUser(Map<String, Object?> json) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Преобразуй UserDto в доменную модель User.
Either<AppFailure, User> userFromDto(UserDto dto) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Оберни Future<String> в TaskEither<AppFailure, String>.
AppTask<String> fetchJsonTask(Future<String> Function() request) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Распарси JSON-строку пользователя через dart:convert.
Either<AppFailure, Map<String, Object?>> decodeObject(String json) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Собери pipeline: fetch -> decode -> parse dto -> domain.
AppTask<User> fetchUser(UserApi api, String id) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Получи список пользователей и отбрось неактивных.
AppTask<List<User>> fetchActiveUsers(UserApi api) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Скомбинируй пользователя и настройки в Profile.
AppTask<Profile> fetchProfile(UserApi api, SettingsApi settingsApi, String id) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Retry: повтори task не больше attempts раз при NetworkFailure.
AppTask<T> retryNetwork<T>(AppTask<T> task, int attempts) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Преобразуй failure в пользовательское сообщение.
String failureMessage(AppFailure failure) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Сохрани пользователя: validate -> api.saveUser -> return saved user.
AppTask<User> saveUser(UserApi api, UserDraft draft) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Преобразуй Either в UiResult.
UiResult<T> eitherToUiResult<T>(Either<AppFailure, T> either) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Выполни TaskEither и верни UiResult.
Future<UiResult<T>> runTaskAsUiResult<T>(AppTask<T> task) {
  throw UnimplementedError();
}

abstract interface class UserApi {
  Future<String> fetchUserJson(String id);

  Future<String> fetchUsersJson();

  Future<String> saveUser(UserDraft draft);
}

abstract interface class SettingsApi {
  Future<String> fetchSettingsJson(String userId);
}

sealed class AppFailure {
  const AppFailure();
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(this.message);

  final String message;
}

class ParseFailure extends AppFailure {
  const ParseFailure(this.message);

  final String message;
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(this.errors);

  final List<String> errors;
}

class UnknownFailure extends AppFailure {
  const UnknownFailure(this.error);

  final Object error;
}

class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.isActive,
  });

  final String id;
  final String name;
  final bool isActive;
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.isActive,
  });

  final String id;
  final String name;
  final bool isActive;
}

class UserDraft {
  const UserDraft({
    required this.name,
  });

  final String name;
}

class Settings {
  const Settings({
    required this.notificationsEnabled,
  });

  final bool notificationsEnabled;
}

class Profile {
  const Profile({
    required this.user,
    required this.settings,
  });

  final User user;
  final Settings settings;
}

sealed class UiResult<T> {
  const UiResult();
}

class UiSuccess<T> extends UiResult<T> {
  const UiSuccess(this.value);

  final T value;
}

class UiFailure<T> extends UiResult<T> {
  const UiFailure(this.message);

  final String message;
}
