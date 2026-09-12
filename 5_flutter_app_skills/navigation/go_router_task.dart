import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ============================================================
// 12 ЗАДАЧ ПО НАВИГАЦИИ С GO_ROUTER
// ============================================================
// Цель: освоить path/query params, nested routes, redirect,
// errorBuilder и передачу extra.

// ЗАДАЧА 1
// Создай router с маршрутами:
// / -> HomeScreen
// /profile/:id -> ProfileScreen(id)
GoRouter createBasicRouter() {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Достань id из GoRouterState pathParameters.
String readProfileId(GoRouterState state) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Достань query-параметр tab. Если его нет — "overview".
String readProfileTab(GoRouterState state) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Создай router с redirect:
// если пользователь не авторизован и идет не на /login -> /login.
GoRouter createAuthRouter(AuthState authState) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Создай ShellRoute с двумя вкладками: /feed и /settings.
GoRouter createTabsRouter() {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Собери location для профиля: /profile/:id?tab=...
String profileLocation(String id, {String tab = 'overview'}) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Виджет HomeScreen с кнопками перехода на profile и settings.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8
// Виджет ProfileScreen показывает id и выбранный tab.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.id,
    required this.tab,
    super.key,
  });

  final String id;
  final String tab;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9
// Виджет LoginScreen вызывает authState.login() и возвращает на /.
class LoginScreen extends StatelessWidget {
  const LoginScreen({
    required this.authState,
    super.key,
  });

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Экран ошибки для errorBuilder.
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Передай объект Article через context.go('/article', extra: article)
// и достань его на экране.
class ArticleScreen extends StatelessWidget {
  const ArticleScreen({
    required this.article,
    super.key,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 12
// BottomNavigationScaffold должен менять вкладки через context.go().
class BottomNavigationScaffold extends StatelessWidget {
  const BottomNavigationScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class AuthState extends ChangeNotifier {
  bool _isLoggedIn;

  AuthState({bool isLoggedIn = false}) : _isLoggedIn = isLoggedIn;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

class Article {
  const Article({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
