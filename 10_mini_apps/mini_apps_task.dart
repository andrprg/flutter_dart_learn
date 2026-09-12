import 'package:fpdart/fpdart.dart';

// ============================================================
// 4 MINI APPS ДЛЯ СКВОЗНОЙ ПРАКТИКИ
// ============================================================
// Цель: собрать отдельные навыки в маленькие, но реалистичные сценарии.
// Каждый мини-проект можно делать после прохождения соответствующих треков.

typedef MiniAppTask<T> = TaskEither<MiniAppFailure, T>;

// MINI APP 1: TODO APP
// Темы: формы, списки, фильтры, persistence mock, Riverpod.
// ЗАДАЧА 1.1
// Добавь todo. Пустой title -> Left(ValidationMiniAppFailure).
MiniAppTask<TodoItem> createTodo(TodoRepository repository, String title) {
  throw UnimplementedError();
}

// ЗАДАЧА 1.2
// Отфильтруй todo по статусу.
List<TodoItem> filterTodos(List<TodoItem> todos, TodoFilter filter) {
  throw UnimplementedError();
}

// ЗАДАЧА 1.3
// Переключи completed у todo по id.
MiniAppTask<TodoItem> toggleTodo(TodoRepository repository, String id) {
  throw UnimplementedError();
}

// MINI APP 2: WEATHER MOCK APP
// Темы: TaskEither, fake API, loading/error/data UI, retry.
// ЗАДАЧА 2.1
// Валидируй название города.
Either<MiniAppFailure, String> validateCity(String city) {
  throw UnimplementedError();
}

// ЗАДАЧА 2.2
// Загрузи погоду: validate -> repository.fetchWeather.
MiniAppTask<Weather> loadWeather(WeatherRepository repository, String city) {
  throw UnimplementedError();
}

// ЗАДАЧА 2.3
// Преобразуй Weather в текст для карточки.
String weatherSummary(Weather weather) {
  throw UnimplementedError();
}

// MINI APP 3: AUTH FLOW
// Темы: формы, go_router redirect, session state, secure error messages.
// ЗАДАЧА 3.1
// Валидируй login form.
Either<MiniAppFailure, LoginCredentials> validateLogin(
  String email,
  String password,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 3.2
// Выполни login через repository.
MiniAppTask<UserSession> login(
  AuthRepository repository,
  String email,
  String password,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 3.3
// Верни redirect location для go_router.
String? authRedirect({
  required bool isLoggedIn,
  required String location,
}) {
  throw UnimplementedError();
}

// MINI APP 4: SHOPPING CART
// Темы: Map/Set, derived state, validation, totals.
// ЗАДАЧА 4.1
// Добавь товар в корзину.
Cart addToCart(Cart cart, Product product) {
  throw UnimplementedError();
}

// ЗАДАЧА 4.2
// Измени количество товара. Если quantity <= 0, удалить товар.
Cart changeQuantity(Cart cart, String productId, int quantity) {
  throw UnimplementedError();
}

// ЗАДАЧА 4.3
// Посчитай итоговую стоимость корзины.
int cartTotal(Cart cart) {
  throw UnimplementedError();
}

// ЗАДАЧА 4.4
// Проверь, можно ли оформить заказ.
Either<MiniAppFailure, OrderDraft> checkout(Cart cart) {
  throw UnimplementedError();
}

abstract interface class TodoRepository {
  MiniAppTask<TodoItem> create(String title);

  MiniAppTask<TodoItem> toggle(String id);
}

abstract interface class WeatherRepository {
  MiniAppTask<Weather> fetchWeather(String city);
}

abstract interface class AuthRepository {
  MiniAppTask<UserSession> login(LoginCredentials credentials);
}

sealed class MiniAppFailure {
  const MiniAppFailure();
}

class ValidationMiniAppFailure extends MiniAppFailure {
  const ValidationMiniAppFailure(this.message);

  final String message;
}

class NetworkMiniAppFailure extends MiniAppFailure {
  const NetworkMiniAppFailure(this.message);

  final String message;
}

class UnknownMiniAppFailure extends MiniAppFailure {
  const UnknownMiniAppFailure(this.error);

  final Object error;
}

class TodoItem {
  const TodoItem({
    required this.id,
    required this.title,
    required this.completed,
  });

  final String id;
  final String title;
  final bool completed;
}

enum TodoFilter {
  all,
  active,
  completed,
}

class Weather {
  const Weather({
    required this.city,
    required this.temperature,
    required this.description,
  });

  final String city;
  final int temperature;
  final String description;
}

class LoginCredentials {
  const LoginCredentials({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class UserSession {
  const UserSession({
    required this.token,
    required this.userId,
  });

  final String token;
  final String userId;
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
  });

  final String id;
  final String title;
  final int price;
}

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;
}

class Cart {
  const Cart({
    required this.items,
  });

  final Map<String, CartItem> items;
}

class OrderDraft {
  const OrderDraft({
    required this.items,
    required this.total,
  });

  final List<CartItem> items;
  final int total;
}
