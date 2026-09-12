import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'theming_task.dart';

void main() {
  group('Theming helpers', () {
    test('readableTextColor выбирает контрастный цвет', () {
      expect(readableTextColor(Colors.black), Colors.white);
      expect(readableTextColor(Colors.white), Colors.black);
    });

    test('AppSpacing copyWith меняет выбранное поле', () {
      const spacing = AppSpacing(small: 4, medium: 8, large: 16);

      expect(spacing.copyWith(medium: 12).medium, 12);
      expect(spacing.copyWith(medium: 12).small, 4);
    });
  });
}
