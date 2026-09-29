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

## 8. Производительность

- Анимируй **transform/opacity**, не layout на каждом кадре без нужды.
- Выноси статичный subtree в `child` у AnimatedBuilder.
- Не оставляй `repeat` без dispose.
- Сложные эффекты — `RepaintBoundary` точечно; профилируй Performance Overlay.

---

Дальше: `animations_task.dart`.
