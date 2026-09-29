# Ответы: Architecture (domain/data/presentation)

**1.** Разделение presentation / domain / data. Зависимости внутрь: UI → domain ← data.

**2.** Только data (DTO). Domain — чистые entity/use-cases.

**3.** Абстракция источника данных для domain; реализации: api/db/cache.

**4.** Одна бизнес-операция (AddTodo); удобно тестировать и переиспользовать.

**5.** sealed Failure + Either/TaskEither вместо throw через слои.

**6.** Желательно нет — переносимость и тесты без binding.

**7.** loading/data/error (AsyncValue/ViewState); маппинг Failure→message.

**8.** Подмена фейков в тестах; независимость от Dio/Prefs деталей.
