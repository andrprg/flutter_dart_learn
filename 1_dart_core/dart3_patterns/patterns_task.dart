import 'dart:convert';

// ============================================================
// 15 ЗАДАЧ: RECORDS, PATTERNS, SWITCH, SEALED (Dart 3)
// ============================================================
// По мотивам Google Codelab:
// https://codelabs.developers.google.com/codelabs/dart-patterns-records
//
// Цель: разобрать JSON-документ записями и паттернами, без Flutter.
// Перед задачами прочитай theory.md.
//
// Сценарий — тот же документ, что в коделабе:
// metadata (title + modified) и blocks (h1 / p / checkbox).

const sampleDocumentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {"type": "h1", "text": "Chapter 1"},
    {"type": "p", "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."},
    {"type": "checkbox", "checked": false, "text": "Learn Dart 3"}
  ]
}
''';

Map<String, Object?> sampleDocument() {
  return jsonDecode(sampleDocumentJson) as Map<String, Object?>;
}

// ─── Пример (не редактируй) ──────────────────────────────────
// Запись собирается скобками и сразу распаковывается паттерном.
String exampleTitleFromRecord() {
  final metadata = ('My Document', modified: DateTime.utc(2023, 5, 10));
  final (title, :modified) = metadata;
  return '$title (${modified.year})';
}

/// Базовый уровень (1–5): записи и деструктуризация

// ЗАДАЧА 1
// Верни запись: позиционное поле title и именованное modified.
(String, {DateTime modified}) makeMetadata(String title, DateTime modified) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// В записи (named: 'v', 'y', named2: 'x', 'z') именованные поля
// не входят в $1/$2. Верни строку '$1-$2', то есть 'y-z'.
String positionalGetters(
  (String, String, {String named, String named2}) record,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Распакуй запись сокращением :modified.
// Верни 'title | iso', где iso — modified.toIso8601String().
String unpackMetadata((String, {DateTime modified}) metadata) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Отбрось дату через wildcard `_` и верни только title.
String titleIgnoringDate((String, {DateTime modified}) metadata) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Распакуй как (title, modified: localModified) — имя переменной
// не совпадает с именем поля. Верни (title, localModified).
(String, DateTime) unpackRenamed((String, {DateTime modified}) metadata) {
  throw UnimplementedError();
}

/// Средний уровень (6–10): if-case, map/list-паттерны, switch

// ЗАДАЧА 6
// if-case + вложенный map-паттерн, как metadata в коделабе.
// Если json имеет форму
//   {'metadata': {'title': String, 'modified': String}}
// верни (title, modified: DateTime.parse(...)).
// Иначе брось FormatException('Unexpected JSON').
(String, {DateTime modified}) parseMetadata(Object? json) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Map-паттерн {'type': String, 'text': String}.
// Лишние ключи (например checked) игнорируются.
// Если type/text отсутствуют или не String — FormatException.
({String type, String text}) parseBlockFields(Object? json) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// if-case: {'blocks': List blocksJson}.
// Каждый элемент разбери через parseBlockFields.
// Иначе FormatException('Unexpected JSON format').
List<({String type, String text})> parseBlocks(Object? json) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Выражение switch по type:
//   'h1'              -> 'heading'
//   'p' || 'checkbox' -> 'body'
//   _                 -> 'fallback'
String styleForType(String type) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Объектный паттерн Duration, без недель:
//   inDays  0  -> сегодня
//   inDays  1  -> завтра
//   inDays -1  -> вчера
//   isNegative -> '${days.abs()} дн. назад'
//   иначе      -> 'через $days дн.'
// difference = dateTime.difference(now)
String formatRelativeDate(DateTime dateTime, {required DateTime now}) {
  throw UnimplementedError();
}

/// Продвинутый уровень (11–15): guards, sealed, exhaustive switch

// ЗАДАЧА 11
// Как задача 10, плюс guards (стоят выше «дней»):
//   days > 7  -> 'через ${days ~/ 7} нед.'
//   days < -7 -> '${days.abs() ~/ 7} нед. назад'
String formatRelativeDateWithWeeks(
  DateTime dateTime, {
  required DateTime now,
}) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Фабрика sealed-иерархии. Выражение switch по map:
//   type h1 + text String                         -> HeaderBlock
//   type p + text String                          -> ParagraphBlock
//   type checkbox + text String + checked bool    -> CheckboxBlock
//   иначе FormatException('Unexpected JSON format')
Block blockFromJson(Map<String, Object?> json) {
  throw UnimplementedError();
}

// ЗАДАЧА 13
// Исчерпывающий switch по подклассам Block (без `_` и default):
//   HeaderBlock    -> '# $text'
//   ParagraphBlock -> text
//   CheckboxBlock  -> '[x] $text' или '[ ] $text'
String renderBlock(Block block) {
  throw UnimplementedError();
}

// ЗАДАЧА 14
// true, если в списке есть CheckboxBlock с isChecked: false.
// Используй объектный паттерн (и при желании guard).
bool hasUncheckedItem(List<Block> blocks) {
  throw UnimplementedError();
}

// ЗАДАЧА 15
// Сводка документа. Можно вызвать parseMetadata, parseBlocks
// и formatRelativeDateWithWeeks.
// Формат ровно три строки:
//   $title
//   Last modified: $relative
//   Блоков: $count
String documentSummary(Object? json, {required DateTime now}) {
  throw UnimplementedError();
}

sealed class Block {
  const Block();
}

class HeaderBlock extends Block {
  const HeaderBlock(this.text);

  final String text;
}

class ParagraphBlock extends Block {
  const ParagraphBlock(this.text);

  final String text;
}

class CheckboxBlock extends Block {
  const CheckboxBlock(this.text, this.isChecked);

  final String text;
  final bool isChecked;
}
