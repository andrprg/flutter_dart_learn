/// ЗАДАЧА 16 — Управление состоянием: Riverpod
/// Уровень: Mid / Senior Flutter
/// Тема: Riverpod, Provider, AsyncNotifier, StateNotifier
///
/// Реализуйте Todo-приложение с использованием Riverpod:
///
/// Провайдеры:
///   - [todosProvider] (NotifierProvider) — список задач
///   - [filteredTodosProvider] — отфильтрованный список
///   - [filterProvider] — текущий фильтр (all / active / completed)
///   - [todoCountProvider] — количество незавершённых задач
///
/// Операции:
///   - Добавить задачу
///   - Отметить выполненной / невыполненной
///   - Удалить задачу
///   - Фильтрация по статусу
///
/// Вопросы на собесе:
///   - В чём разница Provider vs NotifierProvider vs AsyncNotifierProvider?
///   - Что такое ref.watch vs ref.read vs ref.listen?
///   - Когда использовать KeepAlive?

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Модель ──────────────────────────────────────────────────────────────────

class Todo {
  final String id;
  final String title;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Todo copyWith({String? title, bool? completed}) => Todo(
        id: id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );
}

enum TodoFilter { all, active, completed }

// ─── Notifier ─────────────────────────────────────────────────────────────────

class TodosNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [
      const Todo(id: '1', title: 'Изучить Riverpod'),
      const Todo(id: '2', title: 'Написать тесты', completed: true),
      const Todo(id: '3', title: 'Пройти собеседование'),
    ];
  }

  void add(String title) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    state = [...state, Todo(id: id, title: title)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
    ];
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}

// ─── Провайдеры ───────────────────────────────────────────────────────────────

final todosProvider = NotifierProvider<TodosNotifier, List<Todo>>(
  TodosNotifier.new,
);

class FilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter newFilter) => state = newFilter;
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

// ─── UI ──────────────────────────────────────────────────────────────────────

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(todosProvider.notifier).add(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(filteredTodosProvider);
    final count = ref.watch(todoCountProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Todo ($count осталось)')),
      body: Column(
        children: [
          // Фильтры
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<TodoFilter>(
              segments: const [
                ButtonSegment(value: TodoFilter.all, label: Text('Все')),
                ButtonSegment(value: TodoFilter.active, label: Text('Активные')),
                ButtonSegment(value: TodoFilter.completed, label: Text('Готово')),
              ],
              selected: {filter},
              onSelectionChanged: (s) =>
                  ref.read(filterProvider.notifier).state = s.first,
            ),
          ),
          // Список
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, i) {
                final todo = todos[i];
                return ListTile(
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (_) =>
                        ref.read(todosProvider.notifier).toggle(todo.id),
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        ref.read(todosProvider.notifier).remove(todo.id),
                  ),
                );
              },
            ),
          ),
          // Добавление
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Новая задача...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Добавить')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Точка входа ─────────────────────────────────────────────────────────────

void main() {
  runApp(const ProviderScope(child: TodoApp()));
}
