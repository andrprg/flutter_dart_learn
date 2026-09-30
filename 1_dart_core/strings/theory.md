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

## 6. Неизменяемость и `StringBuffer`

Каждый `substring`, `replaceAll`, `+` выделяет новую строку и копирует символы. В цикле на тысячи кусков `result += piece` даёт квадратичное копирование.

```dart
final buf = StringBuffer();
for (final w in words) {
  if (buf.isNotEmpty) buf.write(' ');
  buf.write(w);
}
final text = buf.toString();
```

Для одной-двух склеек `+` и интерполяция нормальны: компилятор часто собирает их в один вызов. `StringBuffer` нужен, когда число кусков заранее неизвестно и большое.

Сравнение `==` у строк — по содержимому, не по ссылке. Регистр: `==` чувствителен; для поиска без регистра сравнивай `toLowerCase()` оба конца или RegExp с `caseSensitive: false`. `toLowerCase()` зависит от локали для редких символов; для ASCII и кириллицы в задачах модуля этого хватает.

## 7. Индексы, `[]` и графемы

`s[i]` — один UTF-16 code unit, тип `String` длины 1. Суррогат эмодзи по отдельности — невалидный «символ» для человека.

```dart
final runes = 'a👍b'.runes.toList(); // кодовые точки Unicode
final graphemes = 'a👍b'.characters; // пакет characters — то, что видит пользователь
```

`package:characters` режет по графемам (флаг, эмодзи с модификатором). В задачах модуля достаточно `runes`, если речь про «один символ», и обычных индексов для ASCII.

`substring` не любит отрицательные индексы и `end < start` — `RangeError`. Пустая строка: `''.substring(0, 0)` законно.

## 8. RegExp: группы, жадность, цена

```dart
final m = RegExp(r'(\w+)@(\w+\.\w+)').firstMatch('a@b.co');
m?.group(1); // локальная часть
m?.group(2); // домен
```

Скобки — группы с 1. `group(0)` — всё совпадение. Жадный `.+` съедает до последнего возможного места; ленивый `.+?` — до первого. Для URL и HTML жадность — частый источник «почти правильного» парсера.

Компилируй `RegExp` один раз в `static final` / поле, не в каждом вызове фильтра. Катастрофический откат (вложенные `.*` и неоднозначные ветки) на длинной строке подвешивает isolate. Пользовательский шаблон без `RegExp.escape` — и неверный матч, и риск такого отката.

`hasMatch` останавливается на первом совпадении. `allMatches` идёт до конца. `stringContains` через `contains(RegExp)` тоже останавливается рано.

## 9. Типичные ошибки

- `split(' ')` на тексте с табами и двойными пробелами — пустые куски. Надёжнее `RegExp(r'\s+')` и `where((w) => w.isNotEmpty)`.
- `trim` не трогает пробелы в середине.
- Собрать slug и забыть срезать `-` по краям: `"---"` после замены мусора.
- Маска телефона через конкатенацию кусков вместо одного шаблона — ломается, когда код страны переменной длины.
- Считать `length` числом символов на экране и обрезать эмодзи посередине суррогатной пары.

## 10. Зачем это знать

- Валидация ввода, маски email/телефона, slug для URL.
- Поиск и подсветка query в UI.
- Безопасный RegExp из пользовательской строки (`RegExp.escape`).
- Не путать code units и «видимые символы».

Дальше: `string_task.dart` и `interview_questions.md`.
