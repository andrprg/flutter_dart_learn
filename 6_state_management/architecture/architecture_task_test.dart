import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'architecture_task.dart';

class _FakeSource implements TodoRemoteSource {
  final List<Map<String, dynamic>> items = [];

  @override
  Future<List<Map<String, dynamic>>> fetchAll() async =>
      List<Map<String, dynamic>>.from(items);

  @override
  Future<Map<String, dynamic>> create(String title) async {
    final row = {'id': '${items.length + 1}', 'title': title, 'done': false};
    items.add(row);
    return row;
  }
}

void main() {
  group('Architecture helpers', () {
    test('Todo/Dto/validate/layers', () {
      expect(
        const Todo(id: '1', title: 'A', done: false).copyWith(done: true).done,
        isTrue,
      );

      final dto = TodoDto.fromJson({
        'id': '1',
        'title': 'A',
        'done': false,
      });
      expect(dto.toJson()['title'], 'A');

      expect(todoFromDto(dto), isA<Right>());
      expect(validateTitle('  '), isA<Left>());
      expect(validateTitle('Buy'), const Right('Buy'));

      expect(jsonBelongsToLayer(), 'data');
      expect(snackBarBelongsToLayer(), 'presentation');
      expect(failureToMessage(const ValidationFailure('x')), 'x');
    });

    test('repository + use-case + view state', () async {
      final repo = TodoRepositoryImpl(_FakeSource());

      final loaded = await repo.getTodos().run();
      expect(loaded, const Right(<Todo>[]));

      final added = await addAndLoad(repo, 'Milk').run();
      expect(added.isRight(), isTrue);
      added.match((_) {}, (list) {
        expect(list.single.title, 'Milk');
      });

      expect(
        eitherToViewState(const Right([])),
        isA<TodosData>(),
      );
      expect(
        eitherToViewState(const Left(DataFailure('oops'))),
        isA<TodosError>(),
      );

      final state = await runTodos(repo.getTodos());
      expect(state, isA<TodosData>());
    });
  });
}
