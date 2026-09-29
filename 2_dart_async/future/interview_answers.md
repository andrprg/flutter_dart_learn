# Ответы: Future

**1.** Концептуально похожи. В Dart `async/await`, `Future.wait`, `whenComplete`, типизация `Future<T>`.

**2.** `wait` параллелит. Последовательный await — сумма задержек.

**3.** `try/catch` с await, `.catchError`, `.onError`, `TimeoutException` через `timeout`.

**4.** Ещё нет результата. `Completer` позволяет завершить вручную.

**5.** Уже завершённый success/error; delayed планирует в event queue.

**6.** Ошибки без await/catch могут стать unreported; UI не дождётся результата. Используйте `unawaited` осознанно.

**7.** `await` читаемее и лучше со stack traces в async. `then` — цепочки/низкий уровень.

**8.** У самого Future нет cancel. Паттерны: флаги, `CancelableOperation` (async package), abort контроллеры.
