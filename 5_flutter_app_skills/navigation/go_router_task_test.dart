import 'package:flutter_test/flutter_test.dart';

import 'go_router_task.dart';

void main() {
  group('go_router helpers', () {
    test('profileLocation строит путь профиля', () {
      expect(profileLocation('42'), '/profile/42?tab=overview');
      expect(profileLocation('42', tab: 'posts'), '/profile/42?tab=posts');
    });

    test('AuthState меняет состояние авторизации', () {
      final auth = AuthState();

      expect(auth.isLoggedIn, isFalse);

      auth.login();
      expect(auth.isLoggedIn, isTrue);

      auth.logout();
      expect(auth.isLoggedIn, isFalse);
    });
  });
}
