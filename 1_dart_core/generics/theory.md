# Шпаргалка: Generics и Extensions

Generics параметризуют типы (`Box<T>`, `List<R>`), extensions добавляют методы к существующим типам без наследования. Перед задачами прочитай этот файл, затем решай `generics_task.dart`.

## 1. Зачем generics

Один алгоритм — много типов, без потери типобезопасности:

```dart
class Box<T> {
  const Box(this.value);
  final T value;
}

T id<T>(T value) => value;

T unpackOr<T>(Box<T>? box, T fallback) => box?.value ?? fallback;
```

Без `T` пришлось бы писать `Object` и кастить — ошибки в runtime.

## 2. Ограничения: `extends`

```dart
T maxOf<T extends num>(T a, T b) => a >= b ? a : b;
// maxOf(1, 2) → int; maxOf(1.5, 2.0) → double
```

`T extends num` — у `T` доступны операции/методы `num`. Без ограничения — только то, что есть у `Object?`.

## 3. Несколько параметров типа

```dart
List<R> mapIndexed<T, R>(
  List<T> items,
  R Function(int index, T item) map,
) {
  return [for (var i = 0; i < items.length; i++) map(i, items[i])];
}

List<(A, B)> zip<A, B>(List<A> a, List<B> b) {
  final n = a.length < b.length ? a.length : b.length;
  return [for (var i = 0; i < n; i++) (a[i], b[i])];
}
```

## 4. Generic-интерфейс и реализация

```dart
abstract interface class Repository<T> {
  T? getById(String id);
}

class MemoryRepository<T> implements Repository<T> {
  MemoryRepository(this._idOf);
  final String Function(T) _idOf;
  final Map<String, T> _items = {};

  void upsert(T item) => _items[_idOf(item)] = item;

  @override
  T? getById(String id) => _items[id];
}
```

Паттерн «repository» на собеседованиях и в data-слое приложений.

## 5. `List<T?>` vs `List<T>?`

| Тип | Null где? |
|---|---|
| `List<T>?` | Может отсутствовать весь список |
| `List<T?>` | Список есть, элементы могут быть null |
| `List<T?>?` | И то, и другое |

## 6. Covariance (кратко)

В Dart generics **ковариантны**: `List<String>` — подтип `List<Object>`. Это удобно для чтения, но опасно для записи (`list.add` другого типа → runtime error). Предпочитай точные типы и `List<T>` в API.

## 7. Extensions

```dart
extension StringBlankX on String {
  bool get isBlank => trim().isEmpty;
}

extension ListSecondX<T> on List<T> {
  T? get secondOrNull => length >= 2 ? this[1] : null;
}

extension NumIterableSumX on Iterable<num> {
  num get sum => fold<num>(0, (a, b) => a + b);
}
```

- Extension **не** видит `private` члены другого файла/библиотеки.
- Это синтаксический сахар: статический вызов, не настоящее наследование.
- Имя extension нужно для конфликтов и явного импорта (`hide` / `show`).

## 8. `typedef` (зачем знать)

```dart
typedef Mapper<T, R> = R Function(T);
```

Сокращает длинные сигнатуры колбэков и generic-алиасы.

## 9. Зачем это знать

- Писать переиспользуемые хелперы (`firstWhereOrNull`, `zip`, `mapIndexed`).
- Типизировать репозитории и коллекции без кастов.
- Добавлять удобные API через extensions (как в `collection` / своих utils).
- Не путать nullable-список и список nullable-элементов.

Дальше: `generics_task.dart` и `interview_questions.md`.
