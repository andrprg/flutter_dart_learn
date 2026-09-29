import 'package:flutter_test/flutter_test.dart';

import 'isolates_task.dart';

void main() {
  group('Isolates helpers', () {
    test('shouldOffload / chooseRunner / safe types', () {
      expect(shouldOffloadToIsolate('json_parse_big'), isTrue);
      expect(shouldOffloadToIsolate('setState'), isFalse);
      expect(canCaptureUiInIsolateClosure(), isFalse);

      expect(chooseRunner(expectedMs: 5), 'main');
      expect(chooseRunner(expectedMs: 40), 'isolate');

      expect(
        isolateSafePayloadTypes(),
        containsAll(['int', 'String', 'List', 'Map', 'SendPort']),
      );
      expect(
        isolateUnsafePayloadTypes(),
        containsAll(['BuildContext', 'UiWidget', 'Socket']),
      );
    });

    test('sumSquaresInIsolate и parseIntListInIsolate', () async {
      expect(await sumSquaresInIsolate(3), 1 + 4 + 9);
      expect(await parseIntListInIsolate('[1,2,3]'), [1, 2, 3]);
    });

    test('runWorkerOnce и mapSumSquares', () async {
      expect(await runWorkerOnce(4), sumSquares(4));
      expect(await mapSumSquares([2, 3]), [sumSquares(2), sumSquares(3)]);
    });

    test('failingIsolate пробрасывает ошибку', () async {
      expect(failingIsolate(), throwsA(isA<Exception>()));
    });
  });
}
