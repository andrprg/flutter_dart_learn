# Шпаргалка: Localization (i18n)

Локализация — строки, plural, даты и направление письма под `Locale` пользователя. В проде Flutter: ARB + `flutter gen-l10n`. В модуле — учебный каталог `MessageCatalog`, чтобы понять алгоритм без кодогена.

Перед задачами прочитай этот файл, затем решай `localization_task.dart`.

## 1. Locale resolution

```dart
String normalizeLanguageCode(String code) => code.trim().toLowerCase();

bool isSupportedLocale(LocaleLike locale) =>
    supportedLanguageCodes.contains(normalizeLanguageCode(locale.languageCode));

LocaleLike resolveLocale(List<LocaleLike> deviceLocales, {List<String> supported = supportedLanguageCodes}) {
  for (final locale in deviceLocales) {
    final code = normalizeLanguageCode(locale.languageCode);
    if (supported.contains(code)) return LocaleLike(code, locale.countryCode);
  }
  return const LocaleLike('en'); // fallback
}
```

Система даёт список предпочтений устройства; берёшь первый поддерживаемый, иначе default.

## 2. Lookup и fallback строк

```dart
String lookupMessage(MessageCatalog catalog, String languageCode, String key) {
  return catalog[languageCode]?[key] ??
      catalog['en']?[key] ??
      key;
}
```

Нет перевода → английский → сам ключ (чтобы UI не падал).

## 3. Плейсхолдеры

```dart
String interpolate(String template, Map<String, String> params) {
  var result = template;
  for (final e in params.entries) {
    result = result.replaceAll('{${e.key}}', e.value);
  }
  return result;
}

// 'Welcome, {name}!' + {name: 'Ann'} -> 'Welcome, Ann!'
```

Не склеивай предложения через `+` в коде — ломаешь порядок слов в других языках. Одна строка-шаблон на язык.

## 4. Plural (CLDR)

Английский: `one` / `other`. Русский: `one` / `few` / `many` (упрощённо):

```dart
String russianPluralCategory(int n) {
  final mod10 = n % 10;
  final mod100 = n % 100;
  if (mod10 == 1 && mod100 != 11) return 'one';
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return 'few';
  return 'many';
}

// ключи: items_one, items_few, items_many, items_other
// подставь {count}
```

В gen-l10n это `{count, plural, ...}` в ARB.

## 5. BCP47

```dart
String toBcp47(LocaleLike l) =>
    l.countryCode == null ? l.languageCode : '${l.languageCode}-${l.countryCode}';

LocaleLike parseBcp47(String tag) {
  if (tag.isEmpty) throw ArgumentError('empty tag');
  final parts = tag.split(RegExp('[-_]'));
  return LocaleLike(parts[0].toLowerCase(),
      parts.length > 1 ? parts[1].toUpperCase() : null);
}
```

## 6. ARB vs ручной словарь, RTL, форматы

- **ARB + gen-l10n** — типобезопасные геттеры, plural, tooling.
- **Ручной Map** — ок для крошечных приложений, плохо масштабируется.
- RTL (`ar`, `he`): `Directionality` / Material сам зеркалит; проверяй кастомные Row/паддинги.
- Даты/числа — `intl` (`DateFormat`, `NumberFormat`), не `toString()`.

## 7. Как это выглядит в Flutter

`flutter gen-l10n` читает ARB и генерирует `AppLocalizations` с методами. Плейсхолдер `{name}` становится аргументом функции, опечатка в ключе ловится компилятором. Ручной `MessageCatalog` в модуле повторяет алгоритм lookup, чтобы его было видно без кодогена.

`MaterialApp` получает `locale`, `supportedLocales`, `localizationsDelegates`. Делегаты нужны и для своих строк, и для стандартных виджетов: кнопка календаря и семантика «назад» тоже переводятся. Без `GlobalMaterialLocalizations.delegate` часть Material останется на английском или упадёт на отсутствии делегата.

`Locale('ru', 'RU')` — язык и регион. Регион влияет на дату и валюту (`intl`), даже если строки приложения только по языку. Resolution в модуле смотрит язык. В проде можно предпочесть точное совпадение `ru_RU` перед голым `ru`.

Смена языка без перезапуска — `locale:` у `MaterialApp` из состояния настроек. Строки, которые уже лежат в `State` как готовый `String` («сохранено в 12:00» собрали сами), сами не переедут. Храни данные, а текст собирай в `build`.

## 8. Plural, пол и направление

Русский plural зависит от `mod10` и `mod100`: 1, 21, 31 — `one`; 2–4, 22–24 — `few`; 5–20, 11–14, 25–30 — `many`. 11 — не `one`, хотя оканчивается на 1. Английский `1 item` / `N items` этой таблицей не описывается. Категории CLDR (`zero`, `one`, `two`, `few`, `many`, `other`) выбирает язык, не «если n == 1».

Не вставляй число в середину русской фразы конкатенацией кусков из кода: в другом языке число стоит в другом месте. Шаблон целиком лежит в каталоге: `'{count} items'`.

Пол в переводах («отправил / отправила») — отдельные ключи или ICU `select`, не `if (female)` вокруг русских окончаний в Dart.

RTL: `Directionality` меняет старт оси. `EdgeInsets.only(left: 16)` не зеркалится. `EdgeInsetsDirectional.only(start: 16)` зеркалится. Иконка «назад» — `Icons.arrow_back`, которую Material зеркалит в RTL, либо явный `matchTextDirection`. Проверка — локаль `ar` в тесте, не только чтение теории.

Даты: `DateFormat.yMMMd(locale)` даст порядок дня и месяца. `DateTime.toString()` — отладочный формат, не UI.

## 9. Типичные ошибки

- Ключ показан пользователю, потому что забыли fallback и опечатались в ARB. Fallback на ключ полезен в debug и плох в релизе, если никто не смотрит логи. В модуле ключ как последний шаг — чтобы не бросать.
- Склеить `'Hello, ' + name`. Переводчик не может переставить имя.
- Один plural на все языки функцией для русского.
- Захардкодить `'₽'` и формат тысяч. `NumberFormat.simpleCurrency` знает разделители.
- Забыть, что картинки с текстом тоже локализуются. Их lookup отдельный от строк.
- Сменить `localeCode` в prefs и не перестроить `MaterialApp`.

## 10. Зачем это знать

- Resolution: device list → supported → fallback.
- Plural правила языка ≠ «добавь s».
- Плейсхолдеры внутри строки, не конкатенация.
- Тесты: каталог + несколько languageCode без UI.

Дальше по маршруту: `localization_task.dart` → `interview_questions.md`.
