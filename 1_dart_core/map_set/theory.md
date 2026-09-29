# Шпаргалка: Map и Set в Dart

`Map<K, V>` — ключ → значение. `Set<T>` — уникальные элементы. Выбор структуры: частоты, индексы, группировка, пересечения, быстрая проверка наличия. Перед задачами прочитай этот файл, затем решай `map_set_task.dart`.

## 1. Когда что

| Задача | Структура |
|---|---|
| Частоты слов, счётчики | `Map<K, int>` |
| Индекс по id | `Map<id, Entity>` |
| Группировка | `Map<K, List<V>>` |
| Уникальность / «уже видел» | `Set<T>` |
| Пересечение / разность | `Set` операции |

## 2. Map: основы

```dart
final m = <String, int>{};

m['dart'] = 1;                    // upsert
m.putIfAbsent('dart', () => 0);   // только если ключа нет
m['dart'] = (m['dart'] ?? 0) + 1; // частота

m.containsKey('dart');
m[key]; // всегда V? — ключа может не быть
```

| | `m[key] = v` | `putIfAbsent` |
|---|---|---|
| Ключ есть | Перезапишет | Не тронет, вернёт старое |
| Ключа нет | Вставит | Вызовет factory и вставит |

`containsKey(k)` ≠ `m[k] != null`: значение само может быть null (`Map<K, V?>`).

## 3. Порядок и ключи

Обычный `LinkedHashMap` (литерал `{}`) **сохраняет порядок вставки** при итерации.

Ключи сравниваются через `==` и `hashCode`. Если переопределил `==` — обязан `hashCode`. **Не мутируй** поля, участвующие в `==`/`hashCode`, после вставки в Map/Set — ведро хеша «потеряется».

## 4. Частоты и группировка

```dart
Map<String, int> wordFrequency(List<String> words) {
  return words.fold<Map<String, int>>({}, (acc, w) {
    acc[w] = (acc[w] ?? 0) + 1;
    return acc;
  });
}

// putIfAbsent + add для групп
acc.putIfAbsent(city, () => <String>[]).add(name);
```

Индекс:

```dart
Map<int, User> indexUsersById(List<User> users) => {
  for (final u in users) u.id: u,
};
```

## 5. Set: основы и операции

```dart
final a = {1, 2, 3};
final b = {2, 3, 4};

a.intersection(b); // {2, 3}
a.union(b);        // {1, 2, 3, 4}
a.difference(b);   // {1}
a.contains(2);     // O(1) в среднем
```

Дубликаты в списке:

```dart
bool hasDuplicates<T>(List<T> items) =>
    items.toSet().length != items.length;
```

Уникальные **с порядком первого появления**: иди по списку, клади в `Set` «уже видел», в результат добавляй только новые (голый `toSet().toList()` тоже сохраняет порядок вставки в Dart — но явно понимать алгоритм полезнее).

## 6. Типичные задачи модуля

```dart
// merge counters
for (final e in second.entries) {
  result[e.key] = (result[e.key] ?? 0) + e.value;
}

// invert: V → List<K>
out.putIfAbsent(value, () => <K>[]).add(key);

// omit keys
{
  for (final e in source.entries)
    if (!forbidden.contains(e.key)) e.key: e.value,
}

// first repeated
final seen = <T>{};
for (final x in items) {
  if (!seen.add(x)) return x; // add вернул false — уже был
}
```

Анаграммы: одинаковые частоты символов (`Map<String, int>` или отсортированные rune-строки).

## 7. Зачем это знать

- O(1) lookup вместо линейного `List.contains` в горячих местах.
- Частотный анализ, группировки, индексы сущностей — повседневный backend/UI код.
- Не путать отсутствие ключа и null-значение.
- Корректный `==`/`hashCode` у ключей — иначе «пропавшие» записи в Map.

Дальше: `map_set_task.dart` и `interview_questions.md`.
