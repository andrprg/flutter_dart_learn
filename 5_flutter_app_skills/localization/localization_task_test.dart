import 'package:flutter_test/flutter_test.dart';

import 'localization_task.dart';

void main() {
  group('Localization helpers', () {
    test('normalizeLanguageCode', () {
      expect(normalizeLanguageCode(' RU '), 'ru');
    });

    test('isSupportedLocale', () {
      expect(isSupportedLocale(const LocaleLike('ru')), isTrue);
      expect(isSupportedLocale(const LocaleLike('de')), isFalse);
    });

    test('resolveLocale выбирает первый поддерживаемый', () {
      final resolved = resolveLocale(const [
        LocaleLike('de'),
        LocaleLike('ru', 'RU'),
        LocaleLike('en'),
      ]);

      expect(resolved.languageCode, 'ru');
      expect(
        resolveLocale(const [LocaleLike('de')]).languageCode,
        'en',
      );
    });

    test('lookupMessage с fallback на en и key', () {
      expect(lookupMessage(demoCatalog, 'ru', 'hello'), 'Привет');
      expect(lookupMessage(demoCatalog, 'es', 'hello'), 'Hello');
      expect(lookupMessage(demoCatalog, 'es', 'missing'), 'missing');
    });

    test('interpolate и welcomeMessage', () {
      expect(
        interpolate('Welcome, {name}!', {'name': 'Ann'}),
        'Welcome, Ann!',
      );
      expect(welcomeMessage(demoCatalog, 'ru', 'Иван'), 'Добро пожаловать, Иван!');
    });

    test('plural categories', () {
      expect(englishPluralCategory(1), 'one');
      expect(englishPluralCategory(5), 'other');

      expect(russianPluralCategory(1), 'one');
      expect(russianPluralCategory(2), 'few');
      expect(russianPluralCategory(5), 'many');
      expect(russianPluralCategory(11), 'many');
      expect(russianPluralCategory(21), 'one');
      expect(russianPluralCategory(22), 'few');
    });

    test('itemsMessage', () {
      expect(itemsMessage(demoCatalog, 'en', 1), '1 item');
      expect(itemsMessage(demoCatalog, 'en', 5), '5 items');
      expect(itemsMessage(demoCatalog, 'ru', 1), '1 товар');
      expect(itemsMessage(demoCatalog, 'ru', 3), '3 товара');
      expect(itemsMessage(demoCatalog, 'ru', 5), '5 товаров');
    });

    test('BCP47 roundtrip', () {
      expect(toBcp47(const LocaleLike('ru')), 'ru');
      expect(toBcp47(const LocaleLike('ru', 'RU')), 'ru-RU');

      final locale = parseBcp47('ru-RU');
      expect(locale.languageCode, 'ru');
      expect(locale.countryCode, 'RU');
      expect(() => parseBcp47(''), throwsArgumentError);
    });

    test('AppLocalizations', () {
      final l10n = AppLocalizations(catalog: demoCatalog, languageCode: 'ru');

      expect(l10n.t('hello'), 'Привет');
      expect(l10n.welcome('Анна'), 'Добро пожаловать, Анна!');
      expect(l10n.items(2), '2 товара');
    });
  });
}
