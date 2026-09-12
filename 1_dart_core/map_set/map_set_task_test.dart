import 'package:test/test.dart';

import 'map_set_task.dart';

void main() {
  group('Map и Set задачи', () {
    test('wordFrequency считает повторы слов', () {
      expect(
        wordFrequency(['dart', 'flutter', 'dart', 'fpdart']),
        {'dart': 2, 'flutter': 1, 'fpdart': 1},
      );
    });

    test('groupUsersByCity группирует имена по городу', () {
      expect(
        groupUsersByCity([
          {'name': 'Ann', 'city': 'Moscow'},
          {'name': 'Bob', 'city': 'Kazan'},
          {'name': 'Max', 'city': 'Moscow'},
        ]),
        {
          'Moscow': ['Ann', 'Max'],
          'Kazan': ['Bob'],
        },
      );
    });

    test('hasDuplicates находит дубликаты', () {
      expect(hasDuplicates([1, 2, 3, 2]), isTrue);
      expect(hasDuplicates([1, 2, 3]), isFalse);
    });

    test('uniqueInOrder сохраняет порядок первого появления', () {
      expect(uniqueInOrder(['a', 'b', 'a', 'c', 'b']), ['a', 'b', 'c']);
    });

    test('intersection возвращает общие элементы без дублей', () {
      expect(intersection([1, 2, 2, 3], [2, 3, 4]), {2, 3});
    });

    test('difference возвращает элементы только из первого списка', () {
      expect(difference([1, 2, 3, 4], [2, 4]), {1, 3});
    });

    test('indexUsersById строит индекс по id', () {
      const users = [
        User(id: 1, name: 'Ann', city: 'Moscow'),
        User(id: 2, name: 'Bob', city: 'Kazan'),
      ];

      final indexed = indexUsersById(users);

      expect(indexed[1]?.name, 'Ann');
      expect(indexed[2]?.city, 'Kazan');
    });

    test('mergeCounters суммирует конфликтующие значения', () {
      expect(
        mergeCounters({'a': 2, 'b': 1}, {'a': 3, 'c': 5}),
        {'a': 5, 'b': 1, 'c': 5},
      );
    });

    test('mostFrequent возвращает самый частый элемент', () {
      expect(mostFrequent(['a', 'b', 'a', 'c', 'a', 'b']), 'a');
      expect(mostFrequent(<String>[]), isNull);
    });

    test('areAnagrams сравнивает строки по частотам символов', () {
      expect(areAnagrams('listen', 'silent'), isTrue);
      expect(areAnagrams('dart', 'flutter'), isFalse);
    });

    test('invertGrouped группирует ключи по значениям', () {
      expect(
        invertGrouped({'a': 1, 'b': 2, 'c': 1}),
        {
          1: ['a', 'c'],
          2: ['b'],
        },
      );
    });

    test('omitKeys исключает запрещенные ключи', () {
      expect(omitKeys({'a': 1, 'b': 2, 'c': 3}, {'b'}), {'a': 1, 'c': 3});
    });

    test('collectTags собирает уникальные теги', () {
      const articles = [
        Article(title: 'Dart', tags: ['dart', 'lang']),
        Article(title: 'Flutter', tags: ['dart', 'ui']),
      ];

      expect(collectTags(articles), {'dart', 'lang', 'ui'});
    });

    test('firstRepeated возвращает первый повтор', () {
      expect(firstRepeated([1, 2, 3, 2, 1]), 2);
      expect(firstRepeated([1, 2, 3]), isNull);
    });

    test('groupWordsByLength группирует слова по длине', () {
      expect(
        groupWordsByLength(['go', 'dart', 'ui', 'code']),
        {
          2: ['go', 'ui'],
          4: ['dart', 'code'],
        },
      );
    });
  });
}
