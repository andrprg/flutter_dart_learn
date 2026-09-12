/// ЗАДАЧА 7 — Дженерики: паттерн Repository
/// Уровень: Mid / Senior
/// Тема: Generics, абстрактные классы, async
///
/// Реализуйте обобщённый паттерн Repository:
///   - Абстрактный класс [Repository<T, ID>] с CRUD-методами
///   - Конкретная реализация [InMemoryRepository<T>] на основе Map
///
/// Требования:
///   - Все методы асинхронные (имитируют обращение к БД)
///   - [save] — добавляет или обновляет запись
///   - [findById] — возвращает T? (null если не найдено)
///   - [findAll] — возвращает все записи
///   - [delete] — удаляет по id, возвращает bool (успех)

// ─── Интерфейс ───────────────────────────────────────────────────────────────

abstract class Repository<T, ID> {
  Future<T> save(ID id, T entity);
  Future<T?> findById(ID id);
  Future<List<T>> findAll();
  Future<bool> delete(ID id);
}

// ─── Ваше решение ────────────────────────────────────────────────────────────

class InMemoryRepository<T> implements Repository<T, int> {
  // TODO: реализуйте класс
  @override
  Future<T> save(int id, T entity) => throw UnimplementedError();

  @override
  Future<T?> findById(int id) => throw UnimplementedError();

  @override
  Future<List<T>> findAll() => throw UnimplementedError();

  @override
  Future<bool> delete(int id) => throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class InMemoryRepositoryAnswer<T> implements Repository<T, int> {
  final _store = <int, T>{};

  @override
  Future<T> save(int id, T entity) async {
    _store[id] = entity;
    return entity;
  }

  @override
  Future<T?> findById(int id) async => _store[id];

  @override
  Future<List<T>> findAll() async => _store.values.toList();

  @override
  Future<bool> delete(int id) async => _store.remove(id) != null;
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

class Product {
  final String name;
  final double price;
  const Product(this.name, this.price);
  @override
  String toString() => 'Product($name, \$$price)';
}

void main() async {
  print('=== Задача 7: Generic Repository ===\n');

  final repo = InMemoryRepositoryAnswer<Product>();

  await repo.save(1, const Product('Ноутбук', 50000));
  await repo.save(2, const Product('Мышь', 1500));
  await repo.save(3, const Product('Клавиатура', 3000));

  print('Все товары: ${await repo.findAll()}');
  print('Товар #2: ${await repo.findById(2)}');
  print('Товар #99: ${await repo.findById(99)}');

  await repo.delete(2);
  print('После удаления #2: ${await repo.findAll()}');
  print('Удалить несуществующий #99: ${await repo.delete(99)}');
}
