import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_18_testing.dart) ────────────────────────

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

  List<CartItem> get items => throw UnimplementedError();

  void addItem(CartItem item) {
    throw UnimplementedError();
  }

  bool removeItem(String id) {
    throw UnimplementedError();
  }

  double get total => throw UnimplementedError();

  double totalWithDiscount(double discountPercent) {
    throw UnimplementedError();
  }

  void clear() => throw UnimplementedError();
}

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
    throw UnimplementedError();
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

// ─── Unit тесты CartService ───────────────────────────────────────────────────

void main() {
  group('Задача 18 — Unit тесты: CartService', () {
    late CartService cart;

    setUp(() => cart = CartService());

    group('addItem()', () {
      test('Добавляет новый товар', () {
        cart.addItem(
            const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 1));
        expect(cart.items.length, equals(1));
      });

      test('Добавленный товар имеет правильное имя', () {
        cart.addItem(
            const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 1));
        expect(cart.items.first.name, equals('Телефон'));
      });

      test('Добавление того же id суммирует quantity', () {
        cart.addItem(
            const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 1));
        cart.addItem(
            const CartItem(id: '1', name: 'Телефон', price: 50000, quantity: 2));
        expect(cart.items.length, equals(1));
        expect(cart.items.first.quantity, equals(3));
      });

      test('Добавление разных id: 2 позиции в корзине', () {
        cart.addItem(const CartItem(id: '1', name: 'A', price: 100, quantity: 1));
        cart.addItem(const CartItem(id: '2', name: 'B', price: 200, quantity: 1));
        expect(cart.items.length, equals(2));
      });
    });

    group('removeItem()', () {
      test('Удаляет существующий товар → возвращает true', () {
        cart.addItem(const CartItem(id: '1', name: 'X', price: 100, quantity: 1));
        expect(cart.removeItem('1'), isTrue);
      });

      test('После удаления корзина пуста', () {
        cart.addItem(const CartItem(id: '1', name: 'X', price: 100, quantity: 1));
        cart.removeItem('1');
        expect(cart.items, isEmpty);
      });

      test('Несуществующий id → возвращает false', () {
        expect(cart.removeItem('999'), isFalse);
      });

      test('Удаляет только нужный товар', () {
        cart.addItem(const CartItem(id: '1', name: 'A', price: 100, quantity: 1));
        cart.addItem(const CartItem(id: '2', name: 'B', price: 200, quantity: 1));
        cart.removeItem('1');
        expect(cart.items.length, equals(1));
        expect(cart.items.first.name, equals('B'));
      });
    });

    group('total', () {
      test('Пустая корзина → 0', () {
        expect(cart.total, equals(0.0));
      });

      test('Один товар: 2 штуки по 100 → 200', () {
        cart.addItem(const CartItem(id: '1', name: 'A', price: 100, quantity: 2));
        expect(cart.total, equals(200.0));
      });

      test('Несколько товаров суммируются', () {
        cart.addItem(const CartItem(id: '1', name: 'A', price: 100, quantity: 2));
        cart.addItem(const CartItem(id: '2', name: 'B', price: 250, quantity: 1));
        expect(cart.total, equals(450.0));
      });
    });

    group('totalWithDiscount()', () {
      setUp(() =>
          cart.addItem(const CartItem(id: '1', name: 'X', price: 1000, quantity: 1)));

      test('Скидка 0% → полная цена', () {
        expect(cart.totalWithDiscount(0), equals(1000.0));
      });

      test('Скидка 10% → 900', () {
        expect(cart.totalWithDiscount(10), closeTo(900.0, 0.01));
      });

      test('Скидка 50% → 500', () {
        expect(cart.totalWithDiscount(50), closeTo(500.0, 0.01));
      });

      test('Скидка 100% → 0', () {
        expect(cart.totalWithDiscount(100), equals(0.0));
      });
    });

    group('clear()', () {
      test('Очищает корзину', () {
        cart.addItem(const CartItem(id: '1', name: 'A', price: 10, quantity: 1));
        cart.addItem(const CartItem(id: '2', name: 'B', price: 20, quantity: 1));
        cart.clear();
        expect(cart.items, isEmpty);
      });

      test('total после clear = 0', () {
        cart.addItem(const CartItem(id: '1', name: 'A', price: 500, quantity: 2));
        cart.clear();
        expect(cart.total, equals(0.0));
      });
    });

    group('items — неизменяемость', () {
      test('items возвращает UnmodifiableListView', () {
        cart.addItem(const CartItem(id: '1', name: 'X', price: 10, quantity: 1));
        expect(
          () => (cart.items as List).add(
            const CartItem(id: '2', name: 'Y', price: 20, quantity: 1),
          ),
          throwsUnsupportedError,
        );
      });
    });
  });

  group('Задача 18 — Widget тесты: LoginForm', () {
    Widget buildForm([Future<bool> Function(String, String)? onLogin]) =>
        MaterialApp(
          routes: {'/home': (_) => const Scaffold(body: Text('Home'))},
          home: Scaffold(body: LoginForm(onLogin: onLogin)),
        );

    testWidgets('Показывает поля email и password', (tester) async {
      await tester.pumpWidget(buildForm());
      expect(find.byKey(const Key('email')), findsOneWidget);
      expect(find.byKey(const Key('password')), findsOneWidget);
    });

    testWidgets('Показывает кнопку "Войти"', (tester) async {
      await tester.pumpWidget(buildForm());
      expect(find.text('Войти'), findsOneWidget);
    });

    testWidgets('Ошибки валидации при пустых полях', (tester) async {
      await tester.pumpWidget(buildForm());
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();
      expect(find.text('Введите email'), findsOneWidget);
      expect(find.text('Введите пароль'), findsOneWidget);
    });

    testWidgets('Ошибка только email при заполненном пароле', (tester) async {
      await tester.pumpWidget(buildForm());
      await tester.enterText(find.byKey(const Key('password')), 'pass123');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();
      expect(find.text('Введите email'), findsOneWidget);
      expect(find.text('Введите пароль'), findsNothing);
    });

    testWidgets('SnackBar при неверных данных', (tester) async {
      await tester.pumpWidget(buildForm((_, __) async => false));
      await tester.enterText(find.byKey(const Key('email')), 'u@example.com');
      await tester.enterText(find.byKey(const Key('password')), 'wrong');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();
      expect(find.text('Неверный логин или пароль'), findsOneWidget);
    });

    testWidgets('Успешный вход переходит на /home', (tester) async {
      await tester.pumpWidget(buildForm((_, __) async => true));
      await tester.enterText(find.byKey(const Key('email')), 'user@test.com');
      await tester.enterText(find.byKey(const Key('password')), 'pass123');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Поле пароля скрыто (obscureText)', (tester) async {
      await tester.pumpWidget(buildForm());
      final passwordField = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('password')),
          matching: find.byType(EditableText),
        ),
      );
      expect(passwordField.obscureText, isTrue);
    });
  });
}
