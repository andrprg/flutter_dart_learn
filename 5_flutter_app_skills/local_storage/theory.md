# Шпаргалка: Локальное хранилище

На мобиле три типичных уровня: **SharedPreferences** (key-value), **secure storage** (токены в Keychain/Keystore), **БД** (sqlite / drift / hive — структуры и запросы). Модуль учит key-value слой на абстракции `KeyValueStore` (в тестах — `MemoryStore`).

Перед задачами прочитай этот файл, затем решай `storage_task.dart`.

## 1. Что куда класть

| Данные | Куда |
|---|---|
| Тема, locale, onboarding flag | prefs / key-value |
| Access / refresh token | secure storage |
| Лента, кэш сущностей | БД / файлы |

В prefs **нельзя** хранить секреты «как есть»: XML/plist читается на rooted/jailbroken и в бэкапах.

Типы prefs: `String`, `bool`, `int`, `double`, `List<String>`. Объекты — через JSON-строку.

## 2. Ключи и токен

```dart
String authTokenKey() => 'auth_token';

Future<void> saveAuthToken(KeyValueStore store, String token) async {
  if (token.isEmpty) throw ArgumentError('token empty');
  await store.setString(authTokenKey(), token);
}

Future<void> clearAuthToken(KeyValueStore store) async {
  await store.remove(authTokenKey());
}
```

Logout = удалить токен (+ при необходимости clear чувствительных ключей), не «оставить до следующего запуска».

## 3. Настройки как JSON

```dart
Map<String, dynamic> toJson() => {
  'themeMode': themeMode,
  'localeCode': localeCode,
  'notificationsEnabled': notificationsEnabled,
};

Future<void> saveUserSettings(KeyValueStore store, UserSettings s) async {
  await store.setString(userSettingsKey(), jsonEncode(s.toJson()));
}

Future<UserSettings> loadUserSettings(KeyValueStore store) async {
  final raw = await store.getString(userSettingsKey());
  if (raw == null) return UserSettings.defaults;
  return UserSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
```

Нет ключа → defaults, не exception.

## 4. Миграции ключей

Переименовал ключ — один раз перенеси данные:

```dart
Future<void> migrateAuthTokenKey(KeyValueStore store) async {
  const oldKey = 'token';
  if (!await store.containsKey(oldKey)) return;
  final value = await store.getString(oldKey);
  if (value != null) await store.setString(authTokenKey(), value);
  await store.remove(oldKey);
}
```

Версию схемы можно хранить отдельным int-ключом.

## 5. Isolates и prefs

`SharedPreferences` — платформенный канал; не считай его «обычной Map» из любого isolate. Обычно работай из main isolate; для тяжёлого JSON — парси в isolate, а get/set оставляй на UI-потоке.

## 6. Тестирование

Подмени store на `MemoryStore` — без плагинов и файлов. Проверяй save → load → clear и миграцию.

## 7. Зачем это знать

- prefs ≠ secure ≠ DB — разные угрозы и объёмы.
- Секреты не в prefs; на logout чисти.
- Сложные объекты — JSON + defaults + миграции.
- Тесты через абстракцию `KeyValueStore`.

Дальше по маршруту: `storage_task.dart` → `interview_questions.md`.
