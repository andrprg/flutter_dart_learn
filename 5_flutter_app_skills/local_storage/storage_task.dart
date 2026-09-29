// ============================================================
// 12 ЗАДАЧ ПО ЛОКАЛЬНОМУ ХРАНИЛИЩУ
// ============================================================
// Цель: освоить key-value storage (аналог SharedPreferences),
// типизированные get/set, JSON-сериализацию настроек и миграции ключей.

/// Контракт простого key-value хранилища.
abstract class KeyValueStore {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

/// In-memory реализация для тестов и обучения.
class MemoryStore implements KeyValueStore {
  final Map<String, Object> _data = {};

  @override
  Future<void> setString(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<String?> getString(String key) async {
    final value = _data[key];
    return value is String ? value : null;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    _data[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = _data[key];
    return value is bool ? value : null;
  }

  @override
  Future<void> setInt(String key, int value) async {
    _data[key] = value;
  }

  @override
  Future<int?> getInt(String key) async {
    final value = _data[key];
    return value is int ? value : null;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> clear() async {
    _data.clear();
  }

  @override
  Future<bool> containsKey(String key) async => _data.containsKey(key);
}

/// Настройки пользователя.
class UserSettings {
  const UserSettings({
    required this.themeMode,
    required this.localeCode,
    required this.notificationsEnabled,
  });

  final String themeMode; // light | dark | system
  final String localeCode;
  final bool notificationsEnabled;

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  static const defaults = UserSettings(
    themeMode: 'system',
    localeCode: 'en',
    notificationsEnabled: true,
  );
}

// ЗАДАЧА 1
// Ключ для токена авторизации: 'auth_token'.
String authTokenKey() {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Ключ для настроек: 'user_settings'.
String userSettingsKey() {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Сохрани строковый токен. Пустой token — ArgumentError.
Future<void> saveAuthToken(KeyValueStore store, String token) async {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Прочитай токен или верни null.
Future<String?> readAuthToken(KeyValueStore store) async {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Удали токен (logout).
Future<void> clearAuthToken(KeyValueStore store) async {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Реализуй UserSettings.toJson / fromJson.
// (см. UnimplementedError внутри класса выше)

// ЗАДАЧА 7
// Сохрани settings как JSON-строку по userSettingsKey().
Future<void> saveUserSettings(
  KeyValueStore store,
  UserSettings settings,
) async {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Прочитай settings. Если ключа нет — верни UserSettings.defaults.
Future<UserSettings> loadUserSettings(KeyValueStore store) async {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Флаг onboarding: ключ 'onboarding_done'.
Future<void> markOnboardingDone(KeyValueStore store) async {
  throw UnimplementedError();
}

Future<bool> isOnboardingDone(KeyValueStore store) async {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Миграция: если есть старый ключ 'token', перенеси в 'auth_token' и удали старый.
Future<void> migrateAuthTokenKey(KeyValueStore store) async {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Верни true, если тема 'dark'.
bool isDarkTheme(UserSettings settings) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Скопируй settings с новым localeCode (остальное без изменений).
UserSettings copyWithLocale(UserSettings settings, String localeCode) {
  throw UnimplementedError();
}
