// ============================================================
// 12 ЗАДАЧ ПО NETWORKING (HTTP + JSON)
// ============================================================
// Цель: освоить статусы, заголовки, URI, разбор JSON и слой ApiClient
// без реального dio/http — через лёгкую абстракцию.

/// HTTP-метод.
enum HttpMethod { get, post, put, patch, delete }

/// Упрощённый HTTP-ответ.
class HttpResponse {
  const HttpResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {},
  });

  final int statusCode;
  final String body;
  final Map<String, String> headers;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

/// Ошибка API с кодом и сообщением.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
  });

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Контракт транспорта (в проде — dio/http).
abstract class HttpTransport {
  Future<HttpResponse> send({
    required HttpMethod method,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  });
}

// ЗАДАЧА 1
// Верни true для кодов 2xx.
bool isSuccessStatus(int statusCode) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Классифицируй код: 'success' | 'client_error' | 'server_error' | 'other'.
String statusCategory(int statusCode) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Собери URI: baseUrl + path + query.
// Пример: https://api.example.com, '/users', {'page': '1'}
// -> https://api.example.com/users?page=1
Uri buildApiUri(
  String baseUrl,
  String path, {
  Map<String, String>? query,
}) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Добавь Authorization: Bearer <token> к заголовкам (не мутируя исходную map).
Map<String, String> withAuthHeader(
  Map<String, String> headers,
  String token,
) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Разбери JSON-объект из строки. При ошибке — FormatException.
Map<String, dynamic> decodeJsonObject(String source) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Разбери JSON-массив объектов. При ошибке — FormatException.
List<Map<String, dynamic>> decodeJsonObjectList(String source) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Модель UserDto: id (int), name (String), email (String).
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8
// Если response не success — брось ApiException.
// body может содержать {"message": "..."} — используй его, иначе 'Request failed'.
void ensureSuccess(HttpResponse response) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// ApiClient поверх HttpTransport.
class ApiClient {
  ApiClient({
    required this.baseUrl,
    required this.transport,
    this.token,
  });

  final String baseUrl;
  final HttpTransport transport;
  final String? token;

  // GET path, верни body как Map. При ошибке статуса — ApiException.
  Future<Map<String, dynamic>> getJson(String path) async {
    throw UnimplementedError();
  }

  // POST path с JSON-телом, верни body как Map.
  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Из списка UserDto верни email по id или null.
String? emailById(List<UserDto> users, int id) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Нужно ли повторять запрос? Только для 408, 429, 500, 502, 503, 504.
bool shouldRetry(int statusCode) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Задержка для retry: attempt 1 -> 200ms, 2 -> 400ms, 3 -> 800ms (exponential).
// attempt начинается с 1. При attempt < 1 бросай ArgumentError.
Duration retryDelay(int attempt) {
  throw UnimplementedError();
}
