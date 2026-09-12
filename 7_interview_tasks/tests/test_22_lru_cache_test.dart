import 'package:test/test.dart';

import '../task_22_lru_cache.dart' show LruCache;

void main() {
  group('Задача 22 — LRU Cache', () {
    test('get возвращает null для отсутствующего ключа', () {
      final cache = LruCache<String, int>(capacity: 2);
      expect(cache.get('missing'), isNull);
    });

    test('put/get: возвращает значение и делает ключ MRU', () {
      final cache = LruCache<String, int>(capacity: 2);
      cache.put('a', 1);
      cache.put('b', 2);

      expect(cache.get('a'), equals(1)); // a становится MRU

      // Добавляем третий элемент: должен выкинуть LRU (b)
      cache.put('c', 3);
      expect(cache.get('b'), isNull);
      expect(cache.get('a'), equals(1));
      expect(cache.get('c'), equals(3));
    });

    test('put обновляет существующий ключ и не меняет размер сверх capacity',
        () {
      final cache = LruCache<String, int>(capacity: 2);
      cache.put('a', 1);
      cache.put('b', 2);
      cache.put('a', 10); // обновление
      expect(cache.get('a'), equals(10));

      cache.put('c', 3); // теперь LRU должен быть b
      expect(cache.get('b'), isNull);
    });

    test('remove удаляет и возвращает значение', () {
      final cache = LruCache<String, int>(capacity: 2);
      cache.put('a', 1);
      expect(cache.remove('a'), equals(1));
      expect(cache.get('a'), isNull);
      expect(cache.remove('a'), isNull);
    });

    test('keysByMru: возвращает ключи MRU -> LRU', () {
      final cache = LruCache<String, int>(capacity: 3);
      cache.put('a', 1); // MRU: a
      cache.put('b', 2); // MRU: b,a
      cache.put('c', 3); // MRU: c,b,a
      cache.get('a'); // MRU: a,c,b
      cache.put('d', 4); // выкинет LRU: b -> MRU: d,a,c
      expect(cache.keysByMru(), equals(['d', 'a', 'c']));
    });
  });
}
