# Шпаргалка: fpdart + Riverpod

Мост между ошибками как значениями (`Either` / `TaskEither`) и UI-состоянием Riverpod (`AsyncValue`). Domain/repository возвращают `TaskEither`, экран смотрит `AsyncValue` / SnackBar. Практика: `fpdart_riverpod_task.dart` + codegen.

## 1. Зачем связка

| Слой | Тип | Зачем |
|---|---|---|
| domain / data | `Either` / `TaskEither<UiFailure, T>` | явные ошибки, без throw через слои |
| application / notifier | `run()` → fold | граница |
| presentation | `AsyncValue` / виджеты | loading / data / error |

UI **не обязан** знать про fpdart: наружу — `AsyncValue` или ViewState.

```dart
typedef UiTask<T> = TaskEither<UiFailure, T>;

sealed class UiFailure {
  const UiFailure();
}
class NetworkUiFailure extends UiFailure { /* message */ }
class ValidationUiFailure extends UiFailure { /* message */ }
```

## 2. Either / Task → AsyncValue

```dart
AsyncValue<T> eitherToAsyncValue<T>(Either<UiFailure, T> either) {
  return either.fold(
    (l) => AsyncValue.error(l, StackTrace.current),
    (r) => AsyncValue.data(r),
  );
}

Future<AsyncValue<T>> taskToAsyncValue<T>(UiTask<T> task) async {
  final either = await task.run();
  return eitherToAsyncValue(either);
}
```

В async-провайдере часто проще:

```dart
@riverpod
Future<List<Todo>> todos(Ref ref) async {
  final repo = ref.watch(todoRepositoryProvider);
  final either = await repo.fetchTodos().run();
  return either.getOrElse((l) => throw l); // Left → AsyncError
}
```

## 3. AsyncValue → виджет

```dart
Widget asyncValueView<T>({
  required AsyncValue<T> value,
  required Widget Function(T data) data,
}) {
  return value.when(
    data: data,
    loading: () => const CircularProgressIndicator(),
    error: (e, _) => Text(e.toString()),
  );
}
```

`TodosScreen` — `ref.watch(todosProvider)` + `when`. Retry: `ref.invalidate(todosProvider)` (в задачах — `RetryButton` с `ProviderOrFamily`).

## 4. Repository provider + форма

```dart
@Riverpod(keepAlive: true)
TodoRepository todoRepository(Ref ref) => /* FakeTodoRepository() */;

@Riverpod(keepAlive: true)
class TodoFormController extends _$TodoFormController {
  @override
  TodoFormState build() => const TodoFormState.initial();

  void titleChanged(String title) =>
      state = state.copyWith(title: title, clearError: true);

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final repo = ref.read(todoRepositoryProvider);
    final either = await repo.createTodo(state.title).run();
    either.fold(
      (f) => state = state.copyWith(isSubmitting: false, error: f),
      (_) {
        state = const TodoFormState.initial();
        ref.invalidate(todosProvider); // обновить список
      },
    );
  }
}

@riverpod
bool canSubmit(Ref ref) {
  final s = ref.watch(todoFormControllerProvider);
  return s.title.trim().isNotEmpty && !s.isSubmitting;
}
```

Derived `canSubmit` — чистый watch; submit — в методе notifier.

## 5. SnackBar и side effects

```dart
SnackBar failureSnackBar(UiFailure failure) { /* текст по типу */ }

Future<Option<T>> runTaskWithSnackBar<T>(
  BuildContext context,
  UiTask<T> task,
) async {
  final either = await task.run();
  return either.fold(
    (f) {
      ScaffoldMessenger.of(context).showSnackBar(failureSnackBar(f));
      return const None();
    },
    (r) => Some(r),
  );
}
```

Показывать SnackBar из **`ref.listen`** / колбэка после `await`, **не** из чистого выражения `build`. Проверяй `mounted` / валидный context.

## 6. Где выполнять TaskEither

- В repository / use-case / методах Notifier — да.
- В `build` виджета «заодно» — нет.
- Параллель: несколько `TaskEither` / `Future.wait`, затем один `AsyncValue` результата.
- Кэш успеха: `keepAlive` у списка или кэш в repo; после mutate — `invalidate`.

## 7. Тесты связки

Фейковый `TodoRepository` возвращает `Right` / `Left`. `ProviderContainer(overrides: [todoRepositoryProvider.overrideWithValue(fake)])` → `container.read(todosProvider.future)` / notifier.submit.

## 8. Вопросы с собеса (кратко)

1. TaskEither ↔ AsyncValue? — run + fold / throw Left.
2. Где run? — notifier / use-case, не UI build.
3. SnackBar на Left? — listen / после await.
4. Retry? — invalidate / повтор метода.
5. fpdart в UI? — лучше не протекать; AsyncValue наружу.
6. Параллель? — wait + один результат.
7. Кэш Right? — keepAlive / repo cache + invalidate.
8. Тесты? — fake repo + overrides.

Сквозная практика: `10_mini_apps/` (Todo, Weather, Auth, Cart).
