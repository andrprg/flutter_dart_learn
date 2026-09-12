import 'dart:async';
import 'dart:math';

// ============================================================
// 30 ЗАДАЧ ПО FUTURE В DART
// ============================================================

/// Базовый уровень (1–5)

// ЗАДАЧА 1
// Создай функцию fetchUserName(), которая возвращает Future<String>.
// Используй Future.delayed на 2 секунды и верни строку "Иван Иванов".
// В main() вызови функцию и выведи результат с помощью .then().
//
// Ожидаемый вывод: Иван Иванов

Future<String> fetchUserName() {
  return Future.delayed(Duration(seconds: 2), () => 'Иван Иванов');
}

// ЗАДАЧА 2
// Создай функцию getNumber(), которая возвращает Future<int> со значением 42.
// В main() получи результат с помощью async/await и выведи его.
// Также выведи "До запроса" и "После запроса" в нужном порядке.
//
// Ожидаемый вывод:
// До запроса
// 42
// После запроса
Future<int> getNumber() async {
  return Future.value(42);
}

// ЗАДАЧА 3
// Создай функцию divide(int a, int b), которая возвращает Future<double>.
// Если b == 0, выброси исключение: throw Exception("Деление на ноль").
// Обработай ошибку через .catchError() в main().
//
// Ожидаемый вывод (при b=0): Ошибка: Exception: Деление на ноль

Future<double> divide(int a, int b) async {
  if (b == 0) throw Exception("Деление на ноль");
  return a / b;
}

// ЗАДАЧА 4
// Создай две функции: fetchFirstName() и fetchLastName(), каждая возвращает
// Future<String> с задержкой 1 секунду. Используй Future.wait() для
// одновременного выполнения обоих и выведи полное имя.
//
// Ожидаемый вывод: Александр Петров

Future<String> fetchFirstName() async {
  return Future.delayed(const Duration(seconds: 1), () => 'Александр');
}

Future<String> fetchLastName() async {
  return Future.delayed(const Duration(seconds: 1), () => 'Петров');
}

// ЗАДАЧА 5
// Напиши функцию loadConfig(), которая возвращает Future<Map<String, String>>
// с задержкой 1 секунду. Карта должна содержать ключи "host" и "port".
// Выведи каждый параметр конфигурации в main().
//
// Ожидаемый вывод:
// host: localhost
// port: 8080

Future<Map<String, String>> loadConfig() async {
  return Future.delayed(
      const Duration(seconds: 1), () => {'host': 'localhost', 'port': '8080'});
}

/// Средний уровень (6–10)

// ЗАДАЧА 6
// Реализуй цепочку Future через .then():
// 1. fetchPrice() — возвращает Future<double> со значением 100.0
// 2. applyDiscount(price) — возвращает Future<double> (скидка 10%)
// 3. applyTax(price) — возвращает Future<double> (налог 20%)
// Выведи итоговую цену.
//
// Ожидаемый вывод: 108.0

Future<double> fetchPrice() async {
  return 100;
}

Future<double> applyDiscount(double price) async {
  return price * 0.9;
}

Future<double> applyTax(double price) async {
  return price * 1.2;
}

// ЗАДАЧА 7
// Создай функцию checkConnection(), которая возвращает Future<bool>.
// Если соединение успешно (true) — выведи "Подключено",
// иначе — "Нет соединения". Используй async/await и if/else.
//
// Ожидаемый вывод: Подключено

Future<bool> checkConnection() async {
  final random = Random();
  return random.nextBool();
}

// ЗАДАЧА 8
// Создай функцию fetchItems(), возвращающую Future<List<String>>
// со списком ["яблоко", "банан", "вишня"]. Используй async/await,
// затем выведи каждый элемент списка в отдельной строке.
//
// Ожидаемый вывод:
// яблоко
// банан
// вишня

Future<List<String>> fetchItems() async {
  return ["яблоко", "банан", "вишня"];
}

// ЗАДАЧА 9
// Реализуй функцию retry(Future<String> Function() operation, int times),
// которая повторяет операцию до times раз при возникновении ошибки.
// Проверь на функции, которая дейлится первые 2 раза, затем возвращает "OK".
//
// Ожидаемый вывод: OK

Future<String> retry(Future<String> Function() operation, int times) async {
  Object? error;
  for (int i = 0; i < times; i++) {
    try {
      return await operation();
    } catch (e) {
      error = e;
    }
  }
  throw error!;
}

// ЗАДАЧА 10
// Создай функцию fetchWithTimeout(), которая использует Future.timeout().
// Задержка внутри — 5 секунд, таймаут — 2 секунды.
// Обработай TimeoutException и выведи "Превышено время ожидания".
//
// Ожидаемый вывод: Превышено время ожидания

Future<String> fetchWithTimeout() async {
  try {
    return await Future.delayed(const Duration(seconds: 5), () => 'OK')
        .timeout(const Duration(seconds: 2));
  } on TimeoutException {
    return 'Превышено время ожидания';
  }
}

// ЗАДАЧА 11
// Используй Future.value() для создания уже завершённого Future<int> со
// значением 99. Выведи значение через .then(). Объясни в комментарии,
// чем Future.value() отличается от обычного Future с async.
//
// Ожидаемый вывод: 99

Future<int> getImmediateValue() {
  return Future.value(99);
}

// ЗАДАЧА 12
// Создай функцию loadUserData() возвращающую Future<Map<String, dynamic>>.
// Используй конструкцию try/catch/finally в async функции main().
// В блоке finally выведи "Загрузка завершена" независимо от результата.
//
// Ожидаемый вывод:
// Данные: {name: Мария, age: 25}
// Загрузка завершена

Future<Map<String, dynamic>> loadUserData() async {
  return Future.value({'name': 'Мария', 'age': 25});
}

/// Продвинутый уровень (13–20)

// ЗАДАЧА 13
// Создай список из 5 функций Future<int>, каждая возвращает своё число
// с разной задержкой (от 0 до 4 секунд). Используй Future.wait() и
// выведи сумму всех результатов.
//
// Ожидаемый вывод: 15 (сумма 1+2+3+4+5)

Future<int> fetchNumber(int value, int delaySeconds) async {
  return Future.delayed(Duration(seconds: delaySeconds), () => value);
}

// ЗАДАЧА 14
// Реализуй последовательное выполнение Future через цикл for и await.
// Создай список URL-адресов (просто строки) и имитируй загрузку каждого
// (Future.delayed). Выведи сообщение о загрузке каждого "URL".
//
// Ожидаемый вывод:
// Загружено: https://site1.com
// Загружено: https://site2.com
// Загружено: https://site3.com

Future<void> loadUrl(String url) async {
  return Future.delayed(const Duration(seconds: 1), () {});
}

// ЗАДАЧА 15
// Используй Future.any() с тремя Future, возвращающими строки с разными
// задержками (3с, 1с, 2с). Выведи результат самого быстрого.
//
// Ожидаемый вывод: Быстрый сервер

Future<String> fetchFromServer(String name, int delaySeconds) async {
  return Future.delayed(Duration(seconds: delaySeconds), () => name);
}

// ЗАДАЧА 16
// Создай функцию processOrder(int orderId) возвращающую Future<String>.
// Внутри последовательно вызови: validateOrder(), reserveStock(),
// processPayment() — каждая async функция с задержкой 0.5с.
// Выведи статус каждого шага и финальный результат.
//
// Ожидаемый вывод:
// Заказ проверен
// Товар зарезервирован
// Оплата выполнена
// Заказ #1 обработан

Future<void> validateOrder(int orderId) async {
  return Future.delayed(
      const Duration(milliseconds: 500), () => print('Заказ проверен'));
}

Future<void> reserveStock(int orderId) async {
  return Future.delayed(
      const Duration(milliseconds: 500), () => print('Товар зарезервирован'));
}

Future<void> processPayment(int orderId) async {
  return Future.delayed(
      const Duration(milliseconds: 500), () => print('Оплата выполнена'));
}

Future<String> processOrder(int orderId) async {
  await validateOrder(orderId);
  await reserveStock(orderId);
  await processPayment(orderId);
  return 'Заказ #$orderId обработан';
}

// ЗАДАЧА 17
// Создай Completer<String> вручную. Запусти таймер через Future.delayed,
// который завершит Completer через 2 секунды значением "Готово!".
// Получи Future из Completer и выведи результат.
//
// Ожидаемый вывод: Готово!

Future<String> fetchWithCompleter() {
  final Completer<String> completer = Completer<String>();
  Future.delayed(
      const Duration(seconds: 2), () => completer.complete('Готово!'));
  return completer.future;
}

// ЗАДАЧА 18
// Напиши функцию fetchPagedData(int page) возвращающую Future<List<int>>.
// Каждая страница содержит 3 числа: страница 1 → [1,2,3], страница 2 → [4,5,6].
// Загрузи обе страницы последовательно и объедини в один список.
//
// Ожидаемый вывод: [1, 2, 3, 4, 5, 6]

Future<List<int>> fetchPagedData(int page) async {
  await Future.delayed(const Duration(milliseconds: 200));
  final start = (page - 1) * 3 + 1;
  return List.generate(3, (i) => start + i);
}

Future<List<int>> fetchAllPages(int lastPage) async {
  final result = <int>[];
  for (var page = 1; page <= lastPage; page++) {
    result.addAll(await fetchPagedData(page));
  }
  return result;
}

// ЗАДАЧА 19
// Реализуй кэширование Future: создай Map<String, Future<String>> cache.
// Функция getData(String key) должна возвращать уже существующий Future
// из кэша, если он там есть, иначе создать новый и сохранить в кэш.
// Вызови getData("user") дважды и убедись, что запрос выполнился один раз.
//
// Ожидаемый вывод:
// Выполняется запрос для: user
// Результат 1: Данные пользователя
// Результат 2: Данные пользователя

final Map<String, Future<String>> _cache = {};

void clearCache() => _cache.clear();

Future<String> getData(String key) {
  return _cache.putIfAbsent(key, () {
    print('Выполняется запрос для: $key');
    return Future.delayed(
        const Duration(seconds: 1), () => 'Данные пользователя');
  });
}

// ЗАДАЧА 20
// Создай функцию runWithLogging<T>(String name, Future<T> Function() fn),
// которая логирует начало и конец выполнения Future, а также время
// выполнения в миллисекундах. Примени её к функции с задержкой 1.5 секунды.
//
// Ожидаемый вывод:
// [START] fetchData
// [END] fetchData за ~1500мс
// Результат: Данные получены

Future<T> runWithLogging<T>(String name, Future<T> Function() fn) async {
  print('[START] $name');
  final stopwatch = Stopwatch()..start();
  final result = await fn();
  stopwatch.stop();
  print('[END] $name за ~${stopwatch.elapsedMilliseconds}мс');
  return result;
}

// ============================================================
// ЕЩЁ 10 ЗАДАЧ ДЛЯ ПРОДВИНУТЫХ (21–30)
// ============================================================

// ЗАДАЧА 21
// Реализуй функцию raceWithCancel():
// - Запусти две операции через Completer (например, "A" за 3с и "B" за 1с).
// - Верни результат самой быстрой (аналог Future.any),
//   но при этом “отмени” медленную: предотврати её завершение/побочные эффекты.
// Подсказка: используй флаг cancelled и проверяй его перед complete().
//
// Ожидаемый вывод:
// Победитель: B
// Медленная операция отменена
Future<String> raceWithCancel() async {
  throw UnimplementedError();
}

// ЗАДАЧА 22
// Реализуй Future.wait() с расширенными настройками:
// - Создай 3 Future, один из которых падает с ошибкой.
// - В функции waitAllOrCollectErrors() верни список результатов, где
//   успешные значения лежат как есть, а ошибки превращаются в строки вида
//   "ERROR: <message>".
// Запрещено “ронять” общий Future — он должен завершаться успешно.
//
// Пример ожидаемого вывода:
// [1, ERROR: boom, 3]
Future<List<Object>> waitAllOrCollectErrors() async {
  throw UnimplementedError();
}

// ЗАДАЧА 23
// Напиши withRetryBackoff<T>():
// - Делай retries повторов при ошибке
// - Между попытками делай экспоненциальную задержку: baseDelay * 2^attempt
// - Если все попытки исчерпаны — пробрось последнюю ошибку
//
// Ожидаемое поведение: операция, падающая 2 раза, затем успех → вернёт успех.
Future<T> withRetryBackoff<T>(
  Future<T> Function() operation, {
  int retries = 3,
  Duration baseDelay = const Duration(milliseconds: 200),
}) async {
  throw UnimplementedError();
}

// ЗАДАЧА 24
// Реализуй limitConcurrency<T>():
// - Принимает список фабрик Future (List<Future<T> Function()>)
// - Запускает одновременно не больше maxConcurrent задач
// - Возвращает результаты в исходном порядке
//
// Подсказка: можно сделать очередь + счетчик активных задач + Completer.
Future<List<T>> limitConcurrency<T>(
  List<Future<T> Function()> tasks, {
  int maxConcurrent = 2,
}) async {
  throw UnimplementedError();
}

// ЗАДАЧА 25
// Напиши withTimeoutFallback<T>():
// - Запускает operation()
// - Если за timeout не завершилось — возвращает fallback()
// - Если operation завершилось с ошибкой ДО таймаута — ошибка должна пробрасываться
//
// Ожидаемый вывод (если операция 5с, timeout 2с): вернётся fallback-значение.
Future<T> withTimeoutFallback<T>(
  Future<T> Function() operation, {
  required Duration timeout,
  required T Function() fallback,
}) async {
  throw UnimplementedError();
}

// ЗАДАЧА 26
// Напиши flatten<T>():
// - Принимает Future<Future<T>> и возвращает Future<T>
// - Проверь, что ошибки во внутреннем Future корректно пробрасываются наружу
Future<T> flatten<T>(Future<Future<T>> nested) async {
  throw UnimplementedError();
}

// ЗАДАЧА 27
// Реализуй memoizeAsync<T>():
// - Возвращает функцию, которая вызывает supplier() только один раз
// - Пока вычисление идёт, все параллельные вызовы должны ждать тот же Future
// - Если вычисление упало с ошибкой, следующий вызов должен попробовать снова
//
// Подсказка: храни текущий Future<T>?; при ошибке сбрасывай.
Future<T> Function() memoizeAsync<T>(Future<T> Function() supplier) {
  throw UnimplementedError();
}

// ЗАДАЧА 28
// Напиши ensureMinDuration<T>():
// - Запускает operation()
// - Гарантирует, что итоговый Future завершится не раньше, чем minDuration
// - Если operation завершается дольше minDuration — ничего дополнительно не ждём
//
// Подсказка: Future.wait([operation(), Future.delayed(minDuration)]).
Future<T> ensureMinDuration<T>(
  Future<T> Function() operation, {
  required Duration minDuration,
}) async {
  throw UnimplementedError();
}

// ЗАДАЧА 29
// Реализуй последовательный “pipeline” с обработкой ошибок:
// - Функция pipe<T>(T input, List<Future<T> Function(T)> steps)
// - Выполняй шаги строго по очереди через await
// - Если шаг падает — добавь контекст в ошибку (например, номер шага) и пробрось
Future<T> pipe<T>(T input, List<Future<T> Function(T)> steps) async {
  throw UnimplementedError();
}

// ЗАДАЧА 30
// Сравни поведение Future.microtask и Future(() {}):
// - Реализуй demoMicrotaskOrdering(), которая выводит порядок логов:
//   "sync-1", затем microtask, затем event-task, затем "sync-2" (или иной фактический).
// - Задача: добиться и зафиксировать (через print) наблюдаемый порядок выполнения.
//
// Подсказка: print("sync-1"); Future.microtask(...); Future(() ...); print("sync-2");
Future<void> demoMicrotaskOrdering() async {
  throw UnimplementedError();
}

int attempts = 0;
Future<String> flakyOperation() async {
  attempts++;
  if (attempts <= 2) {
    throw Exception('Ошибка попытки $attempts');
  }
  return 'OK';
}
// ============================================================
// ТОЧКА ВХОДА
// ============================================================

void main() async {
  final result = await runWithLogging(
    'fetchData',
    () => Future.delayed(
      const Duration(milliseconds: 1500),
      () => 'Данные получены',
    ),
  );
  print('Результат: $result');
}
