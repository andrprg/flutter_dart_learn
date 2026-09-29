import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'fpdart_composition_task.dart';

void main() {
  group('fpdart composition', () {
    test('errorMessage / nonEmpty / positiveInt / register', () {
      expect(
        errorMessage(const ValidationError(['a', 'b'])),
        'a, b',
      );
      expect(
        errorMessage(const NetworkError('timeout')),
        'timeout',
      );
      expect(
        errorMessage(const NotFoundError('user')),
        'user not found',
      );

      expect(nonEmpty('  '), isA<Left>());
      expect(nonEmpty('ok'), const Right('ok'));
      expect(positiveInt('10'), const Right(10));
      expect(positiveInt('0'), isA<Left>());

      expect(register('a@b.com', 'password1'), const Right('ok:a@b.com'));
      expect(register('', 'password1'), isA<Left>());
      expect(register('a@b.com', 'short'), isA<Left>());
    });

    test('traverse / sequence / zip / option / bimap / recover', () {
      expect(
        traverseOption([const Some(1), const Some(2)]),
        const Some([1, 2]),
      );
      expect(
        traverseOption<int>([const Some(1), const None()]),
        const None(),
      );

      expect(
        sequenceEither<int>([const Right(1), const Right(2)]),
        const Right([1, 2]),
      );
      expect(
        sequenceEither<int>([
          const Right(1),
          const Left(ValidationError(['e'])),
        ]),
        isA<Left>(),
      );

      expect(
        zip2(const Right(1), const Right('a')),
        const Right((1, 'a')),
      );

      expect(
        optionToAppEither(const Some(1), 'user'),
        const Right(1),
      );
      expect(
        optionToAppEither(const None<int>(), 'user'),
        const Left(NotFoundError('user')),
      );

      final mapped = bimapApp<int, String>(
        const Left(NetworkError('x')),
        mapError: (e) => const NetworkError('y'),
        mapValue: (v) => '$v',
      );
      expect(mapped, const Left(NetworkError('y')));

      expect(
        recoverNotFound(const Left(NotFoundError('u')), 0),
        const Right(0),
      );
    });

    test('fromFuture и parallel2', () async {
      final ok = await fromFuture(() async => 42).run();
      expect(ok, const Right(42));

      final fail = await fromFuture<int>(() async => throw Exception('boom')).run();
      expect(fail.isLeft(), isTrue);

      final both = await parallel2(
        TaskEither<AppError, int>.right(1),
        TaskEither<AppError, String>.right('a'),
      ).run();
      expect(both, const Right((1, 'a')));
    });
  });
}
