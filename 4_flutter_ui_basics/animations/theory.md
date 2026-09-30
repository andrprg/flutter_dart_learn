# Шпаргалка: Animations

Перед задачами прочитай этот файл, затем решай `animations_task.dart`.

Анимации во Flutter делятся на **implicit** (без контроллера) и **explicit** (`AnimationController` + Tween + vsync).

## 1. Implicit vs explicit

| | Implicit | Explicit |
|---|---|---|
| Примеры | `AnimatedContainer`, `AnimatedOpacity`, `AnimatedAlign` | `AnimationController`, `Tween`, `AnimatedBuilder` |
| Управление | меняешь свойство + `Duration` | `forward` / `reverse` / `repeat` |
| Ticker | не нужен | нужен `TickerProvider` |

```dart
bool isImplicitAnimation(String name) =>
    name == 'AnimatedContainer' ||
    name == 'AnimatedOpacity' ||
    name == 'AnimatedAlign';

bool needsTickerProvider(String api) => api == 'AnimationController';
```

```dart
// FadeBox — implicit
AnimatedOpacity(
  opacity: visible ? 1 : 0,
  duration: const Duration(milliseconds: 200),
  child: child,
);
```

## 2. Ticker и mixin

`AnimationController` тикает каждый кадр → нужен vsync:

```dart
class _State extends State<MyWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _c.dispose(); // обязательно — иначе тикер живёт после ухода экрана
    super.dispose();
  }
}
```

Несколько контроллеров → `TickerProviderStateMixin`. Правило модуля: `mustDisposeAnimationController()` → `true`.

## 3. Tween, Curve, progress

```dart
// progress 0..1
t = (value.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);

// линейная интерполяция
lerp = begin + (end - begin) * t;

// кривая
Curves.easeIn.transform(t.clamp(0.0, 1.0));
```

`Tween<double>(begin: 1, end: 0.9).animate(controller)` → `Animation<double>`.

`Interval` / `CurveTween` — анимация только на части timeline (например 0.0–0.5).

## 4. AnimationStatus

| Status | label |
|---|---|
| `dismissed` | в начале (0) |
| `forward` | идёт вперёд |
| `reverse` | идёт назад |
| `completed` | в конце (1) |

Слушай `controller.addStatusListener` для цепочек (forward → reverse на tap).

## 5. AnimatedBuilder vs AnimatedWidget

```dart
AnimatedBuilder(
  animation: controller,
  builder: (context, child) {
    return Opacity(opacity: opacityAnim.value, child: child);
  },
  child: const /* статичная часть, не пересоздаём */,
);
```

`AnimatedWidget` — виджет, подписанный на `Listenable` через `listenable` в конструкторе; удобен для своих Transition-классов. `AnimatedBuilder` — гибче в одном месте.

Переходы: `ScaleTransition`, `FadeTransition`, `SizeTransition` — берут `Animation<double>`.

## 6. Паттерны задач

- **ScaleOnTap**: forward + reverse на tap, `ScaleTransition` + Tween 1.0→0.9.
- **PulseDot**: `controller.repeat(reverse: true)` + `AnimatedBuilder` + Opacity Tween 0.3→1.0.

## 7. Hero

`Hero(tag: 'avatar', child: ...)` на двух экранах — общая геометрия при `Navigator.push`. Теги уникальны на экране. Не для всего подряд — только осознанные shared-element переходы.

## 8. Что анимировать, чтобы не трогать layout

`Opacity` и `Transform` (включая `SlideTransition`, `ScaleTransition`, `RotationTransition`) могут остаться на стадии paint/compositing. Смена `width` у `AnimatedContainer` каждый кадр гоняет layout у поддерева. Для появления блока с нуля `SizeTransition` тоже трогает layout — это нормально, но не в длинном списке на каждый item одновременно.

`RepaintBoundary` отделяет слой, чтобы пульсация точки не перерисовывала весь экран. Ставить на каждый ряд «на всякий случай» дорого по памяти. Имеет смысл вокруг того, что реально тикает (`PulseDot`), а список под ним статичен.

Незапущенный контроллер ничего не стоит кадрами. `repeat` без `dispose` тикает после ухода экрана и может звать `setState` у размонтированного State, если слушатель так написан. `dispose` контроллера снимает тикер.

Кривые: `Curves.easeIn` медленно стартует. `Curves.linear` — постоянная скорость, для прогресса загрузки честнее, для UI часто выглядит механически. Своя кривая — `Curve.transform`. Значение контроллера всегда 0…1 (если не задан `lowerBound`/`upperBound`); «пиксели» появляются в Tween, не в контроллере.

`AnimationController(value: 1)` начинает с конца. `forward()` из `completed` ничего не делает, пока не `reset()` или `reverse()`. Для кнопки «нажал — качнулся» типичный жест: если `isAnimating` — не перезапускать, либо `forward(from: 0)`.

## 9. Неявные анимации и прерывание

`AnimatedContainer` при новой цели **перебивает** предыдущую анимацию и едет из текущих значений, не из старого begin. Дёргать `duration` каждый кадр не нужно: меняют целевые свойства.

`AnimatedSwitcher` сравнивает детей по `Key` и `runtimeType`. Смена текста без ключа может не анимироваться, если тип виджета тот же и элемент обновился на месте. `ValueKey(text)` заставляет считать ребёнка новым и проиграть переход.

`Hero` во время полёта ломается, если на одном маршруте два одинаковых `tag` или цель исчезла до конца перехода. Тег — строка, уникальная среди видимых маршрутов. У списков тег включает id: `hero-avatar-$id`.

`AnimationStatus.completed` приходит и когда `forward` доиграл, и когда value уже был 1. Для цепочки «туда-обратно» статус слушают один раз и вызывают `reverse`, либо используют `addStatusListener` с проверкой `completed`.

## 10. Типичные ошибки

- Забыть `vsync: this` и mixin — контроллер не создаётся.
- `Tween.animate` на каждом `build` — новая подписка каждый кадр. Храни `Animation` в поле `State`.
- Слушатель `addListener(setState)` плюс `AnimatedBuilder` на том же контроллере — двойная работа. Достаточно билдера.
- `opacity: 0` и виджет всё ещё принимает нажатия. Для «скрыт и не жмёт» — `IgnorePointer` или не класть в дерево.
- Долгий `duration` на `repeat` без `reverse` и скачок в начало.

## 11. Кратко

- Анимируй **transform/opacity**, не layout на каждом кадре без нужды.
- Выноси статичный subtree в `child` у `AnimatedBuilder`.
- Не оставляй `repeat` без `dispose`.
- Сложные эффекты — `RepaintBoundary` точечно.

---

Дальше: `animations_task.dart`.
