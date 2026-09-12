// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Модель ──────────────────────────────────────────────────────────────────

class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.inStock,
  });

  Product copyWith({
    String? name,
    double? price,
    String? category,
    bool? inStock,
  }) =>
      Product(
        id: id,
        name: name ?? this.name,
        price: price ?? this.price,
        category: category ?? this.category,
        inStock: inStock ?? this.inStock,
      );

  @override
  bool operator ==(Object other) =>
      other is Product && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}

// ─── Репозиторий ─────────────────────────────────────────────────────────────

class ProductRepository {
  final Map<int, Product> _products;

  ProductRepository([Map<int, Product>? initial])
      : _products = initial ??
            {
              1: const Product(
                  id: 1, name: 'iPhone', price: 89000, category: 'Телефоны', inStock: true),
              2: const Product(
                  id: 2, name: 'MacBook', price: 180000, category: 'Ноутбуки', inStock: true),
              3: const Product(
                  id: 3, name: 'AirPods', price: 15000, category: 'Аксессуары', inStock: false),
            };

  Future<List<Product>> fetchAll() async => _products.values.toList();

  Future<Product?> fetchById(int id) async => _products[id];

  Future<Product> save(Product product) async {
    _products[product.id] = product;
    return product;
  }

  Future<bool> delete(int id) async => _products.remove(id) != null;
}

// ─── Провайдеры ───────────────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return ref.read(productRepositoryProvider).fetchAll();
  }

  Future<void> add(Product product) async {
    throw UnimplementedError();
  }

  Future<void> remove(int id) async {
    throw UnimplementedError();
  }

  Future<void> toggleStock(int id) async {
    throw UnimplementedError();
  }
}

final productsNotifierProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

final productDetailProvider = FutureProvider.family<Product?, int>(
  (ref, id) => ref.read(productRepositoryProvider).fetchById(id),
);

enum StockFilter { all, inStock, outOfStock }

final stockFilterProvider = NotifierProvider<StockFilterNotifier, StockFilter>(StockFilterNotifier.new);

class StockFilterNotifier extends Notifier<StockFilter> {
  @override
  StockFilter build() => StockFilter.all;

  void setFilter(StockFilter newFilter) => state = newFilter;
}

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsNotifierProvider);
  final filter = ref.watch(stockFilterProvider);
  return productsAsync.whenData((products) => switch (filter) {
        StockFilter.all => products,
        StockFilter.inStock => products.where((p) => p.inStock).toList(),
        StockFilter.outOfStock => products.where((p) => !p.inStock).toList(),
      });
});

// ─── Хелпер: контейнер с тестовым репозиторием ───────────────────────────────

ProviderContainer makeContainer([ProductRepository? repo]) {
  final container = ProviderContainer(
    overrides: [
      if (repo != null) productRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  // ── 1. ProductRepository ────────────────────────────────────────────────────
  group('ProductRepository', () {
    late ProductRepository repo;
    setUp(() => repo = ProductRepository());

    test('fetchAll возвращает все продукты', () async {
      final products = await repo.fetchAll();
      expect(products, hasLength(3));
    });

    test('fetchById возвращает нужный продукт', () async {
      final p = await repo.fetchById(1);
      expect(p?.name, 'iPhone');
    });

    test('fetchById возвращает null для несуществующего id', () async {
      final p = await repo.fetchById(999);
      expect(p, isNull);
    });

    test('save добавляет новый продукт', () async {
      const newProduct = Product(
          id: 99, name: 'Watch', price: 30000, category: 'Аксессуары', inStock: true);
      await repo.save(newProduct);
      final all = await repo.fetchAll();
      expect(all.any((p) => p.id == 99), isTrue);
    });

    test('save обновляет существующий продукт', () async {
      final updated = (await repo.fetchById(1))!.copyWith(price: 95000);
      await repo.save(updated);
      final p = await repo.fetchById(1);
      expect(p?.price, 95000);
    });

    test('delete удаляет продукт и возвращает true', () async {
      final result = await repo.delete(1);
      expect(result, isTrue);
      expect(await repo.fetchById(1), isNull);
    });

    test('delete несуществующего id возвращает false', () async {
      expect(await repo.delete(999), isFalse);
    });
  });

  // ── 2. productRepositoryProvider ────────────────────────────────────────────
  group('productRepositoryProvider', () {
    test('возвращает экземпляр ProductRepository', () {
      final container = makeContainer();
      expect(container.read(productRepositoryProvider), isA<ProductRepository>());
    });

    test('override подменяет репозиторий', () {
      final custom = ProductRepository({});
      final container = makeContainer(custom);
      expect(container.read(productRepositoryProvider), same(custom));
    });
  });

  // ── 3. ProductsNotifier ──────────────────────────────────────────────────────
  group('ProductsNotifier', () {
    test('build загружает продукты из репозитория', () async {
      final container = makeContainer();
      final state = await container.read(productsNotifierProvider.future);
      expect(state, hasLength(3));
    });

    test('add добавляет продукт в список', () async {
      final container = makeContainer();
      await container.read(productsNotifierProvider.future);

      await container.read(productsNotifierProvider.notifier).add(
            const Product(id: 10, name: 'Новый', price: 500, category: 'Прочее', inStock: true),
          );

      final updated = await container.read(productsNotifierProvider.future);
      expect(updated.any((p) => p.name == 'Новый'), isTrue);
      expect(updated, hasLength(4));
    });

    test('remove удаляет продукт по id', () async {
      final container = makeContainer();
      await container.read(productsNotifierProvider.future);

      await container.read(productsNotifierProvider.notifier).remove(1);

      final updated = await container.read(productsNotifierProvider.future);
      expect(updated.any((p) => p.id == 1), isFalse);
      expect(updated, hasLength(2));
    });

    test('toggleStock инвертирует inStock', () async {
      final container = makeContainer();
      await container.read(productsNotifierProvider.future);

      // id:1 — inStock: true → false
      await container.read(productsNotifierProvider.notifier).toggleStock(1);
      var products = await container.read(productsNotifierProvider.future);
      expect(products.firstWhere((p) => p.id == 1).inStock, isFalse);

      // снова → true
      await container.read(productsNotifierProvider.notifier).toggleStock(1);
      products = await container.read(productsNotifierProvider.future);
      expect(products.firstWhere((p) => p.id == 1).inStock, isTrue);
    });

    test('toggleStock для несуществующего id — нет изменений', () async {
      final container = makeContainer();
      final before = await container.read(productsNotifierProvider.future);

      await container.read(productsNotifierProvider.notifier).toggleStock(999);

      final after = await container.read(productsNotifierProvider.future);
      expect(after.length, before.length);
    });

    test('состояние loading в начале загрузки', () {
      final container = makeContainer();
      final state = container.read(productsNotifierProvider);
      expect(state, isA<AsyncLoading>());
    });
  });

  // ── 4. productDetailProvider (family) ───────────────────────────────────────
  group('productDetailProvider (family)', () {
    test('возвращает продукт по существующему id', () async {
      final container = makeContainer();
      final product = await container.read(productDetailProvider(1).future);
      expect(product?.name, 'iPhone');
    });

    test('возвращает null для несуществующего id', () async {
      final container = makeContainer();
      final product = await container.read(productDetailProvider(999).future);
      expect(product, isNull);
    });

    test('разные id — независимые провайдеры', () async {
      final container = makeContainer();
      final p1 = await container.read(productDetailProvider(1).future);
      final p2 = await container.read(productDetailProvider(2).future);
      expect(p1?.id, isNot(equals(p2?.id)));
    });
  });

  // ── 5. stockFilterProvider ───────────────────────────────────────────────────
  group('stockFilterProvider', () {
    test('начальное значение — StockFilter.all', () {
      final container = makeContainer();
      expect(container.read(stockFilterProvider), StockFilter.all);
    });

    test('смена фильтра через notifier', () {
      final container = makeContainer();
      container.read(stockFilterProvider.notifier).setFilter(StockFilter.inStock);
      expect(container.read(stockFilterProvider), StockFilter.inStock);
    });
  });

  // ── 6. filteredProductsProvider ─────────────────────────────────────────────
  group('filteredProductsProvider', () {
    test('StockFilter.all — все продукты', () async {
      final container = makeContainer();
      await container.read(productsNotifierProvider.future);

      final filtered = container.read(filteredProductsProvider);
      expect(filtered.value, hasLength(3));
    });

    test('StockFilter.inStock — только в наличии', () async {
      final container = makeContainer();
      await container.read(productsNotifierProvider.future);

      container.read(stockFilterProvider.notifier).setFilter(StockFilter.inStock);

      final filtered = container.read(filteredProductsProvider);
      final products = filtered.value ?? [];
      expect(products.every((p) => p.inStock), isTrue);
      expect(products, hasLength(2));
    });

    test('StockFilter.outOfStock — только не в наличии', () async {
      final container = makeContainer();
      await container.read(productsNotifierProvider.future);

      container.read(stockFilterProvider.notifier).setFilter(StockFilter.outOfStock);

      final filtered = container.read(filteredProductsProvider);
      final products = filtered.value ?? [];
      expect(products.every((p) => !p.inStock), isTrue);
      expect(products, hasLength(1));
      expect(products.first.name, 'AirPods');
    });

    test('фильтр реагирует на изменение списка', () async {
      final container = makeContainer();
      await container.read(productsNotifierProvider.future);
      container.read(stockFilterProvider.notifier).setFilter(StockFilter.inStock);

      // добавляем товар в наличии
      await container.read(productsNotifierProvider.notifier).add(
            const Product(id: 50, name: 'Watch', price: 20000, category: 'Аксессуары', inStock: true),
          );

      final filtered = container.read(filteredProductsProvider);
      expect(filtered.value, hasLength(3)); // было 2, стало 3
    });
  });

  // ── 7. Widget tests ──────────────────────────────────────────────────────────
  group('Widget — ProductListPage', () {
    Widget buildApp([List<dynamic>? overrides]) {
      return ProviderScope(
        overrides: (overrides ?? []).cast(),
        child: const MaterialApp(
          home: _ProductListPage(),
        ),
      );
    }

    testWidgets('отображает список продуктов', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(); // start async
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('iPhone'), findsOneWidget);
      expect(find.text('MacBook'), findsOneWidget);
      expect(find.text('AirPods'), findsOneWidget);
    });

    testWidgets('показывает CircularProgressIndicator при загрузке', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('иконка delete присутствует для каждого продукта', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byIcon(Icons.delete), findsNWidgets(3));
    });

    testWidgets('tap на delete убирает продукт из списка', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byIcon(Icons.delete), findsNWidgets(2));
    });

    testWidgets('FAB добавляет новый продукт', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byIcon(Icons.delete), findsNWidgets(4));
    });
  });
}

// ─── Минимальный виджет для тестов ───────────────────────────────────────────

class _ProductListPage extends ConsumerWidget {
  const _ProductListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Продукты')),
      body: filtered.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (ctx, i) {
            final p = products[i];
            return ListTile(
              key: ValueKey(p.id),
              title: Text(p.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () =>
                    ref.read(productsNotifierProvider.notifier).remove(p.id),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = 9000 + (DateTime.now().millisecond);
          ref.read(productsNotifierProvider.notifier).add(Product(
                id: id,
                name: 'Новый $id',
                price: 1000,
                category: 'Прочее',
                inStock: true,
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
