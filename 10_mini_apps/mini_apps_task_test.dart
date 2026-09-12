import 'package:test/test.dart';

import 'mini_apps_task.dart';

void main() {
  group('Mini apps pure logic', () {
    test('filterTodos фильтрует задачи', () {
      const todos = [
        TodoItem(id: '1', title: 'A', completed: false),
        TodoItem(id: '2', title: 'B', completed: true),
      ];

      expect(filterTodos(todos, TodoFilter.all).length, 2);
      expect(filterTodos(todos, TodoFilter.active).single.id, '1');
      expect(filterTodos(todos, TodoFilter.completed).single.id, '2');
    });

    test('weatherSummary строит текст карточки', () {
      expect(
        weatherSummary(
          const Weather(city: 'Moscow', temperature: 5, description: 'cloudy'),
        ),
        'Moscow: 5°C, cloudy',
      );
    });

    test('authRedirect отправляет гостя на login', () {
      expect(authRedirect(isLoggedIn: false, location: '/profile'), '/login');
      expect(authRedirect(isLoggedIn: true, location: '/login'), '/');
      expect(authRedirect(isLoggedIn: true, location: '/profile'), isNull);
    });

    test('cartTotal считает сумму', () {
      const product = Product(id: 'p1', title: 'Book', price: 100);
      const cart = Cart(
        items: {
          'p1': CartItem(product: product, quantity: 3),
        },
      );

      expect(cartTotal(cart), 300);
    });
  });
}
