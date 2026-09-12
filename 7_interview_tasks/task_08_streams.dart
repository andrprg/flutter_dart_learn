/// ЗАДАЧА 8 — Stream и управление данными
/// Уровень: Mid / Senior
/// Тема: Stream, StreamController, async*
///
/// Реализуйте:
///   1. [numberStream] — генератор чисел от 1 до n с задержкой через async*
///   2. [runningAverage] — принимает Stream<int> и возвращает Stream<double>
///      с текущим средним значением после каждого элемента
///   3. [EventBus] — простая шина событий на StreamController

import 'dart:async';

// ─── Ваше решение ────────────────────────────────────────────────────────────

Stream<int> numberStream(int n, {Duration delay = const Duration(milliseconds: 100)}) async* {
  // TODO: генерируйте числа 1..n с задержкой
  throw UnimplementedError();
}

Stream<double> runningAverage(Stream<int> source) async* {
  // TODO: вычисляйте текущее среднее
  throw UnimplementedError();
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

Stream<int> numberStreamAnswer(int n, {Duration delay = const Duration(milliseconds: 50)}) async* {
  for (int i = 1; i <= n; i++) {
    await Future.delayed(delay);
    yield i;
  }
}

Stream<double> runningAverageAnswer(Stream<int> source) async* {
  int count = 0;
  double sum = 0;
  await for (final value in source) {
    count++;
    sum += value;
    yield sum / count;
  }
}

// ─── EventBus ────────────────────────────────────────────────────────────────

class EventBus {
  final _controller = StreamController.broadcast();

  void emit(dynamic event) => _controller.add(event);

  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();

  void dispose() => _controller.close();
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

class UserLoggedIn {
  final String username;
  const UserLoggedIn(this.username);
}

class PageViewed {
  final String page;
  const PageViewed(this.page);
}

void main() async {
  print('=== Задача 8: Streams ===\n');

  // 1. Running average
  print('Текущее среднее для потока 1..5:');
  await for (final avg in runningAverageAnswer(numberStreamAnswer(5))) {
    print('  avg = ${avg.toStringAsFixed(2)}');
  }

  // 2. EventBus
  print('\nEventBus:');
  final bus = EventBus();

  bus.on<UserLoggedIn>().listen((e) => print('  Логин: ${e.username}'));
  bus.on<PageViewed>().listen((e) => print('  Просмотр: ${e.page}'));

  bus.emit(const UserLoggedIn('alice'));
  bus.emit(const PageViewed('/home'));
  bus.emit(const PageViewed('/profile'));
  bus.emit(const UserLoggedIn('bob'));

  await Future.delayed(const Duration(milliseconds: 100));
  bus.dispose();
}
