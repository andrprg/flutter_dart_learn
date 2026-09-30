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

## 7. Когда запись реально на диске

`SharedPreferences.setString` возвращает `Future`, который завершается после записи платформенного хранилища, но кэш в памяти плагин держит отдельно. Читать сразу после `await set` в том же процессе нормально. Не читай ключ «в обход» с диска своими средствами и не жди, что другой isolate увидел запись мгновенно.

Прерванный процесс посередине `setString` может оставить старое значение. Для флага «онбординг пройден» это терпимо. Для пачки связанных ключей («токен + userId») лучше одна JSON-строка: она появляется целиком, не «токен новый, userId старый».

`secure storage` (Keychain / EncryptedSharedPreferences / Keystore) дороже и уместен для токена. Его не читают на каждый кадр. Схема: при старте прочитал в память, дальше работаешь с полем, на logout затираешь и память, и хранилище.

Бэкап Android может утащить prefs в облако. Секрет в prefs утекает с бэкапом даже без root. У secure storage другие правила бэкапа, поэтому токен живёт там.

## 8. Версия схемы

Один int `schema_version`. На старте:

```dart
Future<void> migrate(KeyValueStore store) async {
  final version = await store.getInt('schema_version') ?? 0;
  if (version < 1) {
    await migrateAuthTokenKey(store);
    await store.setInt('schema_version', 1);
  }
}
```

Миграции идут по порядку, каждый шаг идемпотентен: повторный запуск после падения на шаге 2 не должен портить шаг 1. Старый ключ удаляй **после** успешной записи нового. Обратная совместимость: новая версия приложения умеет прочитать данные старой. Старая версия после отката может не понять новый JSON — не ломай поля молча, держи дефолт, если `fromJson` не узнал формат.

`remove` несуществующего ключа — не ошибка. `containsKey` перед миграцией обязателен, чтобы не затереть новый ключ пустым чтением.

Большие объекты (лента на тысячи строк) в одну prefs-строку упрутся в лимиты и будут парситься на UI-isolate целиком. Это уже файл или БД.

## 9. Типичные ошибки

- Ключ без префикса приложения: `token` сталкивается по смыслу с чужим модулем. Имя `auth.token` или константа в одном месте.
- Хранить `ThemeMode` строкой и не обработать неизвестное значение после отката версии — падение `firstWhere`.
- Считать память процесса хранилищем. Убили приложение — несохранённый черновик пропал. Момент записи решает lifecycle, не `dispose` виджета.
- Логировать значение secure storage в debug-принте на каждый старт.
- Тест на настоящих prefs без `setMockInitialValues` — флак и зависимость от устройства. `MemoryStore` или мок.

## 10. Зачем это знать

- prefs ≠ secure ≠ DB — разные угрозы и объёмы.
- Секреты не в prefs; на logout чисти.
- Сложные объекты — JSON + defaults + миграции.
- Тесты через абстракцию `KeyValueStore`.

Дальше по маршруту: `storage_task.dart` → `interview_questions.md`.
