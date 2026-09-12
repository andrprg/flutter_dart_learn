import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_16_riverpod_state.dart) ─────────────────

class Todo {
  final String id;
  final String title;
  final bool completed;

  const Todo({required this.id, required this.title, this.completed = false});

  Todo copyWith({String? title, bool? completed}) => Todo(
        id: id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );
}

enum TodoFilter { all, active, completed }

class TodosNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [
      const Todo(id: '1', title: 'Задача 1'),
      const Todo(id: '2', title: 'Задача 2', completed: true),
      const Todo(id: '3', title: 'Задача 3'),
    ];
  }

  void add(String title) {
    throw UnimplementedError();
  }

  void toggle(String id) {
    throw UnimplementedError();
  }

  void remove(String id) {
    throw UnimplementedError();
  }
}

final todosProvider =
    NotifierProvider<TodosNotifier, List<Todo>>(TodosNotifier.new);

class FilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;
}

final filterProvider = NotifierProvider<FilterNotifier, TodoFilter>(FilterNotifier.new);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  final filter = ref.watch(filterProvider);
  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((t) => !t.completed).toList(),
    TodoFilter.completed => todos.where((t) => t.completed).toList(),
  };
});

final todoCountProvider = Provider<int>(
  (ref) => ref.watch(todosProvider).where((t) => !t.completed).length,
);

// ─── Тесты ───────────────────────────────────────────────────────────────────

ProviderContainer makeContainer() => ProviderContainer();

void main() {
  group('Задача 16 — Riverpod', () {
    group('TodosNotifier (StateNotifier)', () {
      late ProviderContainer container;

      setUp(() => container = makeContainer());
      tearDown(() => container.dispose());

      test('Начальное состояние: 3 задачи', () {
        final todos = container.read(todosProvider);
        expect(todos.length, equals(3));
      });

      test('add() добавляет задачу', () {
        container.read(todosProvider.notifier).add('Новая задача');
        expect(container.read(todosProvider).length, equals(4));
      });

      test('Добавленная задача имеет правильный title', () {
        container.read(todosProvider.notifier).add('Купить хлеб');
        final last = container.read(todosProvider).last;
        expect(last.title, equals('Купить хлеб'));
      });

      test('Добавленная задача по умолчанию незавершена', () {
        container.read(todosProvider.notifier).add('Новая');
        expect(container.read(todosProvider).last.completed, isFalse);
      });

      test('toggle() отмечает задачу как выполненную', () {
        container.read(todosProvider.notifier).toggle('1');
        final todo = container.read(todosProvider).firstWhere((t) => t.id == '1');
        expect(todo.completed, isTrue);
      });

      test('toggle() дважды возвращает в исходное состояние', () {
        container.read(todosProvider.notifier).toggle('1');
        container.read(todosProvider.notifier).toggle('1');
        final todo = container.read(todosProvider).firstWhere((t) => t.id == '1');
        expect(todo.completed, isFalse);
      });

      test('remove() удаляет задачу по id', () {
        container.read(todosProvider.notifier).remove('2');
        final todos = container.read(todosProvider);
        expect(todos.length, equals(2));
        expect(todos.any((t) => t.id == '2'), isFalse);
      });

      test('remove() несуществующего id не меняет список', () {
        container.read(todosProvider.notifier).remove('999');
        expect(container.read(todosProvider).length, equals(3));
      });
    });

    group('filteredTodosProvider', () {
      late ProviderContainer container;

      setUp(() => container = makeContainer());
      tearDown(() => container.dispose());

      test('Фильтр "all" возвращает все задачи', () {
        container.read(filterProvider.notifier).state = TodoFilter.all;
        expect(container.read(filteredTodosProvider).length, equals(3));
      });

      test('Фильтр "active" возвращает только незавершённые', () {
        container.read(filterProvider.notifier).state = TodoFilter.active;
        final filtered = container.read(filteredTodosProvider);
        expect(filtered.every((t) => !t.completed), isTrue);
      });

      test('Фильтр "active" — 2 незавершённые из 3', () {
        container.read(filterProvider.notifier).state = TodoFilter.active;
        expect(container.read(filteredTodosProvider).length, equals(2));
      });

      test('Фильтр "completed" возвращает только завершённые', () {
        container.read(filterProvider.notifier).state = TodoFilter.completed;
        final filtered = container.read(filteredTodosProvider);
        expect(filtered.every((t) => t.completed), isTrue);
      });

      test('Фильтр "completed" — 1 завершённая из 3', () {
        container.read(filterProvider.notifier).state = TodoFilter.completed;
        expect(container.read(filteredTodosProvider).length, equals(1));
      });

      test('После toggle фильтр обновляется', () {
        container.read(filterProvider.notifier).state = TodoFilter.active;
        container.read(todosProvider.notifier).toggle('1');
        // Теперь '1' завершена, значит active должно быть 1
        expect(container.read(filteredTodosProvider).length, equals(1));
      });
    });

    group('todoCountProvider', () {
      late ProviderContainer container;

      setUp(() => container = makeContainer());
      tearDown(() => container.dispose());

      test('Считает незавершённые: 2 из 3', () {
        expect(container.read(todoCountProvider), equals(2));
      });

      test('После toggle уменьшается на 1', () {
        container.read(todosProvider.notifier).toggle('1');
        expect(container.read(todoCountProvider), equals(1));
      });

      test('После add увеличивается на 1', () {
        container.read(todosProvider.notifier).add('Новая');
        expect(container.read(todoCountProvider), equals(3));
      });

      test('После remove завершённой не меняется', () {
        container.read(todosProvider.notifier).remove('2'); // была завершённой
        expect(container.read(todoCountProvider), equals(2));
      });

      test('После remove незавершённой уменьшается', () {
        container.read(todosProvider.notifier).remove('1'); // незавершённая
        expect(container.read(todoCountProvider), equals(1));
      });
    });

    group('Widget Integration (ProviderScope)', () {
      testWidgets('Рендерится без ошибок', (tester) async {
        await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (ctx, ref, _) {
                final count = ref.watch(todoCountProvider);
                return Scaffold(body: Text('Осталось: $count'));
              },
            ),
          ),
        ));
        expect(find.text('Осталось: 2'), findsOneWidget);
      });

      testWidgets('Изменение состояния обновляет UI', (tester) async {
        await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (ctx, ref, _) {
                final todos = ref.watch(todosProvider);
                return Scaffold(
                  body: Column(
                    children: [
                      Text('Всего: ${todos.length}'),
                      ElevatedButton(
                        key: const Key('addBtn'),
                        onPressed: () =>
                            ref.read(todosProvider.notifier).add('Тест'),
                        child: const Text('Добавить'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));

        expect(find.text('Всего: 3'), findsOneWidget);
        await tester.tap(find.byKey(const Key('addBtn')));
        await tester.pump();
        expect(find.text('Всего: 4'), findsOneWidget);
      });
    });
  });
}
