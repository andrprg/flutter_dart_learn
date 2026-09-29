# Ответы: Animations

**1.** Implicit (`AnimatedContainer`) — сами анимируют при смене полей. Explicit — `AnimationController` + Tween.

**2.** Vsync сигналы для controller; один ticker — Single, несколько — TickerProviderStateMixin.

**3.** Обязателен, иначе ticker leak / assert.

**4.** Tween — интерполяция begin/end. Curve — easing. Interval — кусок timeline 0..1.

**5.** Builder удобнее без subclass; слушает Listenable и перестраивает.

**6.** dismissed/forward/reverse/completed — реакция на конец/направление.

**7.** Shared element между routes по одному `tag`.

**8.** Избегать тяжёлого build; анимировать transform/opacity; по возможности на GPU.
