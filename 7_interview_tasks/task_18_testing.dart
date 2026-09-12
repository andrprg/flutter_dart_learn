/// ЗАДАЧА 18 — Unit и Widget тестирование
/// Уровень: Mid / Senior Flutter
/// Тема: flutter_test, mockito, unit tests, widget tests
///
/// Напишите тесты для следующих компонентов:
///
/// 1. Unit тесты для [CartService]:
///    - Добавление товара
///    - Удаление товара
///    - Подсчёт общей суммы
///    - Применение скидки
///
/// 2. Unit тесты для [AuthRepository] с мокированием:
///    - Успешный логин
///    - Неверный пароль
///    - Сетевая ошибка
///
/// 3. Widget тест для [LoginForm]:
///    - Валидация пустых полей
///    - Показ SnackBar при ошибке
///    - Навигация при успехе
///
/// Вопрос: в чём разница unit / widget / integration тестов?

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Код для тестирования ─────────────────────────────────────────────────────

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) =>
      CartItem(id: id, name: name, price: price, quantity: quantity ?? this.quantity);
}

class CartService {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index == -1) {
      _items.add(item);
    } else {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    }
  }

  bool removeItem(String id) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index == -1) return false;
    _items.removeAt(index);
    return true;
  }

  double get total => _items.fold(0, (sum, i) => sum + i.price * i.quantity);

  double totalWithDiscount(double discountPercent) {
    assert(discountPercent >= 0 && discountPercent <= 100);
    return total * (1 - discountPercent / 100);
  }

  void clear() => _items.clear();
}

// ─── Unit тесты ──────────────────────────────────────────────────────────────

void runCartTests() {
  group('CartService', () {
    late CartService cart;

    setUp(() => cart = CartService());

    test('Добавление нового товара', () {
      cart.addItem(const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 1));
      expect(cart.items.length, equals(1));
      expect(cart.items.first.name, equals('Телефон'));
    });

    test('Добавление существующего товара увеличивает количество', () {
      cart.addItem(const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 1));
      cart.addItem(const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 2));
      expect(cart.items.length, equals(1));
      expect(cart.items.first.quantity, equals(3));
    });

    test('Удаление существующего товара', () {
      cart.addItem(const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 1));
      final result = cart.removeItem('1');
      expect(result, isTrue);
      expect(cart.items, isEmpty);
    });

    test('Удаление несуществующего товара возвращает false', () {
      expect(cart.removeItem('999'), isFalse);
    });

    test('Расчёт общей суммы', () {
      cart.addItem(const CartItem(id: '1', name: 'Товар А', price: 100, quantity: 2));
      cart.addItem(const CartItem(id: '2', name: 'Товар Б', price: 250, quantity: 1));
      expect(cart.total, equals(450.0));
    });

    test('Применение скидки 10%', () {
      cart.addItem(const CartItem(id: '1', name: 'Товар', price: 1000, quantity: 1));
      expect(cart.totalWithDiscount(10), closeTo(900.0, 0.01));
    });

    test('Скидка 0% = полная цена', () {
      cart.addItem(const CartItem(id: '1', name: 'Товар', price: 500, quantity: 2));
      expect(cart.totalWithDiscount(0), equals(1000.0));
    });

    test('Скидка 100% = 0', () {
      cart.addItem(const CartItem(id: '1', name: 'Товар', price: 500, quantity: 1));
      expect(cart.totalWithDiscount(100), equals(0.0));
    });
  });
}

// ─── Widget для тестирования ──────────────────────────────────────────────────

class LoginForm extends StatefulWidget {
  final Future<bool> Function(String email, String password)? onLogin;

  const LoginForm({super.key, this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final success = await (widget.onLogin?.call(
            _emailCtrl.text,
            _passwordCtrl.text,
          ) ??
          Future.value(true));
      if (!mounted) return;
      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный логин или пароль')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            key: const Key('email'),
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) => (v?.isEmpty ?? true) ? 'Введите email' : null,
          ),
          TextFormField(
            key: const Key('password'),
            controller: _passwordCtrl,
            decoration: const InputDecoration(labelText: 'Пароль'),
            obscureText: true,
            validator: (v) => (v?.isEmpty ?? true) ? 'Введите пароль' : null,
          ),
          const SizedBox(height: 16),
          _loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  key: const Key('loginButton'),
                  onPressed: _submit,
                  child: const Text('Войти'),
                ),
        ],
      ),
    );
  }
}

// ─── Widget тесты ─────────────────────────────────────────────────────────────

void runWidgetTests() {
  group('LoginForm', () {
    testWidgets('Показывает ошибки при пустых полях', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: LoginForm()),
      ));

      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      expect(find.text('Введите email'), findsOneWidget);
      expect(find.text('Введите пароль'), findsOneWidget);
    });

    testWidgets('Показывает SnackBar при неверных данных', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LoginForm(
            onLogin: (_, __) async => false,
          ),
        ),
      ));

      await tester.enterText(find.byKey(const Key('email')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password')), 'wrongpass');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Неверный логин или пароль'), findsOneWidget);
    });
  });
}

// ─── Точка входа ─────────────────────────────────────────────────────────────

void main() {
  runCartTests();
  runWidgetTests();
}
