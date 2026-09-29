import 'package:flutter_test/flutter_test.dart';

import 'generics_task.dart';

void main() {
  group('Generics & extensions', () {
    test('Box / unpack / id / firstWhereOrNull / mapIndexed', () {
      expect(unpackOr(const Box(1), 0), 1);
      expect(unpackOr<int>(null, 7), 7);
      expect(id('x'), 'x');
      expect(firstWhereOrNull([1, 2, 3], (e) => e > 2), 3);
      expect(firstWhereOrNull([1, 2], (e) => e > 5), isNull);
      expect(mapIndexed(['a', 'b'], (i, v) => '$i:$v'), ['0:a', '1:b']);
    });

    test('maxOf и MemoryRepository', () {
      expect(maxOf(3, 9), 9);
      expect(maxOf(1.5, 1.2), 1.5);

      final repo = MemoryRepository<Map<String, String>>((m) => m['id']!);
      repo.upsert({'id': '1', 'name': 'Ann'});
      expect(repo.getById('1')?['name'], 'Ann');
      expect(repo.length, 1);
    });

    test('extensions и zip', () {
      expect('  '.isBlank, isTrue);
      expect('a'.isBlank, isFalse);
      expect([1].secondOrNull, isNull);
      expect([1, 2, 3].secondOrNull, 2);
      expect([1, 2, 3].sum, 6);
      expect(zip([1, 2], ['a', 'b', 'c']), [(1, 'a'), (2, 'b')]);
    });
  });
}
