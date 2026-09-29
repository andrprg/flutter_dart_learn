// ============================================================
// 12 ЗАДАЧ ПО NULL SAFETY
// ============================================================
// Цель: ?, !, ??, ??=, late, promotion — писать безопасный Dart.

// ЗАДАЧА 1
// Верни length строки или 0, если null.
int lengthOrZero(String? value) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Если value null или пустой (trim) — null, иначе trim.
String? normalizeName(String? value) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// ?? : верни primary, иначе fallback.
String pickLabel(String? primary, String fallback) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// ??= : если cache null — запиши compute() и верни; иначе верни cache.
String readThroughCache(Map<String, String?> store, String key, String Function() compute) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Promotion: если value != null верни value * 2, иначе 0.
int doubleOrZero(int? value) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Безопасный каст: если value is String — верни, иначе null.
String? asStringOrNull(Object? value) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// required non-null: пустой name → ArgumentError, иначе name.
String requireName(String? name) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Ленивый конфиг: храни url в nullable поле.
// isInitialized == true, если url уже задан.
// apiUrl геттер: если null — StateError, иначе значение.
// ensureInitialized задаёт url только один раз (если уже есть — не меняй).
class LazyConfig {
  String? _apiUrl;

  bool get isInitialized {
    throw UnimplementedError();
  }

  String get apiUrl {
    throw UnimplementedError();
  }

  void ensureInitialized(String url) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9
// List<String>? — верни копию без null-элементов... список не nullable элементов.
// Если list == null → [].
List<String> compact(List<String?>? list) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Map lookup: users[id] может быть null. Верни 'unknown', если нет.
String userNameOrUnknown(Map<int, String> users, int id) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// cascade с nullable: если user == null — null,
// иначе верни user..name = name (через копию нельзя — сделай функцию
// applyName(User? user, String name), которая меняет name и возвращает user).
class MutableUser {
  MutableUser(this.name);
  String name;
}

MutableUser? applyName(MutableUser? user, String name) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Never-путь: брось StateError(message). Тип возврата Never.
Never fail(String message) {
  throw UnimplementedError();
}
