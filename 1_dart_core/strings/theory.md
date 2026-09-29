# Шпаргалка: Strings и RegExp в Dart

Строки в Dart **неизменяемые** (`immutable`): любой `replace`/`substring` даёт новую строку. Модуль — нормализация текста, маски, slug, парсинг, RegExp. Перед задачами прочитай этот файл, затем решай `string_task.dart`.

## 1. База

```dart
final s = 'Hello';
s.length;
s.isEmpty;
s.toLowerCase();
s.toUpperCase();
s.trim();                 // края
s.split(' ');
s.substring(0, 3);        // [start, end)
s.contains('el');
s.startsWith('He');
s.padLeft(8, '0');
s.replaceAll(' ', '-');
```

Интерполяция:

```dart
'$name';           // простая переменная
'${user.name}';    // выражение
'${n + 1}';
```

Аналога JS `slice` с отрицательными индексами в core нет — считай границы сам или через `substring`.

## 2. UTF-16 и ловушки

Строка — последовательность UTF-16 code units. Эмодзи / часть символов — **суррогатные пары** (2 code units → `length` «врёт» для человека).

```dart
'👍'.length;           // 2
'👍'.runes.length;     // 1 — лучше для «символов»
```

Для большинства ASCII/кириллицы задач модуля `length` / индексы ок; помни про emoji на собеседовании.

## 3. RegExp

```dart
final re = RegExp(r'\d+');
re.hasMatch('ab12');
re.firstMatch('ab12')?.group(0);     // '12'
re.allMatches('a1b22').map((m) => m.group(0)!);

RegExp(r'^[a-z]+$', caseSensitive: false);
RegExp(r'^.*$', multiLine: true);    // ^/$ на каждую строку
```

| Флаг | Эффект |
|---|---|
| `caseSensitive: false` | Без учёта регистра |
| `multiLine: true` | `^` / `$` — границы строк |
| `dotAll: true` | `.` включает `\n` |

Экранирование пользовательского ввода:

```dart
RegExp(RegExp.escape(query), caseSensitive: false);
```

Иначе символы вроде `.` `*` `(` сломают паттерн или откроют ReDoS-риск.

## 4. Паттерны задач модуля

```dart
// пробелы → один
input.trim().replaceAll(RegExp(r'\s+'), ' ');

// слова (буквы/цифры)
RegExp(r'[A-Za-z0-9А-Яа-яЁё]+').allMatches(input);

// hex color
RegExp(r'^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$').hasMatch(input);

// camel → snake
input.replaceAllMapped(
  RegExp(r'[A-Z]'),
  (m) => '_${m[0]!.toLowerCase()}',
);

// highlight без порчи регистра текста
text.replaceAllMapped(
  RegExp(RegExp.escape(query), caseSensitive: false),
  (m) => '<mark>${m[0]}</mark>',
);

// slug
input
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');
```

Палиндром текста: оставь только буквы/цифры, lower case, сравни со `reversed`.

Query string: `split('&')` → пары `key=value` (учесть пустой ввод).

## 5. UI-мелочи

```dart
// ellipsis
input.length <= max
    ? input
    : '${input.substring(0, max)}...';

// initials
fullName.trim().split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase())
    .join();
```

## 6. Зачем это знать

- Валидация ввода, маски email/телефона, slug для URL.
- Поиск и подсветка query в UI.
- Безопасный RegExp из пользовательской строки (`RegExp.escape`).
- Не путать code units и «видимые символы».

Дальше: `string_task.dart` и `interview_questions.md`.
