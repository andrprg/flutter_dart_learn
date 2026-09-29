import 'package:flutter_test/flutter_test.dart';

import 'oop_task.dart';

void main() {
  group('OOP helpers', () {
    test('Money zero, +, ==', () {
      final zero = Money.zero('USD');
      expect(zero.amount, 0);
      expect(zero.currency, 'USD');

      final a = const Money(10, 'USD');
      final b = const Money(5, 'USD');
      expect(a + b, const Money(15, 'USD'));
      expect(() => a + const Money(1, 'EUR'), throwsArgumentError);
      expect(a, const Money(10, 'USD'));
      expect({a, const Money(10, 'USD')}.length, 1);
    });

    test('Shape area и totalArea', () {
      expect(Rectangle(2, 3).area, 6);
      expect(Circle(1).area, closeTo(3.141592653589793, 1e-9));
      expect(totalArea([Rectangle(2, 2), Circle(1)]), closeTo(4 + 3.141592653589793, 1e-9));
    });

    test('User json', () {
      const user = User(id: 1, name: 'Ann');
      expect(user.toJson(), {'id': 1, 'name': 'Ann'});
      expect(User.fromJson({'id': 1, 'name': 'Ann'}), isA<User>());
      expect(() => User.fromJson({'id': 1}), throwsFormatException);
    });

    test('Loud mixin', () {
      expect(const Announcer().shout('hi'), 'HI!');
    });
  });
}
