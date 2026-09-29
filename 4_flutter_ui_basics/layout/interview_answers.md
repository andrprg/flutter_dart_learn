# Ответы: Layout виджеты

**1.** Main — направление Row→горизонт, Column→вертикаль. Cross — перпендикуляр. Align через MainAxisAlignment/CrossAxisAlignment.

**2.** Наложение детей. Positioned привязывает к краям Stack. Без Positioned — по alignment.

**3.** Оба в Flex. Expanded = Flexible(fit: tight) занимает оставшееся. Flexible может быть меньше.

**4.** Перенос чипов/тегов на следующую строку вместо overflow Row.

**5.** Ленивые куски скролла: SliverAppBar, SliverList, SliverGrid в одном viewport.

**6.** Жёсткое соотношение сторон; доля от родителя.

**7.** OverflowBox позволяет ребёнку выйти за constraints (осторожно). IgnorePointer отключает hit-testing.

**8.** Swipe-to-dismiss; обязателен Key для корректной идентичности в списке.
