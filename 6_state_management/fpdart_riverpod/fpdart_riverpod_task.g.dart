// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fpdart_riverpod_task.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todoRepository)
final todoRepositoryProvider = TodoRepositoryProvider._();

final class TodoRepositoryProvider
    extends $FunctionalProvider<TodoRepository, TodoRepository, TodoRepository>
    with $Provider<TodoRepository> {
  TodoRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryHash();

  @$internal
  @override
  $ProviderElement<TodoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoRepository create(Ref ref) {
    return todoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoRepository>(value),
    );
  }
}

String _$todoRepositoryHash() => r'2d6eb07180094bd4511b05e53485e5c2a06bb1d5';

@ProviderFor(todos)
final todosProvider = TodosProvider._();

final class TodosProvider extends $FunctionalProvider<AsyncValue<List<Todo>>,
        List<Todo>, FutureOr<List<Todo>>>
    with $FutureModifier<List<Todo>>, $FutureProvider<List<Todo>> {
  TodosProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todosProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todosHash();

  @$internal
  @override
  $FutureProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Todo>> create(Ref ref) {
    return todos(ref);
  }
}

String _$todosHash() => r'a98c48197a5e91cf99774288580cb5f51911813d';

@ProviderFor(TodoFormController)
final todoFormControllerProvider = TodoFormControllerProvider._();

final class TodoFormControllerProvider
    extends $NotifierProvider<TodoFormController, TodoFormState> {
  TodoFormControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoFormControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoFormControllerHash();

  @$internal
  @override
  TodoFormController create() => TodoFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoFormState>(value),
    );
  }
}

String _$todoFormControllerHash() =>
    r'147bda784b4ce0adfe7e80ccf0a7af575b9d1bcf';

abstract class _$TodoFormController extends $Notifier<TodoFormState> {
  TodoFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TodoFormState, TodoFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<TodoFormState, TodoFormState>,
        TodoFormState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(canSubmit)
final canSubmitProvider = CanSubmitProvider._();

final class CanSubmitProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  CanSubmitProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'canSubmitProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$canSubmitHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canSubmit(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canSubmitHash() => r'e06998bd8d4110f5c86c4cd235842784234a5136';
