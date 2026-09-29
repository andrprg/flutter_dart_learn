# Ответы: Forms и валидация

**1.** `validate()`, `save()`, `reset()` централизованно.

**2.** Создать в State, dispose обязательно.

**3.** disabled / always / onUserInteraction — UX валидации.

**4.** Переход next/done, программный фокус, accessibility.

**5.** Блокировать кнопку, показывать progress, не вызывать validate после dispose; проверить mounted.

**6.** Timer на onChanged; сброс предыдущего; dispose timer.

**7.** `String?`: null — ок, строка — текст ошибки.

**8.** TextFormField — удобная обёртка FormField для текста.
