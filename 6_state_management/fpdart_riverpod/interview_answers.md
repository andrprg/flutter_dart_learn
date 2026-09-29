# Ответы: fpdart + Riverpod

**1.** run task → fold в AsyncData/AsyncError или helper `taskToAsyncValue`.

**2.** В Notifier/repository use-case; UI только смотрит AsyncValue.

**3.** ref.listen на AsyncValue/ошибку; не в build.

**4.** Кнопка повтора вызывает метод notifier снова; сохранить args.

**5.** UI знает ViewState/AsyncValue; Either остаётся в application/data.

**6.** parallel TaskEither / Future.wait → один AsyncValue комбинированного результата.

**7.** keepAlive / ручной cache в repository; инвалидация на mutate.

**8.** Фейковый repo возвращает Left/Right; container.read notifier.
