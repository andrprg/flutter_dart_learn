// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_task.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Базовый уровень (1–5)
// ЗАДАЧА 1
// Создай провайдер greeting с аннотацией @Riverpod(keepAlive: true).
// Провайдер должен возвращать строку "Привет, Riverpod!".
// Создай виджет GreetingWidget (ConsumerWidget),
// который читает greetingProvider и отображает строку по центру экрана.
//
// Подсказка: @Riverpod(keepAlive: true), Ref, ref.watch(greetingProvider).

@ProviderFor(greeting)
final greetingProvider = GreetingProvider._();

/// Базовый уровень (1–5)
// ЗАДАЧА 1
// Создай провайдер greeting с аннотацией @Riverpod(keepAlive: true).
// Провайдер должен возвращать строку "Привет, Riverpod!".
// Создай виджет GreetingWidget (ConsumerWidget),
// который читает greetingProvider и отображает строку по центру экрана.
//
// Подсказка: @Riverpod(keepAlive: true), Ref, ref.watch(greetingProvider).

final class GreetingProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Базовый уровень (1–5)
// ЗАДАЧА 1
// Создай провайдер greeting с аннотацией @Riverpod(keepAlive: true).
// Провайдер должен возвращать строку "Привет, Riverpod!".
// Создай виджет GreetingWidget (ConsumerWidget),
// который читает greetingProvider и отображает строку по центру экрана.
//
// Подсказка: @Riverpod(keepAlive: true), Ref, ref.watch(greetingProvider).
  GreetingProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'greetingProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$greetingHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return greeting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$greetingHash() => r'6c92a1cff45e35ac3fa749d0b6a4d7b31342969c';

@ProviderFor(Counter)
final counterProvider = CounterProvider._();

final class CounterProvider extends $NotifierProvider<Counter, int> {
  CounterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'counterProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  @$internal
  @override
  Counter create() => Counter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$counterHash() => r'8012a57a56358c9e5d1508ebed4db229c5e95509';

abstract class _$Counter extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(userName)
final userNameProvider = UserNameProvider._();

final class UserNameProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  UserNameProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userNameProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userNameHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return userName(ref);
  }
}

String _$userNameHash() => r'a02b2cf8bd328753a059f6b3debe4bc90009ddb2';

@ProviderFor(ticker)
final tickerProvider = TickerProvider._();

final class TickerProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  TickerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'tickerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$tickerHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return ticker(ref);
  }
}

String _$tickerHash() => r'248fd6200ef2b75c785cbec83c9eafd6ed45279a';

@ProviderFor(TodoList)
final todoListProvider = TodoListProvider._();

final class TodoListProvider
    extends $NotifierProvider<TodoList, List<TodoItem>> {
  TodoListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoListProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  TodoList create() => TodoList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TodoItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TodoItem>>(value),
    );
  }
}

String _$todoListHash() => r'5bf172ef62dfe375e8a9e795d89d16834ca5b7f8';

abstract class _$TodoList extends $Notifier<List<TodoItem>> {
  List<TodoItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<TodoItem>, List<TodoItem>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<TodoItem>, List<TodoItem>>,
        List<TodoItem>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchQueryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'095e33ac5976deeace76fa9d18c6dfe81daca84d';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredFruits)
final filteredFruitsProvider = FilteredFruitsProvider._();

final class FilteredFruitsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  FilteredFruitsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredFruitsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filteredFruitsHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return filteredFruits(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$filteredFruitsHash() => r'98cb685689c0b338ec32bb8cabc48b2bcdd038c5';

@ProviderFor(user)
final userProvider = UserFamily._();

final class UserProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  UserProvider._({required UserFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'userProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userHash();

  @override
  String toString() {
    return r'userProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as int;
    return user(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userHash() => r'58338a31cf4c744689ee996634cbf4caa688bf99';

final class UserFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, int> {
  UserFamily._()
      : super(
          retry: null,
          name: r'userProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UserProvider call(
    int userId,
  ) =>
      UserProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProvider';
}

@ProviderFor(randomNumber)
final randomNumberProvider = RandomNumberProvider._();

final class RandomNumberProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  RandomNumberProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'randomNumberProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$randomNumberHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return randomNumber(ref);
  }
}

String _$randomNumberHash() => r'1b27f1a59b14f2176e42c5f6fab204ff3266cca0';

@ProviderFor(Score)
final scoreProvider = ScoreProvider._();

final class ScoreProvider extends $NotifierProvider<Score, int> {
  ScoreProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scoreProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scoreHash();

  @$internal
  @override
  Score create() => Score();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$scoreHash() => r'11d0c2d5818fa4e0770b5d04f762a9b1b75b1ccb';

abstract class _$Score extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(City)
final cityProvider = CityProvider._();

final class CityProvider extends $NotifierProvider<City, String> {
  CityProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cityProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cityHash();

  @$internal
  @override
  City create() => City();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$cityHash() => r'1fdb59c2dc515a8f40acd824cee54495dad67a54';

abstract class _$City extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(weather)
final weatherProvider = WeatherProvider._();

final class WeatherProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  WeatherProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'weatherProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$weatherHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return weather(ref);
  }
}

String _$weatherHash() => r'051dc4837f9d0164f0e7209744c96402c8aacc1f';

@ProviderFor(News)
final newsProvider = NewsProvider._();

final class NewsProvider extends $AsyncNotifierProvider<News, List<String>> {
  NewsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newsHash();

  @$internal
  @override
  News create() => News();
}

String _$newsHash() => r'550c7bf03a382437cf6364785a4b8f18a26b88f2';

abstract class _$News extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<String>>, List<String>>,
        AsyncValue<List<String>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Продвинутый уровень (13–20)
// ЗАДАЧА 13
// Создай @riverpod Future<Map<String, dynamic>> product.
// С вероятностью 50% бросай Exception('Сервер недоступен'),
// иначе возвращай {'name': 'Ноутбук', 'price': 99999}.
//
// Создай ProductWidget (ConsumerWidget) с полной обработкой AsyncValue.when:
// — loading → CircularProgressIndicator
// — data    → отображение name и price
// — error   → текст ошибки + кнопка "Повторить" (ref.invalidate)
//
// Подсказка: @riverpod, Random().nextBool(), ref.invalidate(productProvider).

@ProviderFor(product)
final productProvider = ProductProvider._();

/// Продвинутый уровень (13–20)
// ЗАДАЧА 13
// Создай @riverpod Future<Map<String, dynamic>> product.
// С вероятностью 50% бросай Exception('Сервер недоступен'),
// иначе возвращай {'name': 'Ноутбук', 'price': 99999}.
//
// Создай ProductWidget (ConsumerWidget) с полной обработкой AsyncValue.when:
// — loading → CircularProgressIndicator
// — data    → отображение name и price
// — error   → текст ошибки + кнопка "Повторить" (ref.invalidate)
//
// Подсказка: @riverpod, Random().nextBool(), ref.invalidate(productProvider).

final class ProductProvider extends $FunctionalProvider<
        AsyncValue<Map<String, dynamic>>,
        Map<String, dynamic>,
        FutureOr<Map<String, dynamic>>>
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Продвинутый уровень (13–20)
// ЗАДАЧА 13
// Создай @riverpod Future<Map<String, dynamic>> product.
// С вероятностью 50% бросай Exception('Сервер недоступен'),
// иначе возвращай {'name': 'Ноутбук', 'price': 99999}.
//
// Создай ProductWidget (ConsumerWidget) с полной обработкой AsyncValue.when:
// — loading → CircularProgressIndicator
// — data    → отображение name и price
// — error   → текст ошибки + кнопка "Повторить" (ref.invalidate)
//
// Подсказка: @riverpod, Random().nextBool(), ref.invalidate(productProvider).
  ProductProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return product(ref);
  }
}

String _$productHash() => r'26417830c454d89b1e199fc50f936ee033ae9340';

@ProviderFor(AppTheme)
final appThemeProvider = AppThemeProvider._();

final class AppThemeProvider extends $NotifierProvider<AppTheme, ThemeMode> {
  AppThemeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appThemeProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appThemeHash();

  @$internal
  @override
  AppTheme create() => AppTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$appThemeHash() => r'46955fabf9d7b209a6aed7f19aa8320a629951ff';

abstract class _$AppTheme extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ThemeMode, ThemeMode>, ThemeMode, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Events)
final eventsProvider = EventsProvider._();

final class EventsProvider extends $StreamNotifierProvider<Events, List<int>> {
  EventsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eventsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventsHash();

  @$internal
  @override
  Events create() => Events();
}

String _$eventsHash() => r'2ab644a2582e127efd677a3cfad1c57530443eab';

abstract class _$Events extends $StreamNotifier<List<int>> {
  Stream<List<int>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<int>>, List<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<int>>, List<int>>,
        AsyncValue<List<int>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(timer)
final timerProvider = TimerProvider._();

final class TimerProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  TimerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'timerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$timerHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return timer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$timerHash() => r'66f67aef933c61d9cd9e8e5c63cd6c7368bd8dc5';

@ProviderFor(Auth)
final authProvider = AuthProvider._();

final class AuthProvider extends $NotifierProvider<Auth, AuthState> {
  AuthProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authHash() => r'10e941dcc8434863d50751c1741d00eeb67a55ee';

abstract class _$Auth extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AuthState, AuthState>, AuthState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(Filter)
final filterProvider = FilterProvider._();

final class FilterProvider extends $NotifierProvider<Filter, FilterType> {
  FilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filterProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filterHash();

  @$internal
  @override
  Filter create() => Filter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilterType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FilterType>(value),
    );
  }
}

String _$filterHash() => r'5c2dc46c33ba40e7dd79def72889b80462fc5d97';

abstract class _$Filter extends $Notifier<FilterType> {
  FilterType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FilterType, FilterType>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FilterType, FilterType>, FilterType, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(TodoList2)
final todoList2Provider = TodoList2Provider._();

final class TodoList2Provider
    extends $NotifierProvider<TodoList2, List<TodoItem>> {
  TodoList2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todoList2Provider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todoList2Hash();

  @$internal
  @override
  TodoList2 create() => TodoList2();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TodoItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TodoItem>>(value),
    );
  }
}

String _$todoList2Hash() => r'f9fd53ea47e20c46458ee5d9a8d9ff29de7ce71d';

abstract class _$TodoList2 extends $Notifier<List<TodoItem>> {
  List<TodoItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<TodoItem>, List<TodoItem>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<TodoItem>, List<TodoItem>>,
        List<TodoItem>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredTodo)
final filteredTodoProvider = FilteredTodoProvider._();

final class FilteredTodoProvider
    extends $FunctionalProvider<List<TodoItem>, List<TodoItem>, List<TodoItem>>
    with $Provider<List<TodoItem>> {
  FilteredTodoProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredTodoProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filteredTodoHash();

  @$internal
  @override
  $ProviderElement<List<TodoItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TodoItem> create(Ref ref) {
    return filteredTodo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TodoItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TodoItem>>(value),
    );
  }
}

String _$filteredTodoHash() => r'e514a2e476468bc63a5e764ed1895de8725a2c50';

@ProviderFor(Pagination)
final paginationProvider = PaginationProvider._();

final class PaginationProvider
    extends $NotifierProvider<Pagination, PageState> {
  PaginationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'paginationProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$paginationHash();

  @$internal
  @override
  Pagination create() => Pagination();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PageState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PageState>(value),
    );
  }
}

String _$paginationHash() => r'80d33504d0f26eb1f107b60394a3c814e8b6a1cf';

abstract class _$Pagination extends $Notifier<PageState> {
  PageState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PageState, PageState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PageState, PageState>, PageState, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(env)
final envProvider = EnvProvider._();

final class EnvProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  EnvProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'envProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$envHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return env(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$envHash() => r'895e2e3ee96e8e82e42266317145cdd7d3de3d49';
