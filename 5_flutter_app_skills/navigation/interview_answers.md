# Ответы: go_router / Navigation

**1.** Imperative: `push/pop`. Declarative: URL/state → page stack (go_router).

**2.** Path — идентичность ресурса `/users/:id`. Query — фильтры/табы `?tab=posts`.

**3.** Auth guards, onboarding, канонизация URL. Выполняется при навигации/refresh.

**4.** Общий scaffold (bottom nav) с вложенными ветками навигации.

**5.** extra — объект в памяти (не глубоко линкуется). Path/query — serializable URL.

**6.** 404/невалидный route UI.

**7.** Пересчёт redirect при смене auth/state.

**8.** Затирать intended URL; нужно сохранять redirect query и вернуть после login.
