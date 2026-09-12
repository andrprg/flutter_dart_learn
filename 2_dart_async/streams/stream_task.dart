import 'dart:async';

import 'package:async/async.dart';

// ============================================================
// 15 ЗАДАЧ ПО STREAM В DART
// ============================================================
// Цель: понять одноразовые и broadcast streams, StreamController,
// async*, трансформации, ошибки и простые реактивные сценарии.

// ЗАДАЧА 1
// Верни stream чисел от 1 до count.
Stream<int> countStream(int count) {
  return Stream<int>.periodic(const Duration(seconds: 0), (i) => i + 1)
      .take(count);
}

// ЗАДАЧА 2
// Собери все значения stream в List.
Future<List<T>> collectStream<T>(Stream<T> stream) {
  return stream.toList();
}

// ЗАДАЧА 3
// Верни stream только четных чисел.
Stream<int> evenNumbers(Stream<int> source) {
  return source.where((n) => n % 2 == 0);
}

// ЗАДАЧА 4
// Умножь каждое число stream на multiplier.
Stream<int> multiplyStream(Stream<int> source, int multiplier) {
  return source.map((n) => n * multiplier);
}

// ЗАДАЧА 5
// Просуммируй все числа stream.
Future<int> sumStream(Stream<int> source) {
  return source.fold(0, (acc, val) => acc + val);
}

// ЗАДАЧА 6
// Верни первое значение, которое больше threshold. Если такого нет — null.
Future<int?> firstGreaterThan(Stream<int> source, int threshold) {
  return source.where((n) => n > threshold).firstOrNull;
}

// ЗАДАЧА 7
// Преобразуй stream ошибок в значения fallback.
Stream<T> recoverWith<T>(Stream<T> source, T fallback) {
  return source.transform(
    StreamTransformer.fromHandlers(
      handleError: (e, s, sink) => sink.add(fallback),
    ),
  );
}

// ЗАДАЧА 8
// Создай broadcast stream, который отдаёт переданные значения.
Stream<T> broadcastFrom<T>(Iterable<T> values) {
  return Stream.fromIterable(values).asBroadcastStream();
}

// ЗАДАЧА 9
// Склей два stream последовательно: сначала first, затем second.
Stream<T> concatStreams<T>(Stream<T> first, Stream<T> second) {
  return Stream.fromIterable([first, second]).asyncExpand((s) => s);
}

// ЗАДАЧА 10
// Объедини два stream, отдавая события по мере прихода.
Stream<T> mergeStreams<T>(Stream<T> first, Stream<T> second) {
  return StreamGroup.merge([first, second]);
}

// ЗАДАЧА 11
// Реализуй debounce: событие проходит только после паузы duration.
Stream<T> debounce<T>(Stream<T> source, Duration duration) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Убери соседние повторяющиеся значения.
Stream<T> distinctAdjacent<T>(Stream<T> source) {
  throw UnimplementedError();
}

// ЗАДАЧА 13
// Верни stream прогресса от 0 до 100 с шагом step.
Stream<int> progressStream(int step) {
  throw UnimplementedError();
}

// ЗАДАЧА 14
// Преобразуй stream строк в stream SearchState:
// пустой запрос -> idle, непустой -> loading, затем data.
Stream<SearchState> searchStates(Stream<String> queries) {
  throw UnimplementedError();
}

// ЗАДАЧА 15
// Создай StreamController, верни объект с sink-функцией и stream.
CounterBus createCounterBus() {
  throw UnimplementedError();
}

class SearchState {
  const SearchState._(this.status, this.query);

  const SearchState.idle() : this._('idle', '');

  const SearchState.loading(String query) : this._('loading', query);

  const SearchState.data(String query) : this._('data', query);

  final String status;
  final String query;

  @override
  bool operator ==(Object other) {
    return other is SearchState &&
        other.status == status &&
        other.query == query;
  }

  @override
  int get hashCode => Object.hash(status, query);
}

class CounterBus {
  const CounterBus({
    required this.add,
    required this.stream,
    required this.close,
  });

  final void Function(int value) add;
  final Stream<int> stream;
  final Future<void> Function() close;
}

void main() async {
  Stream<int> str = Stream.fromIterable(Iterable.generate(10, (i) => i + 1));
  multiplyStream(str, 2).listen((data) => print(data));
}
