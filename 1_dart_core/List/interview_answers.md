# Ответы: List

**1.** `Iterable` — ленивый обход. `List` — индексный доступ, изменяемая/фиксированная длина, `length` O(1).

**2.** Нет, `Iterable`. Нужен `.toList()` если нужен список.

**3.** `List.filled(n, e, growable: false)` — нельзя add/remove. Growable — обычный `[]`.

**4.** `removeWhere`, или фильтр в новый список. Не мутировать во время `for-in` неаккуратно.

**5.** `expand` — flatMap. `fold` — аккумулятор с начальным. `reduce` — без начального, на пустом бросает.

**6.** O(n). Для частых проверок — `Set`.

**7.** Проверить `index < length` или `elementAtOrNull` (collection package) / свой helper.

**8.** В литералах: `[if (x) a, for (final e in list) e * 2]`.
