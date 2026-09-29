# Шпаргалка: JSON в Dart (`dart:convert`)

JSON ↔ Dart-объекты: `jsonDecode` / `jsonEncode`, ручные `fromJson` / `toJson`, безопасный разбор типов. База для networking до codegen. Перед задачами прочитай этот файл, затем решай `json_task.dart`.

## 1. Encode / decode

```dart
import 'dart:convert';

final Object? raw = jsonDecode(source); // Map / List / num / String / bool / null
final String text = jsonEncode(map);    // объект → строка

String prettyJson(Map<String, dynamic> map) =>
    JsonEncoder.withIndent('  ').convert(map);
```

`jsonDecode` возвращает `dynamic`-дерево. Типичный корень API — `Map` или `List`.

```dart
Map<String, dynamic> decodeJsonMap(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map<String, dynamic>) {
    throw FormatException('expected JSON object');
  }
  return decoded;
}
```

Почему `Map<String, dynamic>`: ключи JSON — строки; значения — разные runtime-типы.

## 2. Модель: fromJson / toJson

```dart
class Address {
  const Address({required this.city, required this.street});
  final String city;
  final String street;

  factory Address.fromJson(Map<String, dynamic> json) {
    final city = json['city'];
    final street = json['street'];
    if (city is! String || street is! String) {
      throw FormatException('bad Address');
    }
    return Address(city: city, street: street);
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'street': street,
      };
}
```

Вложенность: достань `json['address'] as Map<String, dynamic>` (с проверкой) → `Address.fromJson`.

Список:

```dart
List<Person> parsePersonList(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! List) throw FormatException('expected array');
  return decoded
      .map((e) => Person.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

## 3. Optional поля и enum

```dart
final email = json['email'];
// отсутствует или null → null; иначе должен быть String
final String? mail = email == null ? null : email as String;

UserRole? roleFromString(String value) => switch (value) {
      'user' => UserRole.user,
      'admin' => UserRole.admin,
      _ => null,
    };
```

Неизвестный enum: либо `null`, либо `FormatException` — зависит от контракта API (в задачах модуля для Person — ошибка).

## 4. Безопасные касты

```dart
int? asInt(Object? value) => switch (value) {
      final int i => i,
      final num n => n.toInt(),
      final String s => int.tryParse(s),
      _ => null,
    };

Object? dig(Map<String, dynamic> json, String path) {
  Object? cur = json;
  for (final key in path.split('.')) {
    if (cur is! Map) return null;
    cur = cur[key];
  }
  return cur;
}
```

`as int` на `double` из JSON часто падает — JSON-числа могут прийти как `num`. Лучше `is` / `asInt`.

## 5. DateTime (зачем знать)

Обычно ISO-8601 строка:

```dart
DateTime.parse(json['createdAt'] as String);
// или DateTime.tryParse → null при мусоре
```

В `toJson` — `.toIso8601String()`.

## 6. Ручной parse vs codegen

| Подход | Плюсы | Минусы |
|---|---|---|
| Ручной `fromJson` | Контроль, без build_runner | Много бойлерплейта |
| `json_serializable` | Генерация, меньше ошибок | Нужен codegen, аннотации |

DTO (как пришло с API) часто отделяют от domain entity (бизнес-модель) — маппинг в одном месте, UI/домен не зависят от формы JSON.

## 7. Зачем это знать

- Каждый HTTP-ответ во Flutter — JSON → модель.
- Ловить битые поля через `FormatException`, а не через поздний crash в UI.
- Корректно тащить nested objects, списки, optional и enum.
- Понимать `dynamic` после `jsonDecode` и сужать типы явно.

Дальше: `json_task.dart` и `interview_questions.md`.
