// ============================================================
// 12 ЗАДАЧ ПО ЛОКАЛИЗАЦИИ (i18n)
// ============================================================
// Цель: понять Locale, fallback, выбор сообщений, plural и
// форматирование без gen-l10n — на учебной абстракции.

/// Поддерживаемые языки приложения.
const supportedLanguageCodes = ['en', 'ru', 'es'];

/// Простой каталог строк: languageCode -> key -> message.
typedef MessageCatalog = Map<String, Map<String, String>>;

const demoCatalog = <String, Map<String, String>>{
  'en': {
    'hello': 'Hello',
    'items_one': '1 item',
    'items_other': '{count} items',
    'welcome': 'Welcome, {name}!',
  },
  'ru': {
    'hello': 'Привет',
    'items_one': '1 товар',
    'items_few': '{count} товара',
    'items_many': '{count} товаров',
    'welcome': 'Добро пожаловать, {name}!',
  },
};

// ЗАДАЧА 1
// Нормализуй language code: trim + lower case.
String normalizeLanguageCode(String code) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Locale поддерживается, если его languageCode есть в supportedLanguageCodes.
bool isSupportedLocale(LocaleLike locale) {
  throw UnimplementedError();
}

/// Упрощённый Locale без зависимости от Flutter (для чистых unit-тестов).
class LocaleLike {
  const LocaleLike(this.languageCode, [this.countryCode]);

  final String languageCode;
  final String? countryCode;

  @override
  String toString() =>
      countryCode == null ? languageCode : '${languageCode}_$countryCode';
}

// ЗАДАЧА 3
// Выбери лучший locale из deviceLocales среди supported.
// Если ничего не подходит — верни LocaleLike('en').
LocaleLike resolveLocale(
  List<LocaleLike> deviceLocales, {
  List<String> supported = supportedLanguageCodes,
}) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Достань строку по key для languageCode.
// Fallback: сначала нужный язык, потом 'en', иначе сам key.
String lookupMessage(
  MessageCatalog catalog,
  String languageCode,
  String key,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Подставь плейсхолдеры {name} из params.
// Пример: 'Hello, {name}!' + {name: 'Ann'} -> 'Hello, Ann!'
String interpolate(String template, Map<String, String> params) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// welcome-сообщение для языка с подстановкой имени.
String welcomeMessage(
  MessageCatalog catalog,
  String languageCode,
  String name,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Английские plural-формы: 1 -> one, иначе other.
String englishPluralCategory(int count) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Русские plural-формы (упрощённо по CLDR):
// - one: n % 10 == 1 && n % 100 != 11
// - few: n % 10 in 2..4 && n % 100 not in 12..14
// - many: иначе (включая 0)
String russianPluralCategory(int count) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Сообщение о количестве items:
// ключи: items_one / items_few / items_many / items_other
// Для en используй englishPluralCategory, для ru — russianPluralCategory.
// Подставь {count}.
String itemsMessage(
  MessageCatalog catalog,
  String languageCode,
  int count,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// BCP47-тег: 'ru' или 'ru-RU' (если country задан).
String toBcp47(LocaleLike locale) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Распарси 'ru-RU' / 'en' в LocaleLike. Пустая строка — ArgumentError.
LocaleLike parseBcp47(String tag) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// AppLocalizations: обёртка над catalog + languageCode.
class AppLocalizations {
  AppLocalizations({
    required this.catalog,
    required this.languageCode,
  });

  final MessageCatalog catalog;
  final String languageCode;

  String t(String key) {
    throw UnimplementedError();
  }

  String welcome(String name) {
    throw UnimplementedError();
  }

  String items(int count) {
    throw UnimplementedError();
  }
}
