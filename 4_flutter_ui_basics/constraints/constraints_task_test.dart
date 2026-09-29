import 'package:flutter_test/flutter_test.dart';

import 'constraints_task.dart';

void main() {
  group('Constraints helpers', () {
    test('isTight / isLoose / isUnboundedWidth', () {
      expect(
        isTight(const SimpleConstraints(
          minWidth: 100,
          maxWidth: 100,
          minHeight: 50,
          maxHeight: 50,
        )),
        isTrue,
      );
      expect(
        isLoose(const SimpleConstraints(
          minWidth: 0,
          maxWidth: 200,
          minHeight: 0,
          maxHeight: 100,
        )),
        isTrue,
      );
      expect(isLoose(SimpleConstraints.unbounded), isFalse);
      expect(isUnboundedWidth(SimpleConstraints.unbounded), isTrue);
    });

    test('tightSize и looseSize', () {
      final tight = tightSize(120, 80);
      expect(isTight(tight), isTrue);
      expect(tight.maxWidth, 120);

      final loose = looseSize(120, 80);
      expect(isLoose(loose), isTrue);
      expect(loose.maxHeight, 80);
    });

    test('clampAxis и constrain', () {
      expect(clampAxis(50, 0, 100), 50);
      expect(clampAxis(150, 0, 100), 100);
      expect(clampAxis(10, 20, double.infinity), 20);
      expect(clampAxis(999, 0, double.infinity), 999);

      final size = constrain(
        const SimpleConstraints(
          minWidth: 50,
          maxWidth: 100,
          minHeight: 10,
          maxHeight: 40,
        ),
        const SimpleSize(200, 5),
      );
      expect(size.width, 100);
      expect(size.height, 10);
    });

    test('tighten', () {
      final result = tighten(
        const SimpleConstraints(
          minWidth: 0,
          maxWidth: 200,
          minHeight: 0,
          maxHeight: 100,
        ),
        const SimpleSize(150, 80),
      );
      expect(isTight(result), isTrue);
      expect(result.maxWidth, 150);
      expect(result.maxHeight, 80);
    });

    test('canUseFlexAlong и listViewInColumnErrorCode', () {
      expect(
        canUseFlexAlong(
          const SimpleConstraints(
            minWidth: 0,
            maxWidth: 400,
            minHeight: 0,
            maxHeight: 800,
          ),
          vertical: true,
        ),
        isTrue,
      );
      expect(
        canUseFlexAlong(SimpleConstraints.unbounded, vertical: false),
        isFalse,
      );
      expect(listViewInColumnErrorCode(), 'unbounded_height');
    });

    test('flexExtent и scrollStrategyForColumn', () {
      expect(
        flexExtent(flex: 1, totalFlex: 2, available: 100),
        50,
      );
      expect(
        flexExtent(flex: 2, totalFlex: 5, available: 100),
        40,
      );
      expect(
        () => flexExtent(flex: 1, totalFlex: 0, available: 100),
        throwsArgumentError,
      );

      expect(
        scrollStrategyForColumn(
          const SimpleConstraints(
            minWidth: 0,
            maxWidth: 400,
            minHeight: 0,
            maxHeight: 600,
          ),
        ),
        'expanded',
      );
      expect(
        scrollStrategyForColumn(SimpleConstraints.unbounded),
        'shrink_wrap',
      );
    });
  });
}
