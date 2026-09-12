/// ЗАДАЧА 15 — Навигация: Navigator 2.0 / GoRouter
/// Уровень: Mid Flutter
/// Тема: Навигация, роутинг, передача аргументов, deep linking
///
/// Реализуйте трёхэкранное приложение:
///   /           → Главная (список категорий)
///   /category/:id → Список товаров в категории
///   /product/:id  → Детальная страница товара
///
/// Требования:
///   - Использовать GoRouter (или Navigator с именованными маршрутами)
///   - Передача параметров через path params
///   - Кнопка "Назад" с корректным стеком
///   - Обработка несуществующего маршрута (404 страница)
///
/// Вопрос: Navigator.push vs Navigator.pushNamed vs GoRouter — когда что?

import 'package:flutter/material.dart';

// ─── Модели данных ────────────────────────────────────────────────────────────

class Category {
  final int id;
  final String name;
  final IconData icon;
  const Category({required this.id, required this.name, required this.icon});
}

class Product {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final String description;
  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.description,
  });
}

// ─── Фиктивные данные ─────────────────────────────────────────────────────────

const categories = [
  Category(id: 1, name: 'Электроника', icon: Icons.devices),
  Category(id: 2, name: 'Одежда', icon: Icons.checkroom),
  Category(id: 3, name: 'Книги', icon: Icons.menu_book),
];

const products = [
  Product(id: 1, categoryId: 1, name: 'Смартфон', price: 45000, description: 'Флагманский смартфон'),
  Product(id: 2, categoryId: 1, name: 'Ноутбук', price: 80000, description: 'Мощный ноутбук'),
  Product(id: 3, categoryId: 2, name: 'Футболка', price: 1500, description: 'Хлопковая футболка'),
  Product(id: 4, categoryId: 3, name: 'Clean Code', price: 2000, description: 'Р. Мартин'),
  Product(id: 5, categoryId: 3, name: 'Flutter in Action', price: 3000, description: 'E. Windmill'),
];

// ─── Реализация навигации (именованные маршруты) ──────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Каталог')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          return ListTile(
            leading: Icon(cat.icon),
            title: Text(cat.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(
              ctx,
              '/category',
              arguments: cat.id,
            ),
          );
        },
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryId = ModalRoute.of(context)!.settings.arguments as int;
    final category = categories.firstWhere((c) => c.id == categoryId);
    final catProducts = products.where((p) => p.categoryId == categoryId).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: catProducts.isEmpty
          ? const Center(child: Text('Товаров нет'))
          : ListView.builder(
              itemCount: catProducts.length,
              itemBuilder: (ctx, i) {
                final p = catProducts[i];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text('${p.price.toStringAsFixed(0)} ₽'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(ctx, '/product', arguments: p.id),
                );
              },
            ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as int;
    final product = products.firstWhere((p) => p.id == productId);

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('${product.price.toStringAsFixed(0)} ₽',
                style: const TextStyle(fontSize: 24, color: Colors.green)),
            const SizedBox(height: 16),
            Text(product.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Добавлено в корзину!')),
                ),
                child: const Text('В корзину'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404', style: TextStyle(fontSize: 72)),
            const Text('Страница не найдена'),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Точка входа ─────────────────────────────────────────────────────────────

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (_) => const HomeScreen(),
      '/category': (_) => const CategoryScreen(),
      '/product': (_) => const ProductScreen(),
    },
    onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const NotFoundScreen()),
  ));
}
