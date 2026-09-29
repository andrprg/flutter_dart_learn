// ============================================================
// 12 ЗАДАЧ ПО ISOLATES
// ============================================================
// Цель: понять, когда уносить работу с UI-isolate,
// Isolate.run, передачу сообщений и ограничения SendPort.

import 'dart:isolate';

/// Тяжёлая CPU-задача для демо (без Flutter compute).
int sumSquares(int n) {
  var sum = 0;
  for (var i = 1; i <= n; i++) {
    sum += i * i;
  }
  return sum;
}

// ЗАДАЧА 1
// Стоит ли уносить в isolate? true для 'json_parse_big', 'image_filter', 'crypto'.
// false для 'setState', 'http_tiny', 'shared_prefs_read'.
bool shouldOffloadToIsolate(String workType) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Запусти sumSquares(n) через Isolate.run и верни результат.
Future<int> sumSquaresInIsolate(int n) async {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Парсинг JSON-списка int в isolate: source вида '[1,2,3]'.
Future<List<int>> parseIntListInIsolate(String source) async {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Можно ли передать в isolate замыкание, захватывающее UI-объект? false.
bool canCaptureUiInIsolateClosure() {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Сообщение воркеру.
class WorkerRequest {
  const WorkerRequest(this.n);
  final int n;
}

class WorkerResponse {
  const WorkerResponse(this.result);
  final int result;
}

// ЗАДАЧА 6
// Точка входа isolate: получи SendPort, слушай WorkerRequest, отвечай WorkerResponse.
// Для тестов вызывается как entry point.
void workerEntrypoint(SendPort mainSendPort) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Запусти workerEntrypoint, отправь WorkerRequest(n), верни result, убей isolate.
Future<int> runWorkerOnce(int n) async {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Ошибка в Isolate.run должна пробрасываться вызывающему.
Future<int> failingIsolate() async {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Параллельно посчитай sumSquares для каждого n через Isolate.run.
Future<List<int>> mapSumSquares(List<int> values) async {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Оценка: если expectedMs > thresholdMs — 'isolate', иначе 'main'.
String chooseRunner({required int expectedMs, int thresholdMs = 16}) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Имена типов, которые безопасно слать между isolates (примитивы/копии):
// верни список из: 'int', 'String', 'List', 'Map', 'SendPort'.
List<String> isolateSafePayloadTypes() {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Имена того, что НЕльзя: 'BuildContext', 'UiWidget', 'Socket' (как пример).
List<String> isolateUnsafePayloadTypes() {
  throw UnimplementedError();
}
