// ============================================================
// 15 ЗАДАЧ ПО Map<K, V> И Set<T> В DART
// ============================================================
// Цель: научиться выбирать правильную структуру данных для частот,
// индексов, группировки, пересечений и быстрых проверок наличия.

// ЗАДАЧА 1
// Верни Map, где ключ — слово, значение — количество его повторений.
// ["dart", "flutter", "dart"] -> {"dart": 2, "flutter": 1}
Map<String, int> wordFrequency(List<String> words) {
  return words.fold<Map<String, int>>({}, (acc, next) {
    acc[next] = (acc[next] ?? 0) + 1;
    return acc;
  });
}

// ЗАДАЧА 2
// Сгруппируй пользователей по городу.
// [{"name": "Ann", "city": "Moscow"}] -> {"Moscow": ["Ann"]}
Map<String, List<String>> groupUsersByCity(List<Map<String, String>> users) {
  return users.fold<Map<String, List<String>>>({}, (acc, ob) {
    final {'name': name, 'city': city} = ob;
    acc.putIfAbsent(city, () => []).add(name);
    return acc;
  });
}

// ЗАДАЧА 3
// Верни true, если в списке есть дубликаты.
bool hasDuplicates<T>(List<T> items) {
  final set = Set.from(items);
  return set.length < items.length;
}

// ЗАДАЧА 4
// Верни уникальные элементы, сохранив порядок первого появления.
List<T> uniqueInOrder<T>(List<T> items) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Верни пересечение двух списков без дублей.
Set<T> intersection<T>(List<T> first, List<T> second) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Верни элементы, которые есть в первом списке, но отсутствуют во втором.
Set<T> difference<T>(List<T> first, List<T> second) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Построй индекс по id: список пользователей -> Map<id, user>.
Map<int, User> indexUsersById(List<User> users) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Объедини две Map. При конфликте ключей значения должны суммироваться.
Map<String, int> mergeCounters(
  Map<String, int> first,
  Map<String, int> second,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Верни самый частый элемент списка. Для пустого списка верни null.
T? mostFrequent<T>(List<T> items) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Проверь, являются ли две строки анаграммами.
bool areAnagrams(String first, String second) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Инвертируй Map: value -> список ключей, у которых было это значение.
Map<V, List<K>> invertGrouped<K, V>(Map<K, V> source) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Верни Map с ключами из source, исключив forbiddenKeys.
Map<K, V> omitKeys<K, V>(Map<K, V> source, Set<K> forbiddenKeys) {
  throw UnimplementedError();
}

// ЗАДАЧА 13
// Верни Set всех тегов из списка статей.
Set<String> collectTags(List<Article> articles) {
  throw UnimplementedError();
}

// ЗАДАЧА 14
// Найди первый повторяющийся элемент. Если повторов нет — null.
T? firstRepeated<T>(List<T> items) {
  throw UnimplementedError();
}

// ЗАДАЧА 15
// Построй histogram: ключ — длина слова, значение — список слов этой длины.
Map<int, List<String>> groupWordsByLength(List<String> words) {
  throw UnimplementedError();
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.city,
  });

  final int id;
  final String name;
  final String city;
}

class Article {
  const Article({
    required this.title,
    required this.tags,
  });

  final String title;
  final List<String> tags;
}
