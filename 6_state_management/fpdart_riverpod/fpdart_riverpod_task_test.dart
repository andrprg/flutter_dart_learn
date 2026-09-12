import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'fpdart_riverpod_task.dart';

void main() {
  group('fpdart + Riverpod bridge', () {
    test('eitherToAsyncValue преобразует Right в AsyncData', () {
      final either = Either<UiFailure, int>.right(42);
      final value = eitherToAsyncValue<int>(either);

      expect(value, isA<AsyncData<int>>());
    });

    test('TodoFormState.copyWith обновляет title', () {
      final state = const TodoFormState.initial().copyWith(title: 'Learn');

      expect(state.title, 'Learn');
      expect(state.isSubmitting, isFalse);
    });
  });
}
