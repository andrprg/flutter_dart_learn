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

## 7. Что `jsonEncode` умеет сам

`jsonEncode` принимает `Map`, `List`, `String`, `num`, `bool`, `null`. Свой класс без перевода в эти типы бросает `JsonUnsupportedObjectError`.

```dart
jsonEncode(user);          // плохо, если User не Map
jsonEncode(user.toJson()); // хорошо
```

`DateTime` сам не сериализуется — только строка или число, которое ты положил в `toJson`. `NaN` и `Infinity` у `double` в JSON не входят: `jsonEncode` бросит. Enum по умолчанию не строка — клади `role.name` или свой код.

Ключи карты при encode должны быть `String`. `Map<int, String>` для JSON сначала переведи ключи: `map.map((k, v) => MapEntry('$k', v))`.

`jsonDecode` чисел: целое влезает в `int`, большое или с точкой — `double`. Поэтому `as int` на поле, которое бэкенд прислал как `1.0`, падает. Хелпер `asInt` из раздела 4 закрывает оба случая.

## 8. Глубокая копия и мутация

`jsonDecode` каждый раз строит **новое** дерево. Мутация `decoded['name'] = 'x'` не меняет исходную строку. Обратно: `toJson()`, который возвращает внутренний `Map` модели, а не копию, позволяет снаружи сломать объект. Возвращай новый литерал.

Список моделей:

```dart
List<Map<String, dynamic>> toJsonList(List<Person> people) =>
    [for (final p in people) p.toJson()];
```

Один битый элемент в массиве: решай контрактом. Либо весь разбор падает на первом (`map` + `fromJson`), либо собираешь ошибки по индексу. В задачах модуля — падать `FormatException`, чтобы битый ответ не стал «полупустым» списком молча.

## 9. Имена полей и версия контракта

API часто отдаёт `snake_case`, модель в Dart — `camelCase`. Маппинг только в `fromJson` / `toJson`, не в UI.

Необязательное поле, которого нет в старых ответах: `json['email']` даёт `null`, это не исключение. Обязательное поле без ключа — `FormatException`, не `as String` на `null` (сообщение будет про cast, а не про контракт).

Лишние ключи обычно игнорируют: разбор устойчив к расширению API. Если нужен строгий контракт — проверяй набор ключей явно.

## 10. Типичные ошибки

- `jsonDecode` на пустой строке — `FormatException`. Отличай пустое тело 204 от битого JSON.
- Двойной encode: уже строка `'{"a":1}'` уедет как JSON-строка в кавычках, не как объект.
- `as Map<String, dynamic>` на `Map<dynamic, dynamic>` из старого кода иногда проходит, но вложенные значения остаются `dynamic` — каст нужен на каждом уровне.
- Забыть, что `json['items']` может быть `null`, и вызвать `.map` на нём.

## 11. Зачем это знать

- Каждый HTTP-ответ во Flutter — JSON → модель.
- Ловить битые поля через `FormatException`, а не через поздний crash в UI.
- Корректно тащить nested objects, списки, optional и enum.
- Понимать `dynamic` после `jsonDecode` и сужать типы явно.

Дальше: `json_task.dart` и `interview_questions.md`.
