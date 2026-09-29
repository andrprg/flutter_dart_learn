import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'storage_task.dart';

void main() {
  group('Local storage helpers', () {
    late MemoryStore store;

    setUp(() {
      store = MemoryStore();
    });

    test('ключи auth и settings', () {
      expect(authTokenKey(), 'auth_token');
      expect(userSettingsKey(), 'user_settings');
    });

    test('save/read/clear auth token', () async {
      expect(() => saveAuthToken(store, ''), throwsArgumentError);

      await saveAuthToken(store, 'secret');
      expect(await readAuthToken(store), 'secret');

      await clearAuthToken(store);
      expect(await readAuthToken(store), isNull);
    });

    test('UserSettings json roundtrip', () {
      const settings = UserSettings(
        themeMode: 'dark',
        localeCode: 'ru',
        notificationsEnabled: false,
      );

      final json = settings.toJson();
      final restored = UserSettings.fromJson(json);

      expect(restored.themeMode, 'dark');
      expect(restored.localeCode, 'ru');
      expect(restored.notificationsEnabled, isFalse);
    });

    test('save/load user settings с defaults', () async {
      final defaults = await loadUserSettings(store);
      expect(defaults.themeMode, 'system');
      expect(defaults.localeCode, 'en');

      await saveUserSettings(
        store,
        const UserSettings(
          themeMode: 'light',
          localeCode: 'ru',
          notificationsEnabled: true,
        ),
      );

      final loaded = await loadUserSettings(store);
      expect(loaded.themeMode, 'light');
      expect(loaded.localeCode, 'ru');

      final raw = await store.getString(userSettingsKey());
      expect(jsonDecode(raw!), isA<Map<String, dynamic>>());
    });

    test('onboarding flag', () async {
      expect(await isOnboardingDone(store), isFalse);
      await markOnboardingDone(store);
      expect(await isOnboardingDone(store), isTrue);
    });

    test('migrateAuthTokenKey переносит старый ключ', () async {
      await store.setString('token', 'legacy');
      await migrateAuthTokenKey(store);

      expect(await store.getString('token'), isNull);
      expect(await readAuthToken(store), 'legacy');
    });

    test('isDarkTheme и copyWithLocale', () {
      const settings = UserSettings(
        themeMode: 'dark',
        localeCode: 'en',
        notificationsEnabled: true,
      );

      expect(isDarkTheme(settings), isTrue);

      final ru = copyWithLocale(settings, 'ru');
      expect(ru.localeCode, 'ru');
      expect(ru.themeMode, 'dark');
      expect(ru.notificationsEnabled, isTrue);
    });
  });
}
