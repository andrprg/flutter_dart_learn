import 'package:flutter_test/flutter_test.dart';

import 'null_safety_task.dart';

void main() {
  group('Null safety helpers', () {
    test('lengthOrZero / normalizeName / pickLabel', () {
      expect(lengthOrZero(null), 0);
      expect(lengthOrZero('ab'), 2);
      expect(normalizeName('  Ann '), 'Ann');
      expect(normalizeName('   '), isNull);
      expect(pickLabel(null, 'default'), 'default');
      expect(pickLabel('x', 'default'), 'x');
    });

    test('readThroughCache и doubleOrZero', () {
      final store = <String, String?>{};
      expect(readThroughCache(store, 'a', () => 'computed'), 'computed');
      expect(store['a'], 'computed');
      expect(readThroughCache(store, 'a', () => 'other'), 'computed');

      expect(doubleOrZero(4), 8);
      expect(doubleOrZero(null), 0);
    });

    test('asStringOrNull / requireName / compact / userName', () {
      expect(asStringOrNull('x'), 'x');
      expect(asStringOrNull(1), isNull);
      expect(requireName('Ann'), 'Ann');
      expect(() => requireName(null), throwsArgumentError);
      expect(compact([null, 'a', null, 'b']), ['a', 'b']);
      expect(compact(null), isEmpty);
      expect(userNameOrUnknown({1: 'Ann'}, 2), 'unknown');
    });

    test('LazyConfig / applyName / fail', () {
      final config = LazyConfig();
      expect(config.isInitialized, isFalse);
      config.ensureInitialized('https://api');
      expect(config.isInitialized, isTrue);
      expect(config.apiUrl, 'https://api');

      expect(applyName(null, 'X'), isNull);
      final u = MutableUser('old');
      expect(applyName(u, 'new')?.name, 'new');

      expect(() => fail('boom'), throwsStateError);
    });
  });
}
