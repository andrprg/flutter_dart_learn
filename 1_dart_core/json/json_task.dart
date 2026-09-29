import 'dart:convert';

// ============================================================
// 12 ЗАДАЧ ПО JSON (dart:convert)
// ============================================================
// Цель: encode/decode, модели fromJson/toJson, списки и безопасный parse.
// База для networking и fpdart repository.

enum UserRole { user, admin }

UserRole? roleFromString(String value) {
  throw UnimplementedError();
}

String roleToString(UserRole role) {
  throw UnimplementedError();
}

class Address {
  const Address({required this.city, required this.street});

  final String city;
  final String street;

  factory Address.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.role,
    required this.address,
    this.email,
  });

  final int id;
  final String name;
  final UserRole role;
  final Address address;
  final String? email;

  factory Person.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 1
// roleFromString: 'user'/'admin', иначе null. (см. выше)

// ЗАДАЧА 2
// roleToString. (см. выше)

// ЗАДАЧА 3–4
// Address.fromJson / toJson. city и street обязательны → FormatException.

// ЗАДАЧА 5–6
// Person.fromJson / toJson.
// id:int, name:String, role:String, address:Map, email?:String.
// Неизвестный role → FormatException.

// ЗАДАЧА 7
// decodeJsonMap: jsonDecode + проверка что это Map.
Map<String, dynamic> decodeJsonMap(String source) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// encodeJsonMap: jsonEncode.
String encodeJsonMap(Map<String, dynamic> map) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// parsePersonList: JSON-массив объектов Person.
List<Person> parsePersonList(String source) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// pretty: jsonEncode с indent '  '.
String prettyJson(Map<String, dynamic> map) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Достань nested path 'a.b.c' из Map. Нет пути → null.
Object? dig(Map<String, dynamic> json, String path) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Безопасный int: int / num / numeric String, иначе null.
int? asInt(Object? value) {
  throw UnimplementedError();
}
