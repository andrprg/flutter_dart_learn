# Шпаргалка: List в Dart

`List<T>` — упорядоченная коллекция с доступом по индексу. Большинство задач модуля — `map` / `where` / `fold` / `sublist` без мутации исходника. Перед задачами прочитай этот файл, затем смотри `list_task.dart`.

## 1. List vs Iterable

| | `Iterable` | `List` |
|---|---|---|
| Индекс `[]` | Нет | Да, O(1) |
| Длина | Может быть ленивой | `length` известна |
| `map`/`where` | Ленивые | Тоже через Iterable API |

`list.map(...)` возвращает **`Iterable`**, не `List`. Чтобы снова список: `.toList()`.

## 2. Growable vs fixed-length

```dart
final a = <int>[1, 2];     // growable
a.add(3);

final b = List<int>.filled(3, 0); // fixed-length
// b.add(1); // ошибка
b[0] = 1; // элементы менять можно
```

`const []` / `List.unmodifiable` — ещё и без изменения элементов.

## 3. Базовые операции

```dart
list.isEmpty;
list.length;
list.indexOf(value);          // -1, если нет
list.contains(x);             // O(n)
list.sublist(start, end);     // новый список, end не включительно
list.reversed.toList();       // не мутирует исходный
[...list1, ...list2];         // concat
```

Безопасный индекс: проверка `index >= 0 && index < list.length`, иначе `null` / early return — у List нет `elementAtOrNull` в core (есть в пакетах).

## 4. Трансформации

```dart
list.map((e) => e * 2).toList();
list.where((e) => e > n).toList();
list.every((e) => e.isEven);     // all
list.any((e) => e > 10);
list.expand((e) => e).toList();  // flatten List<List<T>>
list.fold<int>(0, (a, e) => a + e);
list.reduce((a, b) => a > b ? a : b); // пустой → StateError
```

| Метод | Идея |
|---|---|
| `fold` | Аккумулятор + начальное значение (пустой OK) |
| `reduce` | Аккумулятор = первый элемент (пустой — ошибка) |
| `expand` | Каждый элемент → несколько (flatten) |
| `where` | Фильтр |
| `map` | Преобразование 1→1 |

## 5. Частые паттерны задач

```dart
// уникальные с порядком (осторожно: Set может подойти)
list.toSet().toList();

// chunk
List<List<T>> chunk<T>(List<T> list, int size) {
  return [
    for (var i = 0; i < list.length; i += size)
      list.sublist(i, i + size > list.length ? list.length : i + size),
  ];
}

// take / drop
list.sublist(0, n.clamp(0, list.length));
list.length <= n ? <T>[] : list.sublist(n);

// вставка без мутации
[...list.sublist(0, i), value, ...list.sublist(i)];
```

## 6. Collection-if / collection-for

```dart
final items = [
  1,
  if (includeTwo) 2,
  for (final x in others) x * 2,
];
```

Литералы списков/map/set могут включать условия и циклы — удобно в UI и сборке данных.

## 7. Производительность (кратко)

- `contains` / `indexOf` / удаление из середины — **O(n)**.
- Для частых проверок «есть ли элемент» лучше `Set`.
- Удаление по условию: собрать новый список через `where`, или `removeWhere` на growable (мутация).

## 8. Зачем это знать

- Почти любой экран Flutter — списки данных и `ListView`.
- Отличать ленивый `Iterable` от материализованного `List`.
- Выбирать `fold` vs `reduce`, не ломать пустые входы.
- Писать чистые функции: новый список вместо inplace-мутации.

Дальше: `list_task.dart` и `interview_questions.md`.
