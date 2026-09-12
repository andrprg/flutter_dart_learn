/// ЗАДАЧА 22 — LRU Cache на Dart
/// Уровень: Mid/Senior
/// Тема: LinkedHashMap, сложность O(1), инвалидация, дизайн API
///
/// Реализуйте класс [LruCache], который хранит не более [capacity] элементов и
/// удаляет "наименее недавно использованный" элемент при переполнении.
///
/// Требования:
/// - `get(key)`:
///   - возвращает значение или null
///   - помечает элемент как "недавно использованный"
/// - `put(key, value)`:
///   - добавляет/обновляет значение
///   - помечает как "недавно использованный"
///   - при переполнении удаляет LRU-элемент
/// - `remove(key)` удаляет и возвращает значение (или null)
/// - `keysByMru()` возвращает список ключей от MRU к LRU (для отладки)
///
/// Подсказка: в Dart можно использовать [LinkedHashMap] и на доступе делать
/// `remove` + повторный `[]=` чтобы переместить ключ в конец.

import 'dart:collection';

// ─── Ваше решение ────────────────────────────────────────────────────────────

class LruCache<K, V> {
  final int capacity;

  LruCache({required this.capacity});

  V? get(K key) {
    // TODO: реализуйте
    throw UnimplementedError();
  }

  void put(K key, V value) {
    // TODO: реализуйте
    throw UnimplementedError();
  }

  V? remove(K key) {
    // TODO: реализуйте
    throw UnimplementedError();
  }

  List<K> keysByMru() {
    // TODO: реализуйте (MRU -> LRU)
    throw UnimplementedError();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class LruCacheAnswer<K, V> {
  final int capacity;
  final LinkedHashMap<K, V> _map = LinkedHashMap<K, V>();

  LruCacheAnswer({required this.capacity}) {
    if (capacity <= 0) {
      throw ArgumentError.value(capacity, 'capacity', 'Должно быть > 0');
    }
  }

  int get length => _map.length;

  V? get(K key) {
    final value = _map.remove(key);
    if (value == null) return null;
    _map[key] = value; // перемещаем в конец (MRU)
    return value;
  }

  void put(K key, V value) {
    if (_map.containsKey(key)) {
      _map.remove(key); // обновление тоже делает ключ MRU
      _map[key] = value;
      return;
    }

    _map[key] = value;
    if (_map.length > capacity) {
      final lruKey = _map.keys.first;
      _map.remove(lruKey);
    }
  }

  V? remove(K key) => _map.remove(key);

  List<K> keysByMru() => _map.keys.toList().reversed.toList();
}

// ─── Мини-демо ────────────────────────────────────────────────────────────────

void main() {
  final cache = LruCacheAnswer<String, int>(capacity: 2);
  cache.put('a', 1);
  cache.put('b', 2);
  cache.get('a'); // a становится MRU
  cache.put('c', 3); // выкинет b
  print(cache.keysByMru()); // [c, a]
}
