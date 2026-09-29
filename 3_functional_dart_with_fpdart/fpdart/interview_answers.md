# Ответы: fpdart (Option, Either, TaskEither)

**1.** Явное отсутствие значения в типе. Заставляет обработать None через map/fold/getOrElse.

**2.** Ошибка — значение Left, часть сигнатуры. Легче композировать и тестировать, чем try/catch сквозь слои.

**3.** `Task` — lazy описание async (запуск через `run`). Future стартует сразу при создании.

**4.** Repository/API: async + доменные ошибки без исключений в UI.

**5.** `map` меняет Right/Some. `flatMap` — цепочка вычислений, которые сами возвращают Option/Either.

**6.** `Either<List<String>, T>` / Validated-подход, не fail-fast flatMap.

**7.** Список эффектов → эффект списка. Любой None/Left валит весь результат (обычно).

**8.** IO — sync эффект. Reader — зависимость из контекста. State — вычисление с состоянием. На практике чаще Option/Either/TaskEither.

**9.** На границе presentation: `fold` / convert в `AsyncValue` / ViewState. UI не импортирует детали data.

**10.** Оборачивает Future/throwing код в Left через mapper исключения.
