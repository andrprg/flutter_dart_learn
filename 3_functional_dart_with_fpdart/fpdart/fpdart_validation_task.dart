import 'package:fpdart/fpdart.dart';

// ============================================================
// 12 ЗАДАЧ: ВАЛИДАЦИЯ С НАКОПЛЕНИЕМ ОШИБОК
// ============================================================
// Цель: попрактиковать Either<List<String>, T>, где ошибки не прячутся
// в исключениях и могут быть показаны в форме.

typedef Validation<T> = Either<List<String>, T>;

// ЗАДАЧА 1
// Валидируй name: не пустой, минимум 2 символа.
Validation<String> validateName(String value) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Валидируй email.
Validation<String> validateEmail(String value) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Валидируй password: минимум 8 символов, цифра, буква.
Validation<String> validatePassword(String value) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Валидируй confirmPassword.
Validation<String> validateConfirmPassword(String value, String password) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Валидируй возраст: 18..120.
Validation<int> validateAge(int value) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Скомбинируй несколько Validation и накопи все ошибки.
Validation<RegisterFormData> validateRegisterForm(RegisterFormDraft draft) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Преобразуй Validation в FieldState.
FieldState<T> validationToFieldState<T>(Validation<T> validation) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Верни только ошибки формы.
List<String> collectValidationErrors(RegisterFormDraft draft) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Валидируй список тегов: не пустой, без дублей, каждый тег <= 20 символов.
Validation<List<String>> validateTags(List<String> tags) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Валидируй цену: > 0 и <= 1_000_000.
Validation<int> validatePrice(int price) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Валидируй ProductDraft и накопи ошибки всех полей.
Validation<Product> validateProduct(ProductDraft draft) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Объедини две Validation, накопив ошибки обеих.
Validation<(A, B)> combine2<A, B>(
  Validation<A> first,
  Validation<B> second,
) {
  throw UnimplementedError();
}

class RegisterFormDraft {
  const RegisterFormDraft({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.age,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final int age;
}

class RegisterFormData {
  const RegisterFormData({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
  });

  final String name;
  final String email;
  final String password;
  final int age;
}

class ProductDraft {
  const ProductDraft({
    required this.title,
    required this.price,
    required this.tags,
  });

  final String title;
  final int price;
  final List<String> tags;
}

class Product {
  const Product({
    required this.title,
    required this.price,
    required this.tags,
  });

  final String title;
  final int price;
  final List<String> tags;
}

sealed class FieldState<T> {
  const FieldState();
}

class FieldValid<T> extends FieldState<T> {
  const FieldValid(this.value);

  final T value;
}

class FieldInvalid<T> extends FieldState<T> {
  const FieldInvalid(this.errors);

  final List<String> errors;
}
