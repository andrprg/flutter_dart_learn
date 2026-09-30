# Паттерны и записи в Dart 3

По мотивам [Google Codelab: Patterns and records](https://codelabs.developers.google.com/codelabs/dart-patterns-records).
В оригинале собирают Flutter-приложение. Здесь та же языковая тема, но без виджетов: JSON-документ разбирается записями, паттернами и `sealed`-классами.

Перед задачами прочитай этот файл, затем решай `patterns_task.dart`.

## Что появляется в Dart 3

- **записи (records)** — несколько значений разных типов в одном объекте;
- **паттерны** — проверка формы данных, сопоставление и деструктуризация;
- **`if-case`** и **выражения `switch`**;
- **`sealed`-классы** и **проверка исчерпываемости** `switch`.

Сценарий всего модуля — документ, который «пришёл» как JSON:

```json
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {"type": "h1", "text": "Chapter 1"},
    {"type": "p", "text": "Lorem ipsum dolor sit amet."},
    {"type": "checkbox", "checked": false, "text": "Learn Dart 3"}
  ]
}
```

---

## 1. Записи (Records)

Запись — список полей в скобках. Поля могут быть разных типов, позиционными и именованными (как аргументы функции). Функция может вернуть несколько значений одним вызовом.

```dart
(String, {DateTime modified}) get metadata {
  const title = 'My Document';
  final now = DateTime.now();
  return (title, modified: now);
}
```

Возвращаемый тип — запись из двух полей: позиционная `String` и именованная `DateTime modified`.

### Доступ к полям

```dart
final metadataRecord = document.metadata;

metadataRecord.$1;         // позиционное поле title
metadataRecord.modified;   // именованное поле
```

Позиционные геттеры `$1`, `$2`, … считают **только неименованные** поля:

```dart
final record = (named: 'v', 'y', named2: 'x', 'z');
print(record.$1); // y
print(record.$2); // z
```

Класс тоже умеет хранить разные типы, но запись короче, когда отдельный тип не нужен.

---

## 2. Паттерны: сопоставление и деструктуризация

Паттерн — чертёж формы значения. Его сравнивают с данными: совпало или нет. Некоторые паттерны при совпадении **деструктурируют** объект: достают части и кладут их в переменные.

### Неопровержимый паттерн (irrefutable)

Объявление переменной обязано совпасть, иначе это ошибка (как присвоить `int` в `String`).

```dart
final (title, modified: modified) = document.metadata;
// String title и DateTime modified уже локальные переменные
```

Если имя поля и имя переменной совпадают, пишут короче:

```dart
final (title, :modified) = document.metadata; // то же, что modified: modified
```

Другое имя: `modified: localModified`.

Подстановочный знак `_` совпадает с чем угодно и **не создаёт** переменную:

```dart
final (title, _) = document.metadata; // дату отбросили
```

### Опровержимый паттерн (refutable)

В `if-case` и `switch` несовпадение — норма: выполнение идёт дальше, программа не падает. Переменные из паттерна видны только в совпавшей ветке.

---

## 3. JSON без паттернов и с `if-case`

Проверки вручную: есть ключ, значение — `Map`, поля — строки.

```dart
(String, {DateTime modified}) get metadata {
  if (_json.containsKey('metadata')) {
    final metadataJson = _json['metadata'];
    if (metadataJson is Map) {
      final title = metadataJson['title'] as String;
      final localModified = DateTime.parse(metadataJson['modified'] as String);
      return (title, modified: localModified);
    }
  }
  throw const FormatException('Unexpected JSON');
}
```

Тот же смысл одним **опровержимым map-паттерном** и оператором `if-case` (Dart 3):

```dart
(String, {DateTime modified}) get metadata {
  if (_json case {
    'metadata': {'title': String title, 'modified': String localModified},
  }) {
    return (title, modified: DateTime.parse(localModified));
  } else {
    throw const FormatException('Unexpected JSON');
  }
}
```

Этот паттерн сразу проверяет:

- `_json` — `Map` и не `null`;
- есть ключ `metadata`, и это тоже `Map`;
- есть ключи `title` и `modified`, оба — непустые `String`.

Не совпало — паттерн **опровергается**, управление уходит в `else`. Совпало — значения уже в `title` и `localModified`.

**Map-паттерн смотрит только на указанные ключи.** Лишний `'checked'` в блоке JSON не мешает, если в паттерне его нет.

---

## 4. Список блоков

Фабрика с map-паттерном:

```dart
factory Block.fromJson(Map<String, Object?> json) {
  if (json case {'type': final type, 'text': final text}) {
    return Block(type, text);
  } else {
    throw const FormatException('Unexpected JSON format');
  }
}
```

Список блоков: паттерн `List` + collection-for.

```dart
List<Block> getBlocks() {
  if (_json case {'blocks': List blocksJson}) {
    return [
      for (final blockJson in blocksJson)
        Block.fromJson(blockJson as Map<String, Object?>),
    ];
  } else {
    throw const FormatException('Unexpected JSON format');
  }
}
```

---

## 5. Оператор `switch` и логическое ИЛИ

```dart
switch (block.type) {
  case 'h1':
    textStyle = headingStyle;
  case 'p' || 'checkbox':
    textStyle = bodyStyle;
  case _:
    textStyle = fallbackStyle;
}
```

- `'h1'` — константный строковый паттерн;
- `'p' || 'checkbox'` — логическое ИЛИ: совпадёт любой подпаттерн (есть и `&&`);
- `_` — wildcard, как `default`. По-прежнему можно писать `default`.

С Dart 3 в непустых `case` **не нужен `break`**: выполнение не проваливается в следующий случай.

---

## 6. Выражение `switch`

`switch` может **вернуть значение** и стоять справа от `=` или в `return`. Слово `case` не пишут, паттерн отделяют `=>`.

```dart
final textStyle = switch (block.type) {
  'h1' => headingStyle,
  'p' || 'checkbox' => bodyStyle,
  _ => fallbackStyle,
};
```

---

## 7. Объектные паттерны

Паттерны работают с любыми объектами, миграция классов не нужна. Синтаксис похож на конструктор, но это **чтение геттеров**, а не создание объекта.

```dart
String formatDate(DateTime dateTime, {required DateTime now}) {
  final difference = dateTime.difference(now);

  return switch (difference) {
    Duration(inDays: 0) => 'сегодня',
    Duration(inDays: 1) => 'завтра',
    Duration(inDays: -1) => 'вчера',
    Duration(inDays: final days, isNegative: true) => '${days.abs()} дн. назад',
    Duration(inDays: final days) => 'через $days дн.',
  };
}
```

Первые три случая — константные подпаттерны `0`, `1`, `-1` для геттера `inDays`. Дальше связывается `days`, при необходимости проверяется `isNegative`.

---

## 8. Защитные условия (`when`)

`when` добавляется **после** совпадения паттерна. Если условие ложно, весь `case` опровергается, и проверяется следующий.

```dart
return switch (difference) {
  Duration(inDays: 0) => 'сегодня',
  Duration(inDays: 1) => 'завтра',
  Duration(inDays: -1) => 'вчера',
  Duration(inDays: final days) when days > 7 => 'через ${days ~/ 7} нед.',
  Duration(inDays: final days) when days < -7 => '${days.abs() ~/ 7} нед. назад',
  Duration(inDays: final days, isNegative: true) => '${days.abs()} дн. назад',
  Duration(inDays: final days) => 'через $days дн.',
};
```

Более узкие случаи (недели) стоят **выше** общих (дни). Иначе `when` никогда не дойдёт до проверки.

`when` работает в `if-case`, операторе `switch` и выражении `switch`.

---

## 9. `sealed` и исчерпывающий `switch`

`switch` **исчерпывающий**, если покрыты все возможные значения: для `bool` это `true` и `false`, для `enum` — каждый элемент.

Модификатор `sealed` расширяет эту проверку на иерархию классов: подклассы можно объявлять **только в той же библиотеке**, поэтому анализатор знает полный набор типов.

```dart
sealed class Block {
  const Block();

  factory Block.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool checked} =>
        CheckboxBlock(text, checked),
      _ => throw const FormatException('Unexpected JSON format'),
    };
  }
}

class HeaderBlock extends Block {
  const HeaderBlock(this.text);
  final String text;
}
```

Дальше `switch` по самому объекту, а не по строке `type`. Свойства достаются объектным паттерном:

```dart
String renderBlock(Block block) => switch (block) {
  HeaderBlock(:final text) => '# $text',
  ParagraphBlock(:final text) => text,
  CheckboxBlock(:final text, :final isChecked) =>
    isChecked ? '[x] $text' : '[ ] $text',
};
```

Нет wildcard: анализатор требует все подклассы. Удали один `case` — получишь ошибку «The type 'Block' is not exhaustively matched».

---

## 10. Шпаргалка видов паттернов

### Деструктуризация

```dart
var (name, age) = ('Alice', 25);              // запись
var [a, b, c] = [1, 2, 3];                    // список
var [head, ...tail] = [1, 2, 3, 4];           // rest: head=1, tail=[2,3,4]
var {'name': String n, 'age': int a} = map;   // карта
var User(:name, :age) = user;                 // объект, имена = поля
```

### Сопоставление

```dart
if (obj case [int x, int y]) { ... }

String describe(Object obj) => switch (obj) {
  1 => 'Один',
  String s => 'Строка $s',
  [int a, int b] => 'Два числа: $a, $b',
  _ => 'Что-то другое',
};
```

### Полезные формы

| Паттерн | Смысл |
|---|---|
| `_` | совпадает с чем угодно, значение выбрасывается |
| `'a' \|\| 'b'` | логическое ИЛИ |
| `int x && > 0` | логическое И |
| `>= 18` | реляционный |
| `var foo as String` | приведение (`as`); не совпал тип — исключение |
| `String? name?` | null-check: совпадает, если не `null` |
| `case [int a, int b] when a > b` | guard после совпадения |

### Цикл `for`

```dart
for (final (x, y) in points) { ... }
for (final MapEntry(:key, :value) in map.entries) { ... }
```

---

## 11. Записи против класса

Запись сравнивается по значениям полей: `(1, 2) == (1, 2)` — истина, `hashCode` согласован. Отдельный `==` писать не нужно. В `Map` и `Set` запись-ключ работает, пока поля сами корректно сравниваются.

Запись не даёт методов и инвариантов. Как только появляются «нельзя отрицательную цену» или `copyWith` с именем поля — это класс. Кортеж из трёх безымянных `String` через неделю не читается: именованные поля (`title:`, `city:`) или маленький класс.

`(a, b)` и `(b, a)` — разные типы, если типы полей различаются. Позиция входит в тип. Именованные поля различаются по имени, не по порядку объявления.

Вложенная запись и паттерн раскрываются на месте:

```dart
final ((title, modified: date),) = (document.metadata,);
```

Лишняя запятая в типе `(String,)` — запись из одного поля, не группировка скобками. `(String)` — это просто `String`.

## 12. Исчерпываемость и `switch` как выражение

Выражение `switch` обязано вернуть значение на каждой ветке и быть исчерпывающим, иначе код не скомпилируется. Оператор `switch` по `sealed` без wildcard тоже. По `int` или `String` без `_` исчерпывающим не бывает: значений бесконечно.

`when` проверяется **после** совпадения паттерна. Ветка может совпасть по форме и отвалиться по условию. Если все такие ветки отвалились и нет `_`, для выражения это runtime-ошибка «no match», не тишина. Поэтому у выражения на внешнем `Object` почти всегда есть `_`.

Порядок веток важен: первая совпавшая побеждает. `case int x` выше `case 1` сделает ветку `1` мёртвой.

Object pattern `User(:name)` требует, чтобы геттер был доступен. Приватное поле чужой библиотеки так не достать. Имена в паттерне — имена геттеров, не «как удобно назвать».

## 13. Типичные ошибки

- Путать `$1` с «первое поле вообще». Именованные в `$n` не входят.
- `switch` по JSON-`Map` без `_` и думать, что анализатор знает все ключи API. Не знает: нужен wildcard или разбор в `sealed` заранее.
- Деструктуризация `var (a, b) = record` на записи другой формы — ошибка компиляции, не `null`.
- Забыть `break` не нужно: в Dart 3 ветки `switch` не проваливаются друг в друга. Общая логика — через `||` в одном паттерне или вынесенную функцию.
- `sealed` в одном файле, подкласс в другом файле той же библиотеки — можно (`part` / одна library). Подкласс в другом пакете — нельзя.

## Что потренировать в задачах

1. Собрать и вернуть запись, прочитать `$1` / именованные поля.
2. Распаковать запись, включая `:name` и `_`.
3. Разобрать JSON через `if-case` и map-паттерн.
4. Выбрать ветку `switch`-выражением (`||`, `_`).
5. Отформатировать дату объектным паттерном `Duration` и `when`.
6. Собрать `sealed`-иерархию блоков и исчерпывающий `switch`.

Документация: [Records](https://dart.dev/language/records), [Patterns](https://dart.dev/language/pattern-types), [Branches](https://dart.dev/language/branches), [Class modifiers](https://dart.dev/language/class-modifiers).
