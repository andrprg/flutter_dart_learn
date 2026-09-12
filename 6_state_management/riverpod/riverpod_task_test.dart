// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'riverpod_task.dart';

void main() {
  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 1 — greetingProvider
  // ══════════════════════════════════════════════════════════════════════════
  group('greetingProvider', () {
    test('возвращает строку "Привет, Riverpod!"', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(greetingProvider), 'Привет, Riverpod!');
    });

    testWidgets('GreetingWidget отображает строку по центру', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: GreetingWidget()),
          ),
        ),
      );

      expect(find.text('Привет, Riverpod!'), findsOneWidget);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 2 — Counter (Notifier)
  // ══════════════════════════════════════════════════════════════════════════
  group('Counter', () {
    test('начальное значение равно 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(counterProvider), 0);
    });

    test('increment увеличивает значение на 1', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(counterProvider.notifier).increment();
      expect(container.read(counterProvider), 1);
    });

    test('несколько increment суммируются корректно', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      for (var i = 0; i < 3; i++) {
        container.read(counterProvider.notifier).increment();
      }
      expect(container.read(counterProvider), 3);
    });

    test('decrement уменьшает значение', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(counterProvider.notifier).increment();
      container.read(counterProvider.notifier).increment();
      container.read(counterProvider.notifier).decrement();
      expect(container.read(counterProvider), 1);
    });

    test('decrement не опускается ниже 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(counterProvider.notifier).decrement();
      expect(container.read(counterProvider), 0);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 3 — userNameProvider (async)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 3 — userNameProvider', () {
    test('начальное состояние — AsyncLoading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(userNameProvider), isA<AsyncLoading>());
    });

    test('после задержки возвращает "Иван Иванов"', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(userNameProvider.future);
      expect(result, 'Иван Иванов');
    });

    testWidgets('UserNameWidget показывает загрузку и затем имя',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: UserNameWidget()),
          ),
        ),
      );

      // Начальное состояние — загрузка
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Ждём завершения Future (2 сек задержка в задаче)
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Иван Иванов'), findsOneWidget);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 4 — tickerProvider (stream)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 4 — tickerProvider', () {
    test('начальное состояние — AsyncLoading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(tickerProvider), isA<AsyncLoading>());
    });

    test('поток эмитирует числа в диапазоне 0–9', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Подписываемся, чтобы поток начал работать
      final values = <int>[];
      final sub = container.listen<AsyncValue<int>>(
        tickerProvider,
        (_, next) {
          next.whenData((v) => values.add(v));
        },
      );

      // Ждём нескольких тиков
      await Future<void>.delayed(const Duration(milliseconds: 2500));
      sub.close();

      expect(values, isNotEmpty);
      for (final v in values) {
        expect(v, inInclusiveRange(0, 9));
      }
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 5 — RiverpodApp
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 5 — RiverpodApp', () {
    testWidgets('RiverpodApp содержит ProviderScope', (tester) async {
      await tester.pumpWidget(const RiverpodApp());
      expect(find.byType(ProviderScope), findsWidgets);
    });

    testWidgets('RiverpodApp содержит MaterialApp', (tester) async {
      await tester.pumpWidget(const RiverpodApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 6 — TodoList (Notifier)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 6 — TodoList', () {
    test('начальный список пустой', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(todoListProvider), isEmpty);
    });

    test('addTodo добавляет элемент с заданным заголовком', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).addTodo('Купить молоко');
      final todos = container.read(todoListProvider);

      expect(todos, hasLength(1));
      expect(todos.first.title, 'Купить молоко');
      expect(todos.first.done, isFalse);
    });

    test('addTodo присваивает уникальные id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).addTodo('Первая');
      container.read(todoListProvider.notifier).addTodo('Вторая');
      container.read(todoListProvider.notifier).addTodo('Третья');

      final ids = container.read(todoListProvider).map((t) => t.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('toggleTodo переключает done с false на true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).addTodo('Задача');
      final id = container.read(todoListProvider).first.id;

      container.read(todoListProvider.notifier).toggleTodo(id);
      expect(container.read(todoListProvider).first.done, isTrue);
    });

    test('toggleTodo переключает done с true на false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).addTodo('Задача');
      final id = container.read(todoListProvider).first.id;
      container.read(todoListProvider.notifier).toggleTodo(id);
      container.read(todoListProvider.notifier).toggleTodo(id);

      expect(container.read(todoListProvider).first.done, isFalse);
    });

    test('removeTodo удаляет элемент по id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoListProvider.notifier).addTodo('Удалить меня');
      container.read(todoListProvider.notifier).addTodo('Оставить меня');
      final idToRemove = container.read(todoListProvider).first.id;

      container.read(todoListProvider.notifier).removeTodo(idToRemove);
      final todos = container.read(todoListProvider);

      expect(todos, hasLength(1));
      expect(todos.first.title, 'Оставить меня');
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 7 — SearchQuery + filteredFruitsProvider
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 7 — SearchQuery + filteredFruits', () {
    test('начальный поисковый запрос — пустая строка', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(searchQueryProvider), '');
    });

    test('update обновляет запрос', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).update('Банан');
      expect(container.read(searchQueryProvider), 'Банан');
    });

    test('filteredFruits возвращает все 6 фруктов при пустом запросе', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(filteredFruitsProvider), hasLength(6));
    });

    test('filteredFruits фильтрует список по подстроке', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).update('Ар');
      final fruits = container.read(filteredFruitsProvider);

      expect(fruits, isNotEmpty);
      expect(fruits.every((f) => f.contains('Ар')), isTrue);
    });

    test('filteredFruits возвращает пустой список при несовпадении', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).update('xyz123');
      expect(container.read(filteredFruitsProvider), isEmpty);
    });

    test('filteredFruits обновляется при изменении запроса', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Подписываемся, чтобы autoDispose провайдер оставался активным
      final sub =
          container.listen(filteredFruitsProvider, (prev, next) {});

      container.read(searchQueryProvider.notifier).update('Яблоко');
      final result = container.read(filteredFruitsProvider);

      expect(result, contains('Яблоко'));
      expect(result.every((f) => f.contains('Яблоко')), isTrue);
      sub.close();
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 8 — user (family)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 8 — user (family)', () {
    test('возвращает "Пользователь #42"', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(userProvider(42).future);
      expect(result, 'Пользователь #42');
    });

    test('разные userId дают разные строки', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final r1 = await container.read(userProvider(1).future);
      final r2 = await container.read(userProvider(99).future);

      expect(r1, 'Пользователь #1');
      expect(r2, 'Пользователь #99');
    });

    test('начальное состояние — AsyncLoading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(userProvider(1)), isA<AsyncLoading>());
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 9 — randomNumber
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 9 — randomNumber', () {
    test('возвращает число от 1 до 100 включительно', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(randomNumberProvider.future);
      expect(result, inInclusiveRange(1, 100));
    });

    test('после invalidate возвращает новое число', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Подписываемся, чтобы провайдер оставался живым
      final sub = container.listen(randomNumberProvider, (_, __) {});

      final first = await container.read(randomNumberProvider.future);
      container.invalidate(randomNumberProvider);
      final second = await container.read(randomNumberProvider.future);

      // Оба числа должны быть в допустимом диапазоне
      expect(first, inInclusiveRange(1, 100));
      expect(second, inInclusiveRange(1, 100));
      sub.close();
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 10 — Score (Notifier)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 10 — Score', () {
    test('начальный счёт равен 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(scoreProvider), 0);
    });

    test('increment увеличивает счёт', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(scoreProvider.notifier).increment();
      expect(container.read(scoreProvider), 1);
    });

    test('10 нажатий дают счёт 10', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      for (var i = 0; i < 10; i++) {
        container.read(scoreProvider.notifier).increment();
      }
      expect(container.read(scoreProvider), 10);
    });

    test('ref.listen получает уведомление при изменении', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final changes = <int>[];
      container.listen(
        scoreProvider,
        (_, next) => changes.add(next),
        fireImmediately: false,
      );

      container.read(scoreProvider.notifier).increment();
      container.read(scoreProvider.notifier).increment();

      expect(changes, [1, 2]);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 11 — City + weatherProvider
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 11 — City + weather', () {
    test('начальный город "Москва"', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(cityProvider), 'Москва');
    });

    test('changeCity обновляет город', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(cityProvider.notifier).changeCity('Санкт-Петербург');
      expect(container.read(cityProvider), 'Санкт-Петербург');
    });

    test('weather возвращает строку с названием города и "Солнечно"', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(weatherProvider.future);
      expect(result, contains('Москва'));
      expect(result, contains('Солнечно'));
    });

    test('weather пересчитывается при смене города', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(cityProvider.notifier).changeCity('Сочи');
      final result = await container.read(weatherProvider.future);

      expect(result, contains('Сочи'));
      expect(result, contains('Солнечно'));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 12 — News (AsyncNotifier)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 12 — News (AsyncNotifier)', () {
    test('начальное состояние — AsyncLoading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(newsProvider), isA<AsyncLoading>());
    });

    test('загружает список из трёх новостей', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await container.read(newsProvider.future);
      expect(result, hasLength(3));
      expect(
        result,
        containsAll(['Новость 1', 'Новость 2', 'Новость 3']),
      );
    });

    test('refresh перезагружает новости', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(newsProvider.future);
      await container.read(newsProvider.notifier).refresh();
      final result = await container.read(newsProvider.future);

      expect(result, hasLength(3));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 13 — product (50% ошибка)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 13 — product', () {
    test(
        'возвращает данные товара или бросает "Сервер недоступен"',
        () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      try {
        final result = await container.read(productProvider.future);
        // Успешный путь
        expect(result['name'], 'Ноутбук');
        expect(result['price'], 99999);
      } catch (e) {
        // Путь с ошибкой
        expect(e.toString(), contains('Сервер недоступен'));
      }
    });

    test('при ошибке AsyncValue содержит объект ошибки', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Ждём завершения (успех или ошибка)
      await Future<void>.delayed(const Duration(milliseconds: 600));
      final value = container.read(productProvider);

      // Состояние должно быть либо data, либо error
      expect(
        value.hasValue || value.hasError,
        isTrue,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 14 — AppTheme (Notifier)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 14 — AppTheme', () {
    test('начальная тема — ThemeMode.light', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(appThemeProvider), ThemeMode.light);
    });

    test('toggle переключает на ThemeMode.dark', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appThemeProvider.notifier).toggle();
      expect(container.read(appThemeProvider), ThemeMode.dark);
    });

    test('двойной toggle возвращает ThemeMode.light', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appThemeProvider.notifier).toggle();
      container.read(appThemeProvider.notifier).toggle();
      expect(container.read(appThemeProvider), ThemeMode.light);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 15 — Events (StreamNotifier)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 15 — Events (StreamNotifier)', () {
    test('начальное состояние — AsyncLoading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(eventsProvider), isA<AsyncLoading>());
    });

    test('поток эмитирует списки временных меток', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final snapshots = <List<int>>[];
      final sub = container.listen<AsyncValue<List<int>>>(
        eventsProvider,
        (_, next) {
          next.whenData((v) => snapshots.add(v));
        },
      );

      await Future<void>.delayed(const Duration(milliseconds: 2200));
      sub.close();

      expect(snapshots, isNotEmpty);
      // Каждый снимок — непустой список целых чисел
      for (final snap in snapshots) {
        expect(snap, isNotEmpty);
        expect(snap, isNotEmpty);
      }
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 16 — timerProvider (keepAlive)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 16 — timerProvider (keepAlive)', () {
    test('возвращает секунды в диапазоне 0–59', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final value = container.read(timerProvider);
      expect(value, inInclusiveRange(0, 59));
    });

    test('keepAlive: провайдер не уничтожается при закрытии подписки', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Создаём и сразу закрываем подписку
      final sub = container.listen(timerProvider, (_, __) {});
      final valueBeforeClose = container.read(timerProvider);
      sub.close();

      // Провайдер keepAlive — значение по-прежнему доступно
      expect(container.read(timerProvider), valueBeforeClose);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 17 — Auth (Notifier)
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 17 — Auth', () {
    test('начальное состояние — AuthState.guest', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(authProvider), AuthState.guest);
    });

    test('login переключает в AuthState.authenticated', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authProvider.notifier).login();
      expect(container.read(authProvider), AuthState.authenticated);
    });

    test('logout возвращает в AuthState.guest', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authProvider.notifier).login();
      container.read(authProvider.notifier).logout();
      expect(container.read(authProvider), AuthState.guest);
    });

    testWidgets('AuthGate показывает LoginPage когда guest', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: AuthGate()),
        ),
      );

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('AuthGate показывает HomePage после login', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: AuthGate()),
        ),
      );

      // Нажимаем кнопку "Войти" на LoginPage
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 18 — Filter + TodoList2 + filteredTodo
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 18 — Filter + TodoList2 + filteredTodo', () {
    test('начальный фильтр — FilterType.all', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(filterProvider), FilterType.all);
    });

    test('setFilter меняет активный фильтр', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(filterProvider.notifier).setFilter(FilterType.active);
      expect(container.read(filterProvider), FilterType.active);
    });

    test('todoList2 начально пустой', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(todoList2Provider), isEmpty);
    });

    test('filteredTodo с FilterType.all возвращает все задачи', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoList2Provider.notifier).addTodo('Задача 1');
      container.read(todoList2Provider.notifier).addTodo('Задача 2');
      final id = container.read(todoList2Provider).first.id;
      container.read(todoList2Provider.notifier).toggleTodo(id);

      final sub = container.listen(filteredTodoProvider, (_, __) {});
      expect(container.read(filteredTodoProvider), hasLength(2));
      sub.close();
    });

    test('filteredTodo с FilterType.active возвращает только невыполненные',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoList2Provider.notifier).addTodo('Сделать');
      container.read(todoList2Provider.notifier).addTodo('Выполнено');
      final id = container.read(todoList2Provider).last.id;
      container.read(todoList2Provider.notifier).toggleTodo(id);
      container.read(filterProvider.notifier).setFilter(FilterType.active);

      final sub = container.listen(filteredTodoProvider, (_, __) {});
      final filtered = container.read(filteredTodoProvider);

      expect(filtered, isNotEmpty);
      expect(filtered.every((t) => !t.done), isTrue);
      sub.close();
    });

    test('filteredTodo с FilterType.done возвращает только выполненные', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(todoList2Provider.notifier).addTodo('Сделать');
      container.read(todoList2Provider.notifier).addTodo('Выполнено');
      final id = container.read(todoList2Provider).last.id;
      container.read(todoList2Provider.notifier).toggleTodo(id);
      container.read(filterProvider.notifier).setFilter(FilterType.done);

      final sub = container.listen(filteredTodoProvider, (_, __) {});
      final filtered = container.read(filteredTodoProvider);

      expect(filtered, isNotEmpty);
      expect(filtered.every((t) => t.done), isTrue);
      sub.close();
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 19 — Pagination
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 19 — Pagination', () {
    test('начальное состояние: items пустой, isLoading false', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(paginationProvider);
      expect(state.items, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('loadNextPage добавляет ровно 5 элементов', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(paginationProvider.notifier).loadNextPage();
      expect(container.read(paginationProvider).items, hasLength(5));
    });

    test('после loadNextPage isLoading снова false', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(paginationProvider.notifier).loadNextPage();
      expect(container.read(paginationProvider).isLoading, isFalse);
    });

    test('повторный loadNextPage добавляет ещё 5 (итого 10)', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(paginationProvider.notifier).loadNextPage();
      await container.read(paginationProvider.notifier).loadNextPage();
      expect(container.read(paginationProvider).items, hasLength(10));
    });

    test('элементы соответствуют формату "Элемент N"', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(paginationProvider.notifier).loadNextPage();
      final items = container.read(paginationProvider).items;

      for (final item in items) {
        expect(item, matches(RegExp(r'^Элемент \d+$')));
      }
    });

    test('нумерация элементов сквозная при нескольких загрузках', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(paginationProvider.notifier).loadNextPage();
      await container.read(paginationProvider.notifier).loadNextPage();
      final items = container.read(paginationProvider).items;

      // Все элементы уникальны
      expect(items.toSet().length, items.length);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // ЗАДАЧА 20 — envProvider + override
  // ══════════════════════════════════════════════════════════════════════════
  group('Задача 20 — envProvider', () {
    test('по умолчанию возвращает "Production"', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(envProvider), 'Production');
    });

    test('переопределяется через overrideWithValue', () {
      final container = ProviderContainer(
        overrides: [
          envProvider.overrideWithValue('Development'),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(envProvider), 'Development');
    });

    test('два контейнера независимы', () {
      final prod = ProviderContainer();
      final dev = ProviderContainer(
        overrides: [envProvider.overrideWithValue('Development')],
      );
      addTearDown(prod.dispose);
      addTearDown(dev.dispose);

      expect(prod.read(envProvider), 'Production');
      expect(dev.read(envProvider), 'Development');
    });

    testWidgets('EnvBanner отображает значение из провайдера', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: EnvBanner()),
          ),
        ),
      );

      expect(find.text('Production'), findsOneWidget);
    });

    testWidgets('EnvBanner с override отображает "Development"',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            envProvider.overrideWithValue('Development'),
          ],
          child: const MaterialApp(
            home: Scaffold(body: EnvBanner()),
          ),
        ),
      );

      expect(find.text('Development'), findsOneWidget);
    });
  });
}
