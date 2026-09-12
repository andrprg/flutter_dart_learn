# Тесты к задачам с собеседований

Каждый тест соответствует задаче из родительской папки `sobes_tasks/`.

## Структура файлов

| Файл теста | Задача | Тип | Команда запуска |
|---|---|---|---|
| `test_01_palindrome_test.dart` | Палиндром | `dart test` | `dart test sobes_tasks/tests/test_01_palindrome_test.dart` |
| `test_02_fizzbuzz_test.dart` | FizzBuzz | `dart test` | `dart test sobes_tasks/tests/test_02_fizzbuzz_test.dart` |
| `test_03_anagram_test.dart` | Анаграмма | `dart test` | `dart test sobes_tasks/tests/test_03_anagram_test.dart` |
| `test_04_two_sum_test.dart` | Two Sum | `dart test` | `dart test sobes_tasks/tests/test_04_two_sum_test.dart` |
| `test_05_linked_list_test.dart` | Связный список | `dart test` | `dart test sobes_tasks/tests/test_05_linked_list_test.dart` |
| `test_06_async_future_test.dart` | Async/Future | `dart test` | `dart test sobes_tasks/tests/test_06_async_future_test.dart` |
| `test_07_repository_test.dart` | Repository | `dart test` | `dart test sobes_tasks/tests/test_07_repository_test.dart` |
| `test_08_streams_test.dart` | Streams | `dart test` | `dart test sobes_tasks/tests/test_08_streams_test.dart` |
| `test_09_isolates_test.dart` | Isolates | `dart test` | `dart test sobes_tasks/tests/test_09_isolates_test.dart` |
| `test_10_mixins_extensions_test.dart` | Mixins/Extensions | `dart test` | `dart test sobes_tasks/tests/test_10_mixins_extensions_test.dart` |
| `test_11_stateful_counter_test.dart` | StatefulWidget | `flutter test` | `flutter test sobes_tasks/tests/test_11_stateful_counter_test.dart` |
| `test_12_inherited_widget_test.dart` | InheritedWidget | `flutter test` | `flutter test sobes_tasks/tests/test_12_inherited_widget_test.dart` |
| `test_13_custom_painter_test.dart` | CustomPainter | `flutter test` | `flutter test sobes_tasks/tests/test_13_custom_painter_test.dart` |
| `test_14_animations_test.dart` | Анимации | `flutter test` | `flutter test sobes_tasks/tests/test_14_animations_test.dart` |
| `test_15_navigation_test.dart` | Навигация | `flutter test` | `flutter test sobes_tasks/tests/test_15_navigation_test.dart` |
| `test_16_riverpod_test.dart` | Riverpod | `flutter test` | `flutter test sobes_tasks/tests/test_16_riverpod_test.dart` |
| `test_17_performance_test.dart` | Производительность | `flutter test` | `flutter test sobes_tasks/tests/test_17_performance_test.dart` |
| `test_18_cart_service_test.dart` | Testing (Cart+Login) | `flutter test` | `flutter test sobes_tasks/tests/test_18_cart_service_test.dart` |
| `test_19_riverpod_annotations_test.dart` | Riverpod + аннотации | `flutter test` | `flutter test sobes_tasks/tests/test_19_riverpod_annotations_test.dart` |
| `test_20_platform_channels_test.dart` | Platform Channels | `flutter test` | `flutter test sobes_tasks/tests/test_20_platform_channels_test.dart` |
| `test_21_json_models_test.dart` | JSON models | `dart test` | `dart test sobes_tasks/tests/test_21_json_models_test.dart` |
| `test_22_lru_cache_test.dart` | LRU Cache | `dart test` | `dart test sobes_tasks/tests/test_22_lru_cache_test.dart` |

## Запуск всех тестов

```bash
# Все тесты (из корня проекта)
flutter test sobes_tasks/tests/

# Только Dart тесты (01-10)
dart test sobes_tasks/tests/test_01_palindrome_test.dart
dart test sobes_tasks/tests/test_02_fizzbuzz_test.dart
# ... и т.д.

# Только Flutter тесты (11-20)
flutter test sobes_tasks/tests/test_11_stateful_counter_test.dart
```

## Как использовать тесты

1. Открой задачу (например `task_01_palindrome.dart`)
2. Реализуй функцию в секции `// ─── Ваше решение ───`
3. Запусти соответствующий тест — он должен пройти
4. Тесты самодостаточны: реализация скопирована из эталонных решений

## Статистика тестов

| Задача | Количество тестов |
|--------|-------------------|
| 01 Palindrome | 14 |
| 02 FizzBuzz | 16 |
| 03 Anagram | 15 |
| 04 Two Sum | 11 |
| 05 Linked List | 16 |
| 06 Async/Future | 12 |
| 07 Repository | 16 |
| 08 Streams | 16 |
| 09 Isolates | 15 |
| 10 Mixins/Extensions | 29 |
| 11 StatefulWidget | 9 |
| 12 InheritedWidget | 11 |
| 13 CustomPainter | 10 |
| 14 Animations | 10 |
| 15 Navigation | 12 |
| 16 Riverpod | 17 |
| 17 Performance | 9 |
| 18 Cart+Login | 19 |
| 19 Riverpod аннотации | ~21 |
| 20 Platform Channels | 14 |
| 21 JSON models | 8 |
| 22 LRU Cache | 5 |
| **Итого** | **~288 тестов** |
