import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'json_task.dart';

void main() {
  group('JSON helpers', () {
    test('role and Address/Person roundtrip', () {
      expect(roleFromString('admin'), UserRole.admin);
      expect(roleFromString('x'), isNull);
      expect(roleToString(UserRole.user), 'user');

      const address = Address(city: 'Moscow', street: 'Tverskaya');
      expect(Address.fromJson(address.toJson()).city, 'Moscow');

      final person = Person(
        id: 1,
        name: 'Ann',
        role: UserRole.admin,
        address: address,
        email: 'a@e.com',
      );
      final restored = Person.fromJson(person.toJson());
      expect(restored.name, 'Ann');
      expect(restored.role, UserRole.admin);
      expect(restored.email, 'a@e.com');
    });

    test('decode/encode/list/pretty/dig/asInt', () {
      final map = decodeJsonMap('{"a":1}');
      expect(map['a'], 1);
      expect(() => decodeJsonMap('[1]'), throwsFormatException);

      expect(jsonDecode(encodeJsonMap({'x': true})), {'x': true});

      final list = parsePersonList(jsonEncode([
        {
          'id': 1,
          'name': 'Ann',
          'role': 'user',
          'address': {'city': 'SPB', 'street': 'Nevsky'},
        }
      ]));
      expect(list.single.address.city, 'SPB');

      expect(prettyJson({'a': 1}), contains('\n'));
      expect(dig({'a': {'b': {'c': 9}}}, 'a.b.c'), 9);
      expect(dig({'a': 1}, 'a.b'), isNull);

      expect(asInt(3), 3);
      expect(asInt(3.0), 3);
      expect(asInt('12'), 12);
      expect(asInt('x'), isNull);
    });
  });
}
