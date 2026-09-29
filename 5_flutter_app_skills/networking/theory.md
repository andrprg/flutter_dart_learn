# Шпаргалка: Networking (HTTP + JSON)

Сетевой слой — не «вызвать dio в виджете», а контракт: URI, заголовки, статусы, DTO, ошибки, retry. В модуле транспорт абстрагирован (`HttpTransport`); в проде на его месте `package:http` или `dio`.

Перед задачами прочитай этот файл, затем решай `networking_task.dart`.

## 1. Статусы

| Диапазон | Категория |
|---|---|
| 200–299 | success |
| 400–499 | client_error |
| 500–599 | server_error |
| иначе | other |

```dart
bool isSuccessStatus(int code) => code >= 200 && code < 300;
```

## 2. URI и заголовки

```dart
Uri buildApiUri(String baseUrl, String path, {Map<String, String>? query}) {
  final base = Uri.parse(baseUrl);
  return base.replace(
    path: '${base.path}${path.startsWith('/') ? path : '/$path'}'
        .replaceAll('//', '/'),
    queryParameters: query,
  );
}

Map<String, String> withAuthHeader(Map<String, String> headers, String token) =>
    {...headers, 'Authorization': 'Bearer $token'};
```

Не мутируй исходную map заголовков. `baseUrl` и token живут в клиенте / DI, не размазаны по UI.

## 3. JSON → DTO

```dart
Map<String, dynamic> decodeJsonObject(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Expected JSON object');
  }
  return decoded;
}

factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as int,
  name: json['name'] as String,
  email: json['email'] as String,
);
```

Ошибка формата — `FormatException`. Ошибка HTTP — свой тип (`ApiException`), не «магическая» строка.

## 4. ensureSuccess и ApiClient

```dart
void ensureSuccess(HttpResponse response) {
  if (response.isSuccess) return;
  String message = 'Request failed';
  try {
    final map = decodeJsonObject(response.body);
    message = map['message'] as String? ?? message;
  } catch (_) {}
  throw ApiException(statusCode: response.statusCode, message: message);
}

Future<Map<String, dynamic>> getJson(String path) async {
  final response = await transport.send(
    method: HttpMethod.get,
    uri: buildApiUri(baseUrl, path),
    headers: token == null ? null : withAuthHeader({}, token!),
  );
  ensureSuccess(response);
  return decodeJsonObject(response.body);
}
```

## 5. Retry

Идемпотентные запросы (GET, иногда PUT) можно повторять. Обычно retry на **408, 429, 5xx** (502/503/504):

```dart
bool shouldRetry(int code) =>
    const {408, 429, 500, 502, 503, 504}.contains(code);

Duration retryDelay(int attempt) {
  if (attempt < 1) throw ArgumentError.value(attempt);
  return Duration(milliseconds: 200 * (1 << (attempt - 1))); // 200, 400, 800...
}
```

Таймауты задавай на транспорте (connect / receive), иначе UI «висит» без ошибки.

## 6. http vs dio, тесты

- `http` — тонкий; `dio` — interceptors, cancel, FormData.
- Тестируй `ApiClient` с fake `HttpTransport` — без сети.
- Certificate pinning — проверка сертификата сервера (MITM-защита); знай термин, внедряй осознанно.

## 7. Зачем это знать

- 2xx ≠ «тело валидно»: всегда парсь и валидируй DTO.
- Ошибки API сериализуй в один тип с `statusCode` + `message`.
- Retry только там, где безопасно; exponential backoff.
- Пагинация — query (`page` / `cursor`), не «загрузить всё».

Дальше по маршруту: `networking_task.dart` → `interview_questions.md`.
