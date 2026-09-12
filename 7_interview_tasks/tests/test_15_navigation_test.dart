import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_15_navigation.dart) ─────────────────────

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

const _categories = [
  Category(id: 1, name: 'Электроника', icon: Icons.devices),
  Category(id: 2, name: 'Одежда', icon: Icons.checkroom),
  Category(id: 3, name: 'Книги', icon: Icons.menu_book),
];

const _products = [
  Product(id: 1, categoryId: 1, name: 'Смартфон', price: 45000, description: 'Флагманский'),
  Product(id: 2, categoryId: 1, name: 'Ноутбук', price: 80000, description: 'Мощный'),
  Product(id: 3, categoryId: 2, name: 'Футболка', price: 1500, description: 'Хлопковая'),
  Product(id: 4, categoryId: 3, name: 'Clean Code', price: 2000, description: 'Р. Мартин'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

Widget _buildApp() => MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/category': (_) => const CategoryScreen(),
        '/product': (_) => const ProductScreen(),
      },
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const NotFoundScreen()),
    );

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 15 — Навигация', () {
    group('HomeScreen', () {
      testWidgets('Показывает все категории', (tester) async {
        await tester.pumpWidget(_buildApp());
        expect(find.text('Электроника'), findsOneWidget);
        expect(find.text('Одежда'), findsOneWidget);
        expect(find.text('Книги'), findsOneWidget);
      });

      testWidgets('Имеет заголовок "Каталог"', (tester) async {
        await tester.pumpWidget(_buildApp());
        expect(find.text('Каталог'), findsOneWidget);
      });

      testWidgets('Показывает иконки категорий', (tester) async {
        await tester.pumpWidget(_buildApp());
        expect(find.byIcon(Icons.devices), findsOneWidget);
        expect(find.byIcon(Icons.checkroom), findsOneWidget);
        expect(find.byIcon(Icons.menu_book), findsOneWidget);
      });
    });

    group('Навигация Home → Category', () {
      testWidgets('Тап по категории переходит на CategoryScreen', (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.tap(find.byKey(const ValueKey('cat_1')));
        await tester.pumpAndSettle();

        // Должен появиться заголовок категории
        expect(find.text('Электроника'), findsOneWidget);
      });

      testWidgets('Электроника показывает Смартфон и Ноутбук', (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.tap(find.byKey(const ValueKey('cat_1')));
        await tester.pumpAndSettle();

        expect(find.text('Смартфон'), findsOneWidget);
        expect(find.text('Ноутбук'), findsOneWidget);
      });

      testWidgets('Книги показывают только свои товары', (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.tap(find.byKey(const ValueKey('cat_3')));
        await tester.pumpAndSettle();

        expect(find.text('Clean Code'), findsOneWidget);
        expect(find.text('Смартфон'), findsNothing);
      });
    });

    group('Навигация Category → Product', () {
      Future<void> _navigateToProduct(WidgetTester tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.tap(find.byKey(const ValueKey('cat_1')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('prod_1')));
        await tester.pumpAndSettle();
      }

      testWidgets('Тап по товару открывает ProductScreen', (tester) async {
        await _navigateToProduct(tester);
        expect(find.text('Смартфон'), findsWidgets);
      });

      testWidgets('ProductScreen показывает цену', (tester) async {
        await _navigateToProduct(tester);
        expect(find.text('45000 ₽'), findsOneWidget);
      });

      testWidgets('ProductScreen показывает описание', (tester) async {
        await _navigateToProduct(tester);
        expect(find.text('Флагманский'), findsOneWidget);
      });

      testWidgets('Кнопка "В корзину" показывает SnackBar', (tester) async {
        await _navigateToProduct(tester);
        await tester.tap(find.byKey(const Key('addToCart')));
        await tester.pump();
        expect(find.text('Добавлено в корзину!'), findsOneWidget);
      });
    });

    group('Кнопка Назад', () {
      testWidgets('Назад с CategoryScreen возвращает на HomeScreen', (tester) async {
        await tester.pumpWidget(_buildApp());
        await tester.tap(find.byKey(const ValueKey('cat_2')));
        await tester.pumpAndSettle();
        expect(find.text('Одежда'), findsOneWidget);

        final NavigatorState navigator = tester.state(find.byType(Navigator));
        navigator.pop();
        await tester.pumpAndSettle();
        expect(find.text('Каталог'), findsOneWidget);
      });
    });

    group('NotFoundScreen', () {
      testWidgets('Показывает 404 при неизвестном маршруте', (tester) async {
        await tester.pumpWidget(_buildApp());
        final NavigatorState navigator = tester.state(find.byType(Navigator));
        navigator.pushNamed('/non-existent-route');
        await tester.pumpAndSettle();
        expect(find.text('404'), findsOneWidget);
      });
    });
  });
}
