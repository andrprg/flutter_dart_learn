import 'package:flutter_test/flutter_test.dart';

import 'responsive_task.dart';

void main() {
  group('Responsive helpers', () {
    test('sizeClassForWidth возвращает size class', () {
      expect(sizeClassForWidth(320), WindowSizeClass.compact);
      expect(sizeClassForWidth(700), WindowSizeClass.medium);
      expect(sizeClassForWidth(1000), WindowSizeClass.expanded);
    });

    test('columnsForSizeClass возвращает количество колонок', () {
      expect(columnsForSizeClass(WindowSizeClass.compact), 1);
      expect(columnsForSizeClass(WindowSizeClass.medium), 2);
      expect(columnsForSizeClass(WindowSizeClass.expanded), 3);
    });

    test('pageHorizontalPadding растет с шириной', () {
      expect(pageHorizontalPadding(320), 16);
      expect(pageHorizontalPadding(700), 24);
      expect(pageHorizontalPadding(1000), 32);
    });

    test('imageAspectRatio зависит от ширины', () {
      expect(imageAspectRatio(320), 1);
      expect(imageAspectRatio(700), 16 / 9);
    });
  });
}
