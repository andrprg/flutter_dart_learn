# Шпаргалка: Null Safety в Dart

Null safety — система типов, где `null` разрешён только у nullable-типов (`T?`). Компилятор не даёт «забыть» про null: либо проверь, либо дай запасной путь. Перед задачами прочитай этот файл, затем решай `null_safety_task.dart`.

## 1. `T` vs `T?`

| Тип | Может быть null? |
|---|---|
| `String`, `int`, `List<T>` | Нет |
| `String?`, `int?`, `List<T>?` | Да |

`List<String?>` — список может быть не-null, но элементы — null.  
`List<String>?` — сам список может быть null, элементы — нет.

## 2. Операторы

```dart
String? name;

name?.length;          // null, если name == null; иначе length
name ?? 'guest';       // name, иначе 'guest'
name ??= 'guest';      // если null — присвоить и вернуть
name!.length;          // «я уверен, что не null» — краш, если врёшь
```

| Оператор | Смысл |
|---|---|
| `?.` | Вызов/доступ только если слева не null |
| `??` | Значение слева, иначе справа |
| `??=` | Присвоить справа, только если слева null |
| `!` | Assert non-null (опасно: runtime crash) |

`!` допустим, когда ты **доказал** non-null снаружи анализатора (например, после API, которое гарантий не даёт в типах). В обычном коде предпочитай `??`, `?.` и early return.

## 3. Promotion

Локальные переменные после проверки становятся non-null:

```dart
int doubleOrZero(int? value) {
  if (value != null) return value * 2; // value уже int
  return 0;
}

String? asStringOrNull(Object? value) {
  if (value is String) return value; // promotion через is
  return null;
}
```

**Поля класса** не промотируются так же надёжно: между чтением кто-то мог изменить поле. Для поля копируй в локальную переменную или используй `!` / getter с проверкой.

## 4. `late` и definite assignment

`late` — «присвою позже, но до первого чтения»:

```dart
late String configUrl;

void init() {
  configUrl = 'https://api.example.com';
}
```

Если прочитать до присвоения — `LateInitializationError`.  
`late final` — один раз; удобно для ленивой инициализации.

## 5. Map lookup

`map[key]` всегда `V?`, даже если `Map<K, V>`: ключа может не быть.

```dart
String userNameOrUnknown(Map<int, String> users, int id) {
  return users[id] ?? 'unknown';
}
```

`containsKey` ≠ «значение не null»: значение само может быть nullable.

## 6. Cascade и Never

```dart
MutableUser? applyName(MutableUser? user, String name) {
  return user?..name = name; // cascade на nullable
}

Never fail(String message) => throw StateError(message);
```

`Never` — функция не возвращается. Полезно в `switch` / ветках ошибок.

## 7. Типичные паттерны

```dart
int lengthOrZero(String? value) => value?.length ?? 0;

String? normalizeName(String? value) {
  final t = value?.trim();
  if (t == null || t.isEmpty) return null;
  return t;
}

List<String> compact(List<String?>? list) =>
    [...?list?.whereType<String>()];
```

## 8. Зачем это знать

- Писать API без сюрпризов `Null check operator used on a null value`.
- Отличать «нет ключа в Map» от «значение null».
- Понимать, когда `!` — осознанный риск, а когда — костыль.
- Во Flutter: optional виджеты, `?.` на `context`, nullable из JSON.

Дальше: `null_safety_task.dart` и `interview_questions.md`.
