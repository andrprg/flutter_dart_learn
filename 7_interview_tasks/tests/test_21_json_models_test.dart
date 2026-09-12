import 'package:test/test.dart';

import '../task_21_json_models.dart'
    show
        Address,
        UserProfile,
        UserRole,
        addressFromJson,
        addressToJson,
        parseUserRole,
        userProfileFromJson,
        userProfileToJson;

void main() {
  group('Задача 21 — JSON models', () {
    test('parseUserRole: user/admin', () {
      expect(parseUserRole('user'), equals(UserRole.user));
      expect(parseUserRole('admin'), equals(UserRole.admin));
    });

    test('parseUserRole: неизвестное значение -> FormatException', () {
      expect(() => parseUserRole('moderator'), throwsA(isA<FormatException>()));
    });

    test('Address fromJson/toJson roundtrip', () {
      final a =
          addressFromJson({'city': 'SPB', 'street': 'Nevsky', 'house': 1});
      expect(a.city, equals('SPB'));
      expect(a.street, equals('Nevsky'));
      expect(a.house, equals(1));

      final json = addressToJson(a);
      expect(json['city'], equals('SPB'));
      expect(json['street'], equals('Nevsky'));
      expect(json['house'], equals(1));
    });

    test('UserProfile fromJson: обязательные поля', () {
      final u = userProfileFromJson({
        'id': 10,
        'name': 'Ann',
        'role': 'admin',
        'createdAt': '2026-04-16T12:00:00Z',
        'address': {'city': 'MSK', 'street': 'Tverskaya', 'house': 10},
      });
      expect(u, isA<UserProfile>());
      expect(u.id, equals(10));
      expect(u.role, equals(UserRole.admin));
      expect(u.phone, isNull);
    });

    test('UserProfile toJson: createdAt ISO, address object', () {
      final u = userProfileFromJson({
        'id': 1,
        'name': 'Ann',
        'role': 'user',
        'createdAt': '2026-04-16T12:00:00Z',
        'address': {'city': 'MSK', 'street': 'Tverskaya', 'house': 10},
        'phone': '123',
      });
      final json = userProfileToJson(u);
      expect(json['createdAt'], isA<String>());
      expect(json['address'], isA<Map>());
      expect(json['phone'], equals('123'));
    });

    test('UserProfile fromJson: неверный тип -> FormatException', () {
      expect(
        () => userProfileFromJson({
          'id': 'oops',
          'name': 'Ann',
          'role': 'user',
          'createdAt': '2026-04-16T12:00:00Z',
          'address': {'city': 'MSK', 'street': 'Tverskaya', 'house': 10},
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('UserProfile fromJson: phone != String/null -> FormatException', () {
      expect(
        () => userProfileFromJson({
          'id': 1,
          'name': 'Ann',
          'role': 'user',
          'createdAt': '2026-04-16T12:00:00Z',
          'address': {'city': 'MSK', 'street': 'Tverskaya', 'house': 10},
          'phone': 123,
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('UserProfile fromJson: createdAt не ISO -> FormatException', () {
      expect(
        () => userProfileFromJson({
          'id': 1,
          'name': 'Ann',
          'role': 'user',
          'createdAt': 'not-a-date',
          'address': {'city': 'MSK', 'street': 'Tverskaya', 'house': 10},
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
