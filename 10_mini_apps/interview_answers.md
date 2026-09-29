# Ответы: Mini Apps

**1.** Доменные модели + repository + тесты, затем state, затем UI.

**2.** Интерфейс репозитория; delayed fake; UI на AsyncValue.

**3.** redirect на login, сохранение сессии, возврат на intended route.

**4.** Нормализованный Map id→qty, derived totals; один source of truth.

**5.** Явные ветки UI; retry; не оставлять blank screen.

**6.** Когда появляется повтор и тесты тормозят из-за UI связности.

**7.** Ошибки домена в Either; UI fold/AsyncValue.

**8.** Сценарии happy/edge покрыты тестами логики + ручной прогон UI.
