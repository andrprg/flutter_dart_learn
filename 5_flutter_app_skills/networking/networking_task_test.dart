import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'networking_task.dart';

class _FakeTransport implements HttpTransport {
  _FakeTransport(this._handler);

  final Future<HttpResponse> Function({
    required HttpMethod method,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) _handler;

  @override
  Future<HttpResponse> send({
    required HttpMethod method,
    required Uri uri,
    Map<String, String>? headers,
    String? body,
  }) {
    return _handler(
      method: method,
      uri: uri,
      headers: headers,
      body: body,
    );
  }
}

void main() {
  group('Networking helpers', () {
    test('isSuccessStatus и statusCategory', () {
      expect(isSuccessStatus(200), isTrue);
      expect(isSuccessStatus(299), isTrue);
      expect(isSuccessStatus(404), isFalse);

      expect(statusCategory(201), 'success');
      expect(statusCategory(404), 'client_error');
      expect(statusCategory(503), 'server_error');
      expect(statusCategory(100), 'other');
    });

    test('buildApiUri собирает path и query', () {
      final uri = buildApiUri(
        'https://api.example.com',
        '/users',
        query: {'page': '1'},
      );

      expect(uri.toString(), 'https://api.example.com/users?page=1');
    });

    test('withAuthHeader не мутирует исходную map', () {
      final original = <String, String>{'Accept': 'application/json'};
      final result = withAuthHeader(original, 'token-1');

      expect(result['Authorization'], 'Bearer token-1');
      expect(original.containsKey('Authorization'), isFalse);
    });

    test('decodeJsonObject и decodeJsonObjectList', () {
      expect(decodeJsonObject('{"a":1}'), {'a': 1});
      expect(
        () => decodeJsonObject('[1]'),
        throwsFormatException,
      );

      expect(
        decodeJsonObjectList('[{"id":1},{"id":2}]'),
        [
          {'id': 1},
          {'id': 2},
        ],
      );
      expect(
        () => decodeJsonObjectList('{"id":1}'),
        throwsFormatException,
      );
    });

    test('UserDto fromJson/toJson', () {
      final user = UserDto.fromJson({
        'id': 1,
        'name': 'Ann',
        'email': 'ann@example.com',
      });

      expect(user.id, 1);
      expect(user.name, 'Ann');
      expect(user.toJson()['email'], 'ann@example.com');
    });

    test('ensureSuccess бросает ApiException', () {
      expect(
        () => ensureSuccess(
          const HttpResponse(
            statusCode: 400,
            body: '{"message":"Bad request"}',
          ),
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.message, 'message', 'Bad request'),
        ),
      );
    });

    test('ApiClient getJson/postJson', () async {
      final transport = _FakeTransport(({
        required method,
        required uri,
        headers,
        body,
      }) async {
        if (method == HttpMethod.get) {
          expect(uri.path, '/users/1');
          expect(headers?['Authorization'], 'Bearer abc');
          return const HttpResponse(
            statusCode: 200,
            body: '{"id":1,"name":"Ann","email":"a@e.com"}',
          );
        }

        expect(method, HttpMethod.post);
        expect(jsonDecode(body!), {'name': 'Bob'});
        return const HttpResponse(
          statusCode: 201,
          body: '{"id":2,"name":"Bob","email":"b@e.com"}',
        );
      });

      final client = ApiClient(
        baseUrl: 'https://api.example.com',
        transport: transport,
        token: 'abc',
      );

      final getResult = await client.getJson('/users/1');
      expect(getResult['name'], 'Ann');

      final postResult = await client.postJson('/users', {'name': 'Bob'});
      expect(postResult['id'], 2);
    });

    test('emailById, shouldRetry, retryDelay', () {
      final users = [
        const UserDto(id: 1, name: 'A', email: 'a@e.com'),
        const UserDto(id: 2, name: 'B', email: 'b@e.com'),
      ];

      expect(emailById(users, 2), 'b@e.com');
      expect(emailById(users, 9), isNull);

      expect(shouldRetry(503), isTrue);
      expect(shouldRetry(404), isFalse);

      expect(retryDelay(1), const Duration(milliseconds: 200));
      expect(retryDelay(2), const Duration(milliseconds: 400));
      expect(retryDelay(3), const Duration(milliseconds: 800));
      expect(() => retryDelay(0), throwsArgumentError);
    });
  });
}
