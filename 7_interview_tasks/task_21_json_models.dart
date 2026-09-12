/// ЗАДАЧА 21 — Парсинг JSON в модели (без codegen)
/// Уровень: Mid
/// Тема: Map<String, dynamic>, null-safety, enum, вложенные модели, DateTime
///
/// Частый вопрос на собеседовании:
/// «Как вы парсите JSON в Dart без json_serializable? Как валидируете поля?»
///
/// Реализуйте:
/// - enum [UserRole] с преобразованием из строки
/// - модели [Address] и [UserProfile] с fromJson/toJson
/// - защиту от некорректных типов / отсутствующих обязательных полей
///
/// Условия:
/// - `id`, `name`, `role`, `createdAt`, `address` — обязательные
/// - `phone` — опциональное (может отсутствовать или быть null)
/// - `createdAt` приходит строкой ISO-8601
/// - Если данные некорректны — бросайте [FormatException]

// ─── Модели ──────────────────────────────────────────────────────────────────

enum UserRole { user, admin }

class Address {
  final String city;
  final String street;
  final int house;

  const Address({
    required this.city,
    required this.street,
    required this.house,
  });

  @override
  String toString() => 'Address(city: $city, street: $street, house: $house)';
}

class UserProfile {
  final int id;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final Address address;
  final String? phone;

  const UserProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.address,
    this.phone,
  });

  @override
  String toString() =>
      'UserProfile(id: $id, name: $name, role: $role, createdAt: $createdAt, address: $address, phone: $phone)';
}

// ─── Ваше решение ────────────────────────────────────────────────────────────

UserRole parseUserRole(String value) {
  // TODO: распарсите строку в UserRole (user/admin), иначе FormatException
  throw UnimplementedError();
}

Address addressFromJson(Map<String, dynamic> json) {
  // TODO: распарсите Address, валидируйте типы
  throw UnimplementedError();
}

Map<String, dynamic> addressToJson(Address address) {
  // TODO: сериализуйте Address
  throw UnimplementedError();
}

UserProfile userProfileFromJson(Map<String, dynamic> json) {
  // TODO: распарсите UserProfile, валидируйте типы и обязательные поля
  throw UnimplementedError();
}

Map<String, dynamic> userProfileToJson(UserProfile user) {
  // TODO: сериализуйте UserProfile (createdAt -> ISO-строка)
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

UserRole parseUserRoleAnswer(String value) {
  switch (value) {
    case 'user':
      return UserRole.user;
    case 'admin':
      return UserRole.admin;
    default:
      throw FormatException('Неизвестная роль: $value');
  }
}

String _requireString(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v is String) return v;
  throw FormatException('Поле "$key" должно быть String');
}

int _requireInt(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v is int) return v;
  throw FormatException('Поле "$key" должно быть int');
}

Map<String, dynamic> _requireMap(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v is Map<String, dynamic>) return v;
  if (v is Map) {
    return v.map((k, v) => MapEntry(k.toString(), v));
  }
  throw FormatException('Поле "$key" должно быть объектом');
}

DateTime _requireDateTimeIso(Map<String, dynamic> json, String key) {
  final s = _requireString(json, key);
  final dt = DateTime.tryParse(s);
  if (dt == null) throw FormatException('Поле "$key" должно быть ISO-датой');
  return dt.toUtc();
}

Address addressFromJsonAnswer(Map<String, dynamic> json) {
  return Address(
    city: _requireString(json, 'city'),
    street: _requireString(json, 'street'),
    house: _requireInt(json, 'house'),
  );
}

Map<String, dynamic> addressToJsonAnswer(Address address) => <String, dynamic>{
      'city': address.city,
      'street': address.street,
      'house': address.house,
    };

UserProfile userProfileFromJsonAnswer(Map<String, dynamic> json) {
  final phone = json['phone'];
  if (phone != null && phone is! String) {
    throw const FormatException('Поле "phone" должно быть String или null');
  }

  return UserProfile(
    id: _requireInt(json, 'id'),
    name: _requireString(json, 'name'),
    role: parseUserRoleAnswer(_requireString(json, 'role')),
    createdAt: _requireDateTimeIso(json, 'createdAt'),
    address: addressFromJsonAnswer(_requireMap(json, 'address')),
    phone: phone as String?,
  );
}

Map<String, dynamic> userProfileToJsonAnswer(UserProfile user) =>
    <String, dynamic>{
      'id': user.id,
      'name': user.name,
      'role': switch (user.role) {
        UserRole.user => 'user',
        UserRole.admin => 'admin'
      },
      'createdAt': user.createdAt.toUtc().toIso8601String(),
      'address': addressToJsonAnswer(user.address),
      'phone': user.phone,
    };

// ─── Мини-демо ────────────────────────────────────────────────────────────────

void main() {
  final json = <String, dynamic>{
    'id': 1,
    'name': 'Анна',
    'role': 'admin',
    'createdAt': '2026-04-16T12:00:00Z',
    'address': {'city': 'Москва', 'street': 'Тверская', 'house': 10},
    'phone': null,
  };

  final user = userProfileFromJsonAnswer(json);
  print(user);
  print(userProfileToJsonAnswer(user));
}
