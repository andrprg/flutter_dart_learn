# Ответы: Flutter Widgets (база)

**1.** Stateless — конфиг без локального мутабельного state. Stateful — `State` с `setState`, lifecycle.

**2.** Описание UI (immutable widget tree). Должен быть pure относительно side effects; тяжёлое/async — не сюда.

**3.** Проброс данных вниз по дереву; подписчики ребилдятся при изменении.

**4.** Переиспользование элементов, меньше rebuild work, canonical instances.

**5.** Создавать Future прямо в `build` — перезапуск на каждый rebuild. Создавать в `initState`/провайдере.

**6.** Стабильная идентичность элементов при reorder/filter — `ValueKey(id)`, не index.

**7.** `push`/`pop` + `MaterialPageRoute`. Для сложных графов — go_router (declarative).

**8.** Через `ScaffoldMessenger` / `showDialog` после того, как дерево готово; не в сыром `initState` без post-frame.
