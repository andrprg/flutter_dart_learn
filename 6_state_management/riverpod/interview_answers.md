# Ответы: Riverpod

**1.** Riverpod compile-safe, нет зависимости от BuildContext для чтения, лучше тестируется, codegen.

**2.** watch — подписка/rebuild. read — разово (callbacks). listen — side effects.

**3.** Класс с `build()` state; методы меняют state. Async — для Future.

**4.** Освобождать state без слушателей; кэш сбрасывается — помнить про keepAlive.

**5.** Параметризованные провайдеры `provider(id)`.

**6.** `ProviderContainer(overrides: [...])` / ProviderScope overrides.

**7.** build должен быть чистым; сеть — через AsyncNotifier/методы.

**8.** `@riverpod` / `@Riverpod(keepAlive: true)` → генерация `*Provider`.
