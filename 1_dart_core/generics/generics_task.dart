// ============================================================
// 12 ЗАДАЧ ПО GENERICS И EXTENSIONS
// ============================================================
// Цель: generic-типы, ограничения extends, extensions — частый Dart на практике.

// ЗАДАЧА 1
// Box<T> хранит value.
class Box<T> {
  const Box(this.value);
  final T value;
}

// ЗАДАЧА 2
// Распакуй Box или верни fallback.
T unpackOr<T>(Box<T>? box, T fallback) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Generic id: верни сам элемент (identity).
T id<T>(T value) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// firstWhereOrNull для List<T>.
T? firstWhereOrNull<T>(List<T> items, bool Function(T) test) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// mapIndexed: List<R> из List<T> с индексом.
List<R> mapIndexed<T, R>(List<T> items, R Function(int index, T item) map) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Ограничение: T extends num — верни max(a,b).
T maxOf<T extends num>(T a, T b) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Repository<T> интерфейс getById.
abstract interface class Repository<T> {
  T? getById(String id);
}

// ЗАДАЧА 8
// MemoryRepository<T> с Map и extractor id.
class MemoryRepository<T> implements Repository<T> {
  MemoryRepository(this._idOf);

  final String Function(T) _idOf;
  final Map<String, T> _items = {};

  void upsert(T item) {
    throw UnimplementedError();
  }

  @override
  T? getById(String id) {
    throw UnimplementedError();
  }

  int get length => _items.length;
}

// ЗАДАЧА 9
// Extension на String: isBlank (trim empty).
extension StringBlankX on String {
  bool get isBlank {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Extension на List<T>: secondOrNull.
extension ListSecondX<T> on List<T> {
  T? get secondOrNull {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Extension на Iterable<num>: sum.
extension NumIterableSumX on Iterable<num> {
  num get sum {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 12
// zip двух списков в List<(A,B)> по минимальной длине.
List<(A, B)> zip<A, B>(List<A> a, List<B> b) {
  throw UnimplementedError();
}
