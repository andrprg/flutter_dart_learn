# Ответы: Layout Constraints

**1.** Constraints go down, sizes go up, parent sets position. Родитель говорит «минимум/максимум», ребёнок выбирает размер.

**2.** Tight: min==max. Loose: min=0, max конечен. Unbounded: max=infinity (часто в scroll/flex cross mistakes).

**3.** Column даёт unbounded высота по main axis → ListView хочет бесконечность → ошибка.

**4.** Внутри родителя с unbounded main axis (например, ListView children без ограничения).

**5.** Считает размер всех детей; плохо для длинных списков. Лучше Expanded/фиксированная высота.

**6.** Сжимает constraints к конкретному размеру в пределах min/max.

**7.** Читать RenderFlex overflow, желто-чёрные полосы; проверить Expanded/Flexible/scroll, длины текста.

**8.** LayoutBuilder — constraints родителя. MediaQuery — размер экрана/view insets. Для adaptive внутри слота — чаще LayoutBuilder.
