// ignore_for_file: unused_import, unused_field
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'riverpod_task.g.dart';

// ============================================================
// 20 ЗАДАЧ ПО RIVERPOD 3 С КОДОГЕНЕРАЦИЕЙ (riverpod_annotation)
// ============================================================
// Зависимости (pubspec.yaml):
//   dependencies:
//     flutter_riverpod: ^3.3.1
//     riverpod_annotation: ^4.0.2
//   dev_dependencies:
//     riverpod_generator: ^4.0.3
//     build_runner: ^2.4.9
//
// После реализации задач запусти генерацию кода:
//   dart run build_runner build --delete-conflicting-outputs
//
// Аннотации Riverpod 3:
//   @riverpod                  — autoDispose провайдер (уничтожается без слушателей)
//   @Riverpod(keepAlive: true) — постоянный провайдер
//   Ref                        — единый тип вместо XxxRef (GreetingRef и т.п.)
//   *Provider                  — генерируется в .g.dart, не пиши Provider()/NotifierProvider вручную
// ============================================================

/// Базовый уровень (1–5)

// ЗАДАЧА 1
// Создай провайдер greeting с аннотацией @Riverpod(keepAlive: true).
// Провайдер должен возвращать строку "Привет, Riverpod!".
// Создай виджет GreetingWidget (ConsumerWidget),
// который читает greetingProvider и отображает строку по центру экрана.
//
// Подсказка: @Riverpod(keepAlive: true), Ref, ref.watch(greetingProvider).

@Riverpod(keepAlive: true)
String greeting(Ref ref) {
  return "Привет, Riverpod!";
}

class GreetingWidget extends ConsumerWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final str = ref.watch(greetingProvider);
    return Center(child: Text(str));
  }
}

// ЗАДАЧА 2
// Создай Notifier<int> с именем Counter, аннотированный @Riverpod(keepAlive: true).
// Реализуй:
//   — build() → начальное значение 0
//   — increment() → state++
//   — decrement() → state-- (не ниже 0)
// Создай виджет RiverpodCounter (ConsumerWidget):
// — отображает текущее значение
// — кнопки "+" и "−" вызывают методы нотифаера через ref.read
//
// Подсказка: extends _$Counter, counterProvider.notifier.

@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if(state > 0) state--;
  }
}

class RiverpodCounter extends ConsumerWidget {
  const RiverpodCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(counterProvider);
    return Column(
      children: [
        Text("$state"),
        Row(
          children: [
            ElevatedButton(
                onPressed: () => ref.read(counterProvider.notifier).increment(),
                child: const Text("+")),
            ElevatedButton(
                onPressed: () => ref.read(counterProvider.notifier).decrement(),
                child: const Text("-")),
          ],
        ),
      ],
    );
  }
}

// ЗАДАЧА 3
// Создай асинхронный провайдер userName с аннотацией @riverpod
// (autoDispose по умолчанию).
// Провайдер через Future.delayed(2 сек) возвращает "Иван Иванов".
// Создай виджет UserNameWidget (ConsumerWidget), который использует
// AsyncValue.when для обработки состояний loading / data / error.
//
// Подсказка: @riverpod, Future<String>, Ref,
// ref.watch(userNameProvider).when(...).

@riverpod
Future<String> userName(Ref ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Иван Иванов';
}

class UserNameWidget extends ConsumerWidget {
  const UserNameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userNameProvider).when(
        data: (data) => Text(data),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator(),),);    
  }
}

// ЗАДАЧА 4
// Создай stream-провайдер ticker с аннотацией @riverpod,
// возвращающий числа 0–9 с интервалом 1 секунда (Stream.periodic).
// Создай виджет TickerWidget (ConsumerWidget),
// который отображает текущее число потока.
//
// Подсказка: @riverpod, Stream<int>, Ref,
// ref.watch(tickerProvider).when(...).

@riverpod
Stream<int> ticker(Ref ref) {
  throw UnimplementedError();
}

class TickerWidget extends ConsumerWidget {
  const TickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 5
// Создай корневой виджет RiverpodApp (StatelessWidget),
// оборачивающий MaterialApp в ProviderScope.
// Внутри MaterialApp отображай виджет RiverpodCounter.
//
// Подсказка: ProviderScope, MaterialApp, home: RiverpodCounter().

class RiverpodApp extends StatelessWidget {
  const RiverpodApp({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

/// Средний уровень (6–12)

// ЗАДАЧА 6
// Класс TodoItem уже определён ниже.
// Создай Notifier<List<TodoItem>> с именем TodoList,
// аннотированный @Riverpod(keepAlive: true).
// Реализуй методы:
//   — build() → пустой список
//   — addTodo(String title) — добавляет элемент с уникальным id
//   — toggleTodo(int id)    — переключает done
//   — removeTodo(int id)    — удаляет элемент
// Создай виджет TodoListWidget (ConsumerWidget), отображающий список
// с CheckboxListTile и кнопкой удаления.
//
// Подсказка: extends _$TodoList, state = [...state, newItem].

class TodoItem {
  final int id;
  final String title;
  final bool done;
  const TodoItem({required this.id, required this.title, this.done = false});
  TodoItem copyWith({bool? done}) =>
      TodoItem(id: id, title: title, done: done ?? this.done);
}

@Riverpod(keepAlive: true)
class TodoList extends _$TodoList {
  @override
  List<TodoItem> build() {
    throw UnimplementedError();
  }

  void addTodo(String title) {
    throw UnimplementedError();
  }

  void toggleTodo(int id) {
    throw UnimplementedError();
  }

  void removeTodo(int id) {
    throw UnimplementedError();
  }
}

class TodoListWidget extends ConsumerWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 7
// Создай Notifier<String> SearchQuery (@Riverpod(keepAlive: true))
// для хранения поискового запроса (build() → "").
// Метод update(String query) обновляет state.
//
// Создай @riverpod Provider<List<String>> filteredFruits,
// который читает searchQueryProvider и фильтрует список:
// ['Яблоко', 'Банан', 'Апельсин', 'Арбуз', 'Абрикос', 'Груша'].
//
// Создай виджет FruitSearchWidget (ConsumerStatefulWidget)
// с TextField и ListView результатов.
//
// Подсказка: ref.watch(searchQueryProvider) внутри filteredFruitsProvider.

@Riverpod(keepAlive: true)
class SearchQuery extends _$SearchQuery {
  @override
  String build() {
    throw UnimplementedError();
  }

  void update(String query) {
    throw UnimplementedError();
  }
}

@riverpod
List<String> filteredFruits(Ref ref) {
  throw UnimplementedError();
}

class FruitSearchWidget extends ConsumerStatefulWidget {
  const FruitSearchWidget({super.key});

  @override
  ConsumerState<FruitSearchWidget> createState() => _FruitSearchWidgetState();
}

class _FruitSearchWidgetState extends ConsumerState<FruitSearchWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8
// Создай family-провайдер user с аннотацией @riverpod.
// Функция принимает (Ref ref, int userId) и возвращает
// Future<String> "Пользователь #$userId" через Future.delayed(1 сек).
//
// При наличии аргумента family-провайдер вызывается как userProvider(42).
//
// Создай виджет UserCard (ConsumerWidget), принимающий userId.
// Отображай имя или CircularProgressIndicator.
//
// Подсказка: @riverpod + параметр → family, ref.watch(userProvider(userId)).

@riverpod
Future<String> user(Ref ref, int userId) async {
  throw UnimplementedError();
}

class UserCard extends ConsumerWidget {
  final int userId;
  const UserCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9
// Создай @riverpod Future<int> randomNumber (autoDispose):
// через Future.delayed(500 мс) возвращает случайное число 1–100.
// Создай виджет RandomNumberWidget (ConsumerWidget):
// — отображает число (или загрузку)
// — кнопка "Обновить" вызывает ref.invalidate(randomNumberProvider)
//
// Подсказка: @riverpod, Random().nextInt(100) + 1, ref.invalidate.

@riverpod
Future<int> randomNumber(Ref ref) async {
  throw UnimplementedError();
}

class RandomNumberWidget extends ConsumerWidget {
  const RandomNumberWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Создай Notifier<int> Score (@Riverpod(keepAlive: true)).
// build() → 0, метод increment() → state++.
// Создай виджет ScoreListener (ConsumerWidget):
// — отображает счёт
// — кнопка "+1" вызывает increment()
// — ref.listen следит за scoreProvider и показывает
//   SnackBar "Новый рекорд!" при достижении значения >= 10
//
// Подсказка: ref.listen(scoreProvider, (prev, next) { ... }).

@Riverpod(keepAlive: true)
class Score extends _$Score {
  @override
  int build() {
    throw UnimplementedError();
  }

  void increment() {
    throw UnimplementedError();
  }
}

class ScoreListener extends ConsumerWidget {
  const ScoreListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Создай Notifier<String> City (@Riverpod(keepAlive: true)).
// build() → "Москва", метод changeCity(String city).
//
// Создай @riverpod Future<String> weather,
// который читает cityProvider внутри себя и возвращает
// "Погода в ${city}: Солнечно" через 1 сек задержки.
// При изменении cityProvider провайдер weather пересчитывается.
//
// Создай виджет WeatherWidget с кнопками городов и отображением погоды.
//
// Подсказка: ref.watch(cityProvider) внутри weatherProvider.

@Riverpod(keepAlive: true)
class City extends _$City {
  @override
  String build() {
    throw UnimplementedError();
  }

  void changeCity(String city) {
    throw UnimplementedError();
  }
}

@riverpod
Future<String> weather(Ref ref) async {
  throw UnimplementedError();
}

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 12
// Создай async-notifier News с аннотацией @riverpod (build → Future).
// build() симулирует загрузку (Future.delayed 1 сек),
// возвращает ['Новость 1', 'Новость 2', 'Новость 3'].
// Метод refresh() вызывает ref.invalidateSelf() и ждёт обновления.
//
// Создай виджет NewsWidget (ConsumerWidget):
// — показывает CircularProgressIndicator при загрузке
// — список новостей при успехе
// — кнопка "Обновить" вызывает refresh()
//
// Подсказка: extends _$News, build() → Future, ref.invalidateSelf.

@riverpod
class News extends _$News {
  @override
  Future<List<String>> build() async {
    throw UnimplementedError();
  }

  Future<void> refresh() async {
    throw UnimplementedError();
  }
}

class NewsWidget extends ConsumerWidget {
  const NewsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
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

@riverpod
Future<Map<String, dynamic>> product(Ref ref) async {
  throw UnimplementedError();
}

class ProductWidget extends ConsumerWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 14
// Создай Notifier<ThemeMode> AppTheme (@Riverpod(keepAlive: true)).
// build() → ThemeMode.light
// Метод toggle() переключает между light и dark.
//
// Создай виджет ThemedApp (ConsumerWidget), который является MaterialApp.
// themeMode берётся из appThemeProvider.
// В AppBar — IconButton с иконкой солнца/луны, вызывающий toggle().
//
// Подсказка: ref.watch(appThemeProvider), ThemeMode.dark/light.

@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  ThemeMode build() {
    throw UnimplementedError();
  }

  void toggle() {
    throw UnimplementedError();
  }
}

class ThemedApp extends ConsumerWidget {
  const ThemedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 15
// Создай StreamNotifier<List<int>> Events с аннотацией @riverpod.
// build() возвращает Stream.periodic(1 сек), который на каждом тике
// добавляет DateTime.now().millisecondsSinceEpoch в накопленный список.
//
// Создай виджет EventListWidget (ConsumerWidget),
// отображающий последние 5 меток в ListView.
//
// Подсказка: extends _$Events, StreamNotifier (codegen, autoDispose),
// Stream.periodic(..., (i) => [...state, now]).

@riverpod
class Events extends _$Events {
  @override
  Stream<List<int>> build() {
    throw UnimplementedError();
  }
}

class EventListWidget extends ConsumerWidget {
  const EventListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 16
// Создай @Riverpod(keepAlive: true) int timer(Ref ref).
// В теле провайдера используй ref.onDispose для вывода в консоль
// "timerProvider уничтожен".
// Возвращай DateTime.now().second.
//
// Создай виджет KeepAliveDemo (ConsumerStatefulWidget):
// — кнопка "Показать таймер" — показывает дочерний виджет,
//   читающий timerProvider
// — кнопка "Скрыть" — убирает виджет
// Наблюдай: при keepAlive провайдер НЕ уничтожается при скрытии.
//
// Подсказка: @Riverpod(keepAlive: true), ref.onDispose.

@Riverpod(keepAlive: true)
int timer(Ref ref) {
  throw UnimplementedError();
}

class KeepAliveDemo extends ConsumerStatefulWidget {
  const KeepAliveDemo({super.key});

  @override
  ConsumerState<KeepAliveDemo> createState() => _KeepAliveDemoState();
}

class _KeepAliveDemoState extends ConsumerState<KeepAliveDemo> {
  bool _showTimer = false;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 17
// Создай enum AuthState { guest, authenticated }.
// Создай Notifier<AuthState> Auth (@Riverpod(keepAlive: true)).
// build() → AuthState.guest
// Методы: login() и logout().
//
// Создай AuthGate (ConsumerWidget):
//   — AuthState.guest          → LoginPage  (кнопка "Войти")
//   — AuthState.authenticated  → HomePage   (кнопка "Выйти")
//
// Подсказка: ref.watch(authProvider), switch/if по AuthState.

enum AuthState { guest, authenticated }

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    throw UnimplementedError();
  }

  void login() {
    throw UnimplementedError();
  }

  void logout() {
    throw UnimplementedError();
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 18
// enum FilterType { all, active, done }
//
// Notifier<FilterType> Filter (@Riverpod(keepAlive: true)):
//   build() → FilterType.all, метод setFilter(FilterType).
//
// Notifier<List<TodoItem>> TodoList2 (@Riverpod(keepAlive: true)):
//   build() → [], методы addTodo(String), toggleTodo(int).
//
// @riverpod List<TodoItem> filteredTodo:
//   читает todoList2Provider и filterProvider,
//   возвращает отфильтрованный список.
//
// Создай FilteredTodoWidget (ConsumerWidget):
//   — кнопки фильтра "Все" / "Активные" / "Выполненные" в AppBar
//   — ListView отфильтрованных задач
//
// Подсказка: несколько ref.watch внутри одного провайдера.

enum FilterType { all, active, done }

@Riverpod(keepAlive: true)
class Filter extends _$Filter {
  @override
  FilterType build() {
    throw UnimplementedError();
  }

  void setFilter(FilterType filter) {
    throw UnimplementedError();
  }
}

@Riverpod(keepAlive: true)
class TodoList2 extends _$TodoList2 {
  @override
  List<TodoItem> build() {
    throw UnimplementedError();
  }

  void addTodo(String title) {
    throw UnimplementedError();
  }

  void toggleTodo(int id) {
    throw UnimplementedError();
  }
}

@riverpod
List<TodoItem> filteredTodo(Ref ref) {
  throw UnimplementedError();
}

class FilteredTodoWidget extends ConsumerWidget {
  const FilteredTodoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 19
// Класс PageState уже определён ниже.
// Создай Notifier<PageState> Pagination (@Riverpod(keepAlive: true)).
// build() → PageState(items: [], isLoading: false)
// Метод loadNextPage():
//   1. state = state.copyWith(isLoading: true)
//   2. await Future.delayed(500 мс)
//   3. добавляет 5 элементов вида "Элемент N"
//   4. state = state.copyWith(items: [...], isLoading: false)
//
// Создай виджет PaginatedList (ConsumerWidget):
//   — ListView с элементами
//   — кнопка "Загрузить ещё" (ElevatedButton, неактивна при isLoading)
//
// Подсказка: state.copyWith(...), state = newState.

class PageState {
  final List<String> items;
  final bool isLoading;
  const PageState({required this.items, this.isLoading = false});
  PageState copyWith({List<String>? items, bool? isLoading}) => PageState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
      );
}

@Riverpod(keepAlive: true)
class Pagination extends _$Pagination {
  @override
  PageState build() {
    throw UnimplementedError();
  }

  Future<void> loadNextPage() async {
    throw UnimplementedError();
  }
}

class PaginatedList extends ConsumerWidget {
  const PaginatedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 20
// Создай @Riverpod(keepAlive: true) String env(Ref ref),
// возвращающий "Production".
//
// Создай виджет EnvBanner (ConsumerWidget):
// — отображает значение envProvider в цветном контейнере
//   (зелёный для "Production", оранжевый для "Development")
//
// Создай OverrideDemo (StatelessWidget):
// — отображает два ProviderScope одновременно:
//   1. обычный (без override) → "Production"
//   2. с ProviderScope(overrides: [envProvider.overrideWithValue('Development')])
//      → "Development"
//
// Подсказка: ProviderScope.overrides, envProvider.overrideWithValue.

@Riverpod(keepAlive: true)
String env(Ref ref) {
  throw UnimplementedError();
}

class EnvBanner extends ConsumerWidget {
  const EnvBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}

class OverrideDemo extends StatelessWidget {
  const OverrideDemo({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
