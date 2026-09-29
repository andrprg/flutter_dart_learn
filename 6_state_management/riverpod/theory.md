# Шпаргалка: Riverpod 3 (codegen)

Riverpod — DI + реактивное состояние без обязательного `BuildContext` для чтения. В модуле — **аннотации** (`riverpod_annotation`) и генерация `*Provider` в `.g.dart`. Практика: `riverpod_task.dart` (после правок: `dart run build_runner build --delete-conflicting-outputs`).

## 1. Корневой scope

```dart
void main() => runApp(const ProviderScope(child: MyApp()));
```

Без `ProviderScope` провайдеры не живут. В тестах — `ProviderContainer` / `ProviderScope(overrides: ...)`.

## 2. Аннотации

| Аннотация | Поведение |
|---|---|
| `@riverpod` | autoDispose: без слушателей state сбрасывается |
| `@Riverpod(keepAlive: true)` | живёт постоянно (кэш, сессия, тема) |

```dart
@Riverpod(keepAlive: true)
String greeting(Ref ref) => 'Привет, Riverpod!';
// → greetingProvider

@riverpod
Future<String> userName(Ref ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Иван Иванов';
}
// → userNameProvider (AsyncValue)
```

В Riverpod 3 единый тип `Ref` (не `GreetingRef`). Провайдеры **не пиши вручную** — только codegen.

## 3. watch / read / listen

```dart
// rebuild при изменении
final count = ref.watch(counterProvider);

// разово в колбэке (кнопка) — без подписки
onPressed: () => ref.read(counterProvider.notifier).increment(),

// side effect (SnackBar), не в «чистом» выражении build-логики
ref.listen(scoreProvider, (prev, next) {
  if (next >= 10) { /* SnackBar */ }
});
```

Правило: **watch** в UI для данных, **read** для действий, **listen** для эффектов.

## 4. Notifier / Async / Stream

```dart
@Riverpod(keepAlive: true)
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}

@riverpod
class News extends _$News {
  @override
  Future<List<String>> build() async { /* load */ }
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class Events extends _$Events {
  @override
  Stream<List<int>> build() { /* Stream.periodic... */ }
}
```

| Тип | Когда |
|---|---|
| `Notifier` | синхронный state + методы |
| Async (`Future` / AsyncNotifier) | загрузка / ошибка → `AsyncValue` |
| `StreamNotifier` | источник — поток |

UI: `ref.watch(x).when(data:, error:, loading:)`.

## 5. Зависимости и family

```dart
@Riverpod(keepAlive: true)
class City extends _$City {
  @override
  String build() => 'Москва';
  void changeCity(String city) => state = city;
}

@riverpod
Future<String> weather(Ref ref) async {
  final city = ref.watch(cityProvider); // пересчёт при смене города
  await Future.delayed(const Duration(seconds: 1));
  return 'Погода в $city: Солнечно';
}

@riverpod
Future<String> user(Ref ref, int userId) async {
  return 'Пользователь #$userId';
}
// ref.watch(userProvider(42))
```

Derived-провайдеры (`filteredFruits`, `filteredTodo`) только **читают** и фильтруют — один source of truth.

## 6. invalidate / override / lifecycle

```dart
ref.invalidate(randomNumberProvider); // перезапуск

ProviderScope(
  overrides: [
    envProvider.overrideWithValue('Development'),
  ],
  child: const EnvBanner(),
);

@Riverpod(keepAlive: true)
int timer(Ref ref) {
  ref.onDispose(() => print('timerProvider уничтожен'));
  return DateTime.now().second;
}
```

`build` провайдера держи **чистым** (без «тихой» сети с side effects); сеть — в async `build` / методах notifier.

## 7. Виджеты

- `ConsumerWidget` / `ConsumerStatefulWidget` — доступ к `WidgetRef`.
- `AuthGate` по `AuthState`, тема через `ThemeMode` notifier, пагинация — `state.copyWith`.

## 8. Вопросы с собеса (кратко)

1. Provider vs Riverpod? — compile-safe, без context для read, codegen/тесты.
2. watch/read/listen? — подписка / разово / эффекты.
3. Notifier? — `build` + методы; Async — Future → AsyncValue.
4. autoDispose? — сброс без слушателей; keepAlive — не сбрасывать.
5. Family? — `provider(id)`.
6. Override? — тесты и альтернативные реализации.
7. Side effects в build? — нет.
8. Аннотации? — `@riverpod` / keepAlive → `*Provider`.

Дальше: `fpdart_riverpod/` — связать `TaskEither` с `AsyncValue`.
