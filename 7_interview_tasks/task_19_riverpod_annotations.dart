/// ЗАДАЧА 19 — Riverpod с аннотациями (@riverpod)
/// Уровень: Mid / Senior Flutter
/// Тема: riverpod_annotation, code generation, AsyncNotifier, Notifier
///
/// Реализуйте систему управления продуктами с Riverpod + аннотациями:
///
/// 1. [@riverpod] [ProductRepository] — репозиторий (чистый провайдер)
/// 2. [@riverpod] [productsStream] — Stream всех продуктов (StreamProvider)
/// 3. [@Riverpod] [ProductsNotifier] — Notifier для CRUD операций
/// 4. [@riverpod] [filteredProducts] — отфильтрованный список (зависит от других)
/// 5. [@riverpod] [productDetail] — деталь по id (family провайдер с параметром)
///
/// Вопросы на собесе:
///   - Чем @riverpod отличается от @Riverpod?
///     → @riverpod генерирует функциональный провайдер (autoDispose по умолчанию)
///     → @Riverpod(keepAlive: true) — класс-провайдер, живёт всё время
///   - Что генерирует build_runner из @riverpod?
///     → Файл *.g.dart с провайдерами типа xxxProvider
///   - Как работает ref.watch vs ref.read vs ref.listen?
///   - Когда использовать Notifier vs AsyncNotifier vs StreamNotifier?
///   - Как передать параметр в провайдер (family)?

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ВАЖНО: В реальном проекте нужно запустить:
//   dart run build_runner build
// Это создаст файл task_19_riverpod_annotations.g.dart
//
// В данном файле мы ВРУЧНУЮ пишем эквивалент того, что генерирует build_runner,
// чтобы код работал без запуска кодогенерации.

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
  String toString() => 'Product($id: $name, ${price}₽, $category)';
}

// ─── Репозиторий ─────────────────────────────────────────────────────────────

class ProductRepository {
  final _products = <int, Product>{
    1: const Product(id: 1, name: 'iPhone 15', price: 89000, category: 'Телефоны', inStock: true),
    2: const Product(id: 2, name: 'MacBook Pro', price: 180000, category: 'Ноутбуки', inStock: true),
    3: const Product(id: 3, name: 'AirPods', price: 15000, category: 'Аксессуары', inStock: false),
    4: const Product(id: 4, name: 'iPad', price: 65000, category: 'Планшеты', inStock: true),
  };

  Future<List<Product>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _products.values.toList();
  }

  Future<Product?> fetchById(int id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _products[id];
  }

  Future<Product> save(Product product) async {
    _products[product.id] = product;
    return product;
  }

  Future<bool> delete(int id) async {
    return _products.remove(id) != null;
  }
}

// ─── Аннотации (@riverpod) ───────────────────────────────────────────────────
// В реальном проекте эти классы генерируются build_runner из аннотаций.
// Ниже — ручной эквивалент для учебных целей.

// @riverpod
// ProductRepository productRepository(ProductRepositoryRef ref) {
//   return ProductRepository();
// }
//
// ГЕНЕРИРУЕТ:
// final productRepositoryProvider = Provider.autoDispose<ProductRepository>(...);

// @Riverpod(keepAlive: true)
// class ProductsNotifier extends _$ProductsNotifier {
//   @override
//   Future<List<Product>> build() async { ... }
//   Future<void> add(Product p) async { ... }
//   Future<void> remove(int id) async { ... }
// }
//
// ГЕНЕРИРУЕТ:
// final productsNotifierProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(...);

// @riverpod
// Future<Product?> productDetail(ProductDetailRef ref, int id) async { ... }
//
// ГЕНЕРИРУЕТ:
// final productDetailProvider = FutureProvider.autoDispose.family<Product?, int>(...);

// ─── Провайдеры (вручную, без кодогенерации) ─────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final repo = ref.read(productRepositoryProvider);
    return repo.fetchAll();
  }

  Future<void> add(Product product) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.save(product);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(int id) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.delete(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> toggleStock(int id) async {
    final repo = ref.read(productRepositoryProvider);
    final product = await repo.fetchById(id);
    if (product == null) return;
    await repo.save(product.copyWith(inStock: !product.inStock));
    ref.invalidateSelf();
    await future;
  }
}

final productsNotifierProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

// Family провайдер — деталь продукта по id
final productDetailProvider = FutureProvider.family<Product?, int>(
  (ref, id) async {
    final repo = ref.read(productRepositoryProvider);
    return repo.fetchById(id);
  },
);

// Фильтрация: только товары в наличии
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

// ─── UI ──────────────────────────────────────────────────────────────────────

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredProductsProvider);
    final filter = ref.watch(stockFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Продукты (Riverpod + аннотации)')),
      body: Column(
        children: [
          // Фильтр
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<StockFilter>(
              segments: const [
                ButtonSegment(value: StockFilter.all, label: Text('Все')),
                ButtonSegment(value: StockFilter.inStock, label: Text('В наличии')),
                ButtonSegment(value: StockFilter.outOfStock, label: Text('Нет в наличии')),
              ],
              selected: {filter},
              onSelectionChanged: (s) =>
                  ref.read(stockFilterProvider.notifier).setFilter(s.first),
            ),
          ),
          // Список
          Expanded(
            child: filtered.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
              data: (products) => ListView.builder(
                itemCount: products.length,
                itemBuilder: (ctx, i) {
                  final p = products[i];
                  return ListTile(
                    key: ValueKey(p.id),
                    title: Text(p.name),
                    subtitle: Text('${p.price.toStringAsFixed(0)} ₽ · ${p.category}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          p.inStock ? Icons.check_circle : Icons.cancel,
                          color: p.inStock ? Colors.green : Colors.red,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => ref
                              .read(productsNotifierProvider.notifier)
                              .remove(p.id),
                        ),
                      ],
                    ),
                    onTap: () => ref
                        .read(productsNotifierProvider.notifier)
                        .toggleStock(p.id),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = DateTime.now().millisecondsSinceEpoch % 10000;
          ref.read(productsNotifierProvider.notifier).add(Product(
                id: id,
                name: 'Новый товар $id',
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

// ─── Точка входа ─────────────────────────────────────────────────────────────

void main() {
  runApp(const ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductListPage(),
    ),
  ));
}

/// ═══════════════════════════════════════════════════════════════════
/// КАК ВЫГЛЯДИТ КОД С НАСТОЯЩИМИ АННОТАЦИЯМИ
/// ═══════════════════════════════════════════════════════════════════
///
/// ```dart
/// part 'task_19_riverpod_annotations.g.dart';
///
/// /// Простой провайдер — autoDispose по умолчанию
/// @riverpod
/// ProductRepository productRepository(ProductRepositoryRef ref) {
///   return ProductRepository();
/// }
///
/// /// AsyncNotifier с keepAlive — не удаляется из памяти
/// @Riverpod(keepAlive: true)
/// class ProductsNotifier extends _$ProductsNotifier {
///   @override
///   Future<List<Product>> build() async {
///     final repo = ref.read(productRepositoryProvider);
///     return repo.fetchAll();
///   }
///
///   Future<void> add(Product product) async {
///     final repo = ref.read(productRepositoryProvider);
///     await repo.save(product);
///     ref.invalidateSelf();
///     await future;
///   }
/// }
///
/// /// Family провайдер с параметром — autoDispose + family
/// @riverpod
/// Future<Product?> productDetail(ProductDetailRef ref, int id) async {
///   final repo = ref.read(productRepositoryProvider);
///   return repo.fetchById(id);
/// }
///
/// /// Провайдер-фильтр, зависящий от других провайдеров
/// @riverpod
/// List<Product> filteredProducts(FilteredProductsRef ref) {
///   final products = ref.watch(productsNotifierProvider).valueOrNull ?? [];
///   final filter = ref.watch(stockFilterProvider);
///   return switch (filter) {
///     StockFilter.all       => products,
///     StockFilter.inStock   => products.where((p) => p.inStock).toList(),
///     StockFilter.outOfStock => products.where((p) => !p.inStock).toList(),
///   };
/// }
/// ```
///
/// После запуска `dart run build_runner build` генерируется .g.dart файл:
/// ```dart
/// // GENERATED CODE - DO NOT MODIFY BY HAND
/// final productRepositoryProvider = AutoDisposeProvider<ProductRepository>(...);
/// final productsNotifierProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(...);
/// final productDetailProvider = AutoDisposeFutureProviderFamily<Product?, int>(...);
/// final filteredProductsProvider = AutoDisposeProvider<List<Product>>(...);
/// ```
