import 'package:test/test.dart';

import 'string_task.dart';

void main() {
  group('String задачи', () {
    test('normalizeSpaces убирает лишние пробелы', () {
      expect(normalizeSpaces('  hello   dart  world '), 'hello dart world');
    });

    test('isTextPalindrome игнорирует регистр и пунктуацию', () {
      expect(isTextPalindrome('А роза упала на лапу Азора'), isTrue);
      expect(isTextPalindrome('hello'), isFalse);
    });

    test('countWords считает слова', () {
      expect(countWords('Dart 3, Flutter 4ever!'), 4);
    });

    test('titleCase делает первые буквы заглавными', () {
      expect(titleCase('hello dart world'), 'Hello Dart World');
    });

    test('maskEmail скрывает имя ящика', () {
      expect(maskEmail('user@example.com'), 'u***@example.com');
    });

    test('extractIntegers достает числа из строки', () {
      expect(extractIntegers('x=-2, y=15, z=0'), [-2, 15, 0]);
    });

    test('camelToSnake преобразует camelCase', () {
      expect(camelToSnake('userProfileName'), 'user_profile_name');
    });

    test('snakeToCamel преобразует snake_case', () {
      expect(snakeToCamel('user_profile_name'), 'userProfileName');
    });

    test('isHexColor проверяет hex-цвет', () {
      expect(isHexColor('#fff'), isTrue);
      expect(isHexColor('#12abEF'), isTrue);
      expect(isHexColor('12abEF'), isFalse);
    });

    test('initials возвращает инициалы', () {
      expect(initials('Ivan Petrov'), 'IP');
      expect(initials('  anna  dart  '), 'AD');
    });

    test('ellipsize обрезает длинную строку', () {
      expect(ellipsize('Hello Flutter', 8), 'Hello...');
      expect(ellipsize('Dart', 10), 'Dart');
    });

    test('highlightQuery подсвечивает совпадения', () {
      expect(
        highlightQuery('Dart and dart', 'dart'),
        '<mark>Dart</mark> and <mark>dart</mark>',
      );
    });

    test('toSlug создает slug', () {
      expect(toSlug('Hello, Dart & Flutter!'), 'hello-dart-flutter');
    });

    test('parseQueryString парсит query string', () {
      expect(parseQueryString('a=1&b=hello'), {'a': '1', 'b': 'hello'});
    });

    test('topWords возвращает самые частые слова', () {
      expect(topWords('dart flutter dart test flutter dart', 2), [
        'dart',
        'flutter',
      ]);
    });
  });
}
