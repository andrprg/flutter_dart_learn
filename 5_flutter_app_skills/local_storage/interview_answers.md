# Ответы: Local Storage

**1.** Prefs — простые ключи. Secure — токены. Hive/Drift/SQLite — структурированные данные.

**2.** Секреты в plaintext, большие blob без необходимости.

**3.** Версия схемы/флаг миграции; перенос old→new и удаление old.

**4.** encode/decode строки; версионировать модель настроек.

**5.** Плагины часто main-isolate; не считать потокобезопасным везде.

**6.** Удалить token и user-scoped данные; сохранить onboarding flags если нужно.

**7.** string/int/bool/double/stringList — остальное сериализуйте.

**8.** In-memory fake implementing тот же интерфейс.
