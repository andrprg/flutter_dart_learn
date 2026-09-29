// ============================================================
// 12 ЗАДАЧ ПО OOP В DART
// ============================================================
// Цель: классы, конструкторы, наследование, abstract/implements,
// factory, equality — база до Flutter и fpdart.

class Money {
  const Money(this.amount, this.currency);

  final int amount;
  final String currency;

  // ЗАДАЧА 1
  // Именованный конструктор zero: amount=0, currency как аргумент.
  // Money.zero('USD')
  factory Money.zero(String currency) {
    throw UnimplementedError();
  }

  // ЗАДАЧА 2
  // Сложение только одинаковой currency, иначе ArgumentError.
  Money operator +(Money other) {
    throw UnimplementedError();
  }

  // ЗАДАЧА 3
  // Value equality по amount+currency.
  @override
  bool operator ==(Object other) {
    throw UnimplementedError();
  }

  @override
  int get hashCode {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 4
// Abstract Shape с геттером area.
abstract class Shape {
  double get area;
}

// ЗАДАЧА 5
// Rectangle extends Shape.
class Rectangle extends Shape {
  Rectangle(this.width, this.height);

  final double width;
  final double height;

  @override
  double get area {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 6
// Circle extends Shape (area = pi * r * r). Используй 3.141592653589793.
class Circle extends Shape {
  Circle(this.radius);

  final double radius;

  @override
  double get area {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 7
// Интерфейс JsonEncodable.
abstract interface class JsonEncodable {
  Map<String, Object?> toJson();
}

// ЗАДАЧА 8
// User implements JsonEncodable: id, name.
class User implements JsonEncodable {
  const User({required this.id, required this.name});

  final int id;
  final String name;

  @override
  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }

  // ЗАДАЧА 9
  // factory fromJson. Нет id/name или неверные типы → FormatException.
  factory User.fromJson(Map<String, Object?> json) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Mixin Loud: метод shout(String) => '$s!'.toUpperCase() — нет,
// shout(s) возвращает '${s.toUpperCase()}!'.
mixin Loud {
  String shout(String message) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Announcer with Loud.
class Announcer with Loud {
  const Announcer();
}

// ЗАДАЧА 12
// Сумма площадей списка Shape.
double totalArea(List<Shape> shapes) {
  throw UnimplementedError();
}
