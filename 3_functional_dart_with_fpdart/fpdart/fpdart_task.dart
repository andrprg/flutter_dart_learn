import 'package:fpdart/fpdart.dart';

// ============================================================
// 30 ЗАДАЧ ПО БИБЛИОТЕКЕ FPDART
// Функциональное программирование в Dart: Option, Either,
// Task, TaskEither, IO, Reader, State, Tuple и do-нотация.
// ============================================================
//
// Перед запуском: dart pub get
// Запуск отдельной задачи: раскомментируй вызов в main().
//
// Документация: https://pub.dev/packages/fpdart

/// Базовый уровень — Option (1–10)

// ЗАДАЧА 1
// Реализуй toOption(int? value): если value == null, верни Option.none(),
// иначе Option.of(value). Используй Option.fromNullable.
//
// toOption(5)   → Some(5)
// toOption(null) → None()

Option<int> toOption(int? value) {
  return Option.fromNullable(value);
}

// ЗАДАЧА 2
// Реализуй safeDivide(int a, int b): при b == 0 верни Option.none(),
// иначе Option.of(a ~/ b) (целочисленное деление).
//
// safeDivide(10, 2) → Some(5)
// safeDivide(10, 0) → None()

Option<int> safeDivide(int a, int b) {
  return b == 0 ? Option.none() : Option.of(a ~/ b);
}

// ЗАДАЧА 3
// Дан Option<int>. Удвой значение через .map(), если оно есть.
// Реализуй doubleOption(Option<int> opt).
//
// doubleOption(some(3)) → Some(6)
// doubleOption(none())  → None()

Option<int> doubleOption(Option<int> opt) {
  return opt.map((v) => v + v);
}

// ЗАДАЧА 4
// Реализуй parsePositiveInt(String s):
// - парси через int.tryParse(s)
// - если null или число <= 0 — Option.none()
// - иначе Option.of(число)
// Используй flatMap / bind для цепочки проверок.
//
// parsePositiveInt("42")  → Some(42)
// parsePositiveInt("-1")  → None()
// parsePositiveInt("abc") → None()

Option<int> parsePositiveInt(String s) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Реализуй optionToLabel(Option<String> opt) через .fold():
// None → "пусто", Some(x) → "значение: x"
//
// optionToLabel(some("Dart")) → "значение: Dart"
// optionToLabel(none())       → "пусто"

String optionToLabel(Option<String> opt) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Реализуй getOrDefault(Option<int> opt, int defaultValue)
// через getOrElse (или fold).
//
// getOrDefault(some(7), 0) → 7
// getOrDefault(none(), 0)  → 0

int getOrDefault(Option<int> opt, int defaultValue) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Реализуй filterEven(Option<int> opt): оставь Some только если
// число чётное, иначе верни None. Используй .filter().
//
// filterEven(some(4)) → Some(4)
// filterEven(some(3)) → None()

Option<int> filterEven(Option<int> opt) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Реализуй firstPresent(List<Option<int>> options):
// верни первый Some из списка, иначе None.
// Подсказка: цикл или fold; в fpdart есть alt на Option.
//
// firstPresent([none(), some(1), some(2)]) → Some(1)
// firstPresent([none(), none()])         → None()

Option<int> firstPresent(List<Option<int>> options) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Реализуй sumOptions(Option<int> a, Option<int> b):
// если оба Some — верни Some(сумма), иначе None.
// Используй комбинатор Option.Do или последовательный flatMap.
//
// sumOptions(some(2), some(3)) → Some(5)
// sumOptions(some(2), none())  → None()

Option<int> sumOptions(Option<int> a, Option<int> b) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Реализуй sequenceOptions(List<Option<int>> list):
// если хотя бы один None — верни None,
// иначе Some со списком всех значений.
// Подсказка: Option.sequenceList или traverseList.
//
// sequenceOptions([some(1), some(2)]) → Some([1, 2])
// sequenceOptions([some(1), none()])  → None()

Option<List<int>> sequenceOptions(List<Option<int>> list) {
  throw UnimplementedError();
}

/// Средний уровень — Either и комбинации (11–20)

// ЗАДАЧА 11
// Реализуй divideEither(int a, int b):
// при b == 0 — Either.left("Деление на ноль"),
// иначе Either.right(a / b).
//
// divideEither(10, 2) → Right(5.0)
// divideEither(10, 0) → Left("Деление на ноль")

Either<String, double> divideEither(int a, int b) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Реализуй sqrtEither(double x):
// при x < 0 — Left("Отрицательный аргумент"),
// иначе Right(sqrt(x)). import 'dart:math' show sqrt;
//
// sqrtEither(9)  → Right(3.0)
// sqrtEither(-1) → Left(...)

Either<String, double> sqrtEither(double x) {
  throw UnimplementedError();
}

// ЗАДАЧА 13
// Реализуй mapRight(Either<String, int> either):
// удвой правую часть через .map() (ошибка Left не меняется).
//
// mapRight(right(4)) → Right(8)
// mapRight(left("e")) → Left("e")

Either<String, int> mapRight(Either<String, int> either) {
  throw UnimplementedError();
}

// ЗАДАЧА 14
// Реализуй chainParse(String s):
// 1) int.tryParse → при неудаче Left("не число")
// 2) если число < 0 → Left("отрицательное")
// 3) иначе Right(число)
// Используй flatMap / bind.
//
// chainParse("10") → Right(10)
// chainParse("x")  → Left("не число")

Either<String, int> chainParse(String s) {
  throw UnimplementedError();
}

// ЗАДАЧА 15
// Реализуй eitherToMessage(Either<String, int> e) через fold:
// Left(err) → "Ошибка: $err", Right(v) → "OK: $v"
//
// eitherToMessage(right(5)) → "OK: 5"

String eitherToMessage(Either<String, int> e) {
  throw UnimplementedError();
}

// ЗАДАЧА 16
// Реализуй getRightOr(Either<String, int> e, int fallback)
// через getOrElse / fold.
//
// getRightOr(right(3), 0) → 3
// getRightOr(left("x"), 0) → 0

int getRightOr(Either<String, int> e, int fallback) {
  throw UnimplementedError();
}

// ЗАДАЧА 17
// Реализуй optionToEither(Option<int> opt):
// None → Left("значение отсутствует"),
// Some(v) → Right(v).
// Подсказка: fold на Option или метод toEither.
//
// optionToEither(some(1)) → Right(1)
// optionToEither(none())  → Left(...)

Either<String, int> optionToEither(Option<int> opt) {
  throw UnimplementedError();
}

// ЗАДАЧА 18
// Реализуй accumulate(List<Either<String, int>> list):
// собери все Right в List<int>; при первом Left — верни его.
// Подсказка: fold или traverse / sequence на Either.
//
// accumulate([right(1), right(2)]) → Right([1, 2])
// accumulate([right(1), left("e")]) → Left("e")

Either<String, List<int>> accumulate(List<Either<String, int>> list) {
  throw UnimplementedError();
}

// ЗАДАЧА 19
// Реализуй validateEmail(String email):
// если нет '@' или строка пустая — Left("Некорректный email"),
// иначе Right(email.trim()).
//
// validateEmail("a@b.c") → Right("a@b.c")
// validateEmail("bad")   → Left(...)

Either<String, String> validateEmail(String email) {
  throw UnimplementedError();
}

// ЗАДАЧА 20
// Реализуй validatePassword(String password):
// минимум 8 символов, иначе Left с текстом ошибки.
// Затем в validateUser объедини validateEmail и validatePassword
// через flatMap (оба должны пройти).
// Верни Right с записью (email, password) как Tuple2 или Map.
//
// validateUser("a@b.c", "12345678") → Right(...)
// validateUser("bad", "12345678")   → Left(...)

Either<String, String> validatePassword(String password) {
  throw UnimplementedError();
}

Either<String, (String, String)> validateUser(
  String email,
  String password,
) {
  throw UnimplementedError();
}

/// Продвинутый уровень — Task, TaskEither, IO, Reader, State (21–30)

// ЗАДАЧА 21
// Реализуй taskGreeting(): Task<String>, который при .run()
// возвращает Future с строкой "Привет из Task".
// Создай через Task(() async => ...) или Task.of после задержки.
//
// await taskGreeting().run() → "Привет из Task"

Task<String> taskGreeting() {
  throw UnimplementedError();
}

// ЗАДАЧА 22
// Реализуй taskDouble(Task<int> task): примени .map((x) => x * 2)
// к Task. Проверь: taskDouble(Task.of(21)).run() → 42.

Task<int> taskDouble(Task<int> task) {
  throw UnimplementedError();
}

// ЗАДАЧА 23
// Реализуй fetchUserTask(int id): TaskEither<String, String>
// - id <= 0 → TaskEither.left("Неверный id")
// - id == 404 → left("Пользователь не найден")
// - иначе после Future.delayed(100ms) → right("User#$id")
// Используй TaskEither.tryCatch или TaskEither.fromTask.
//
// await fetchUserTask(1).run()   → Right("User#1")
// await fetchUserTask(404).run() → Left(...)

TaskEither<String, String> fetchUserTask(int id) {
  throw UnimplementedError();
}

// ЗАДАЧА 24
// Реализуй loadProfile(int id): цепочка TaskEither:
// 1) fetchUserTask(id)
// 2) map в строку "Профиль: <имя>"
// Выведи результат через fold в async main.
//
// loadProfile(2).run() → Right("Профиль: User#2")

TaskEither<String, String> loadProfile(int id) {
  throw UnimplementedError();
}

// ЗАДАЧА 25
// Реализуй ioLog(String message): IO<Unit>, который при run()
// печатает message и возвращает unit.
// Подсказка: IO(() { print(message); return unit; })
//
// ioLog("test").run() → печатает "test"

IO<Unit> ioLog(String message) {
  throw UnimplementedError();
}

// ЗАДАЧА 26
// Реализуй ioGreet(String name): IO<String> — run() возвращает
// "Привет, $name!" без побочных эффектов кроме чистого вычисления.
//
// ioGreet("Анна").run() → "Привет, Анна!"

IO<String> ioGreet(String name) {
  throw UnimplementedError();
}

// ЗАДАЧА 27
// Реализуй readerGreet: Reader<String, String> — из контекста
// (имя окружения) строит приветствие "Здравствуй, <ctx>".
// run("Мир") → "Здравствуй, Мир"
//
// Подсказка: Reader.ask или Reader((ctx) => ...)

Reader<String, String> readerGreet() {
  throw UnimplementedError();
}

// ЗАДАЧА 28
// Реализуй increment: State<int, int> — увеличивает счётчик
// в состоянии на 1 и возвращает новое значение счётчика.
// Запусти через run(0) и получи (новоеСостояние, результат).
//
// increment.run(0) → (1, 1); повторный вызов с (1,1) → (2, 2)

State<int, int> increment() {
  throw UnimplementedError();
}

// ЗАДАЧА 29
// Реализуй parseUserDo с do-нотацией Option (Option.Do):
// из Map<String, String> извлеки ключи 'name' и 'age',
// age парси в int; любое отсутствие → None.
// Успех → Some с record (name, age) или классом User.
//
// parseUserDo({'name': 'Ann', 'age': '30'}) → Some(...)
// parseUserDo({'name': 'Ann'})               → None()

class User {
  const User(this.name, this.age);
  final String name;
  final int age;

  @override
  String toString() => 'User($name, $age)';
}

Option<User> parseUserDo(Map<String, String> json) {
  throw UnimplementedError();
}

// ЗАДАЧА 30
// Реализуй registerUser pipeline на TaskEither:
// - validateUser(email, password)
// - затем "сохранение": TaskEither.right после delay 50ms
//   с сообщением "Зарегистрирован: $email"
// - при любой Left из валидации — не сохранять
// Обработай итог в runAndPrint: fold → print ошибки или успеха.
//
// await registerUser("u@mail.com", "password1").run()
//   → Left (короткий пароль) или Right после успеха

TaskEither<String, String> registerUser(String email, String password) {
  throw UnimplementedError();
}

Future<void> runAndPrint(TaskEither<String, String> task) async {
  final result = await task.run();
  result.fold(
    (err) => print('Ошибка: $err'),
    (msg) => print(msg),
  );
}

// ============================================================
// ТОЧКА ВХОДА
// ============================================================

void main() async {
  // Раскомментируй задачу для проверки:
  print(toOption(5));
  // print(await taskGreeting().run());
  // await runAndPrint(registerUser('test@test.com', 'longpassword'));
}
