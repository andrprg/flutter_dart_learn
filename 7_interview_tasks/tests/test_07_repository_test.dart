import 'package:test/test.dart';

// ─── Реализация (скопирована из task_07_generics_repository.dart) ─────────────

abstract class Repository<T, ID> {
  Future<T> save(ID id, T entity);
  Future<T?> findById(ID id);
  Future<List<T>> findAll();
  Future<bool> delete(ID id);
}

class InMemoryRepositoryAnswer<T> implements Repository<T, int> {
  @override
  Future<T> save(int id, T entity) {
    throw UnimplementedError();
  }

  @override
  Future<T?> findById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<T>> findAll() {
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(int id) {
    throw UnimplementedError();
  }
}

// ─── Модель ───────────────────────────────────────────────────────────────────

class Product {
  final String name;
  final double price;
  const Product(this.name, this.price);
  @override
  bool operator ==(Object other) =>
      other is Product && other.name == name && other.price == price;
  @override
  int get hashCode => Object.hash(name, price);
  @override
  String toString() => 'Product($name, \$$price)';
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 07 — Generic Repository', () {
    late InMemoryRepositoryAnswer<Product> repo;

    setUp(() => repo = InMemoryRepositoryAnswer<Product>());

    group('save()', () {
      test('Сохраняет и возвращает сущность', () async {
        const p = Product('Ноутбук', 50000);
        final saved = await repo.save(1, p);
        expect(saved, equals(p));
      });

      test('Обновляет существующую запись', () async {
        await repo.save(1, const Product('Старый', 100));
        await repo.save(1, const Product('Новый', 200));
        expect(await repo.findById(1), equals(const Product('Новый', 200)));
      });

      test('Независимые записи не конфликтуют', () async {
        await repo.save(1, const Product('A', 10));
        await repo.save(2, const Product('B', 20));
        expect((await repo.findAll()).length, equals(2));
      });
    });

    group('findById()', () {
      test('Находит существующую запись', () async {
        const p = Product('Мышь', 1500);
        await repo.save(7, p);
        expect(await repo.findById(7), equals(p));
      });

      test('Возвращает null для несуществующего id', () async {
        expect(await repo.findById(999), isNull);
      });

      test('Правильно находит по id среди нескольких записей', () async {
        await repo.save(1, const Product('A', 10));
        await repo.save(2, const Product('B', 20));
        await repo.save(3, const Product('C', 30));
        expect(await repo.findById(2), equals(const Product('B', 20)));
      });
    });

    group('findAll()', () {
      test('Пустой репозиторий → пустой список', () async {
        expect(await repo.findAll(), isEmpty);
      });

      test('Возвращает все сохранённые записи', () async {
        await repo.save(1, const Product('A', 10));
        await repo.save(2, const Product('B', 20));
        final all = await repo.findAll();
        expect(all.length, equals(2));
      });

      test('Содержит все добавленные продукты', () async {
        const products = [Product('A', 10), Product('B', 20), Product('C', 30)];
        for (int i = 0; i < products.length; i++) {
          await repo.save(i + 1, products[i]);
        }
        final all = await repo.findAll();
        for (final p in products) {
          expect(all, contains(p));
        }
      });
    });

    group('delete()', () {
      test('Удаляет существующую запись → возвращает true', () async {
        await repo.save(1, const Product('X', 0));
        expect(await repo.delete(1), isTrue);
      });

      test('После удаления findById возвращает null', () async {
        await repo.save(1, const Product('X', 0));
        await repo.delete(1);
        expect(await repo.findById(1), isNull);
      });

      test('Несуществующий id → возвращает false', () async {
        expect(await repo.delete(999), isFalse);
      });

      test('Удаление одной записи не затрагивает другие', () async {
        await repo.save(1, const Product('A', 10));
        await repo.save(2, const Product('B', 20));
        await repo.delete(1);
        expect(await repo.findAll(), equals([const Product('B', 20)]));
      });
    });

    group('Генерики: String репозиторий', () {
      test('Работает с типом String', () async {
        final strRepo = InMemoryRepositoryAnswer<String>();
        await strRepo.save(1, 'hello');
        await strRepo.save(2, 'world');
        expect(await strRepo.findById(1), equals('hello'));
        expect((await strRepo.findAll()).length, equals(2));
      });

      test('Работает с типом int', () async {
        final intRepo = InMemoryRepositoryAnswer<int>();
        await intRepo.save(1, 100);
        await intRepo.save(2, 200);
        expect(await intRepo.findById(2), equals(200));
      });
    });
  });
}
