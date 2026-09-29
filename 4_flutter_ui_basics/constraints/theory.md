# Шпаргалка: Layout Constraints

Перед задачами прочитай этот файл, затем решай `constraints_task.dart`.

Главное правило Flutter layout: **constraints go down, sizes go up, parent sets position**. Родитель отдаёт ребёнку «рамку» (`BoxConstraints`), ребёнок выбирает размер внутри неё, родитель размещает ребёнка.

## 1. Три вида ограничений

| Вид | Условие | Смысл |
|---|---|---|
| **Tight** | `min == max` по оси | «Будь ровно таким» |
| **Loose** | `min == 0`, `max` конечен | «Не больше max, можно меньше» |
| **Unbounded** | `max == infinity` | «Верхней границы нет» |

```dart
// Tight 100×50
BoxConstraints.tight(const Size(100, 50));
// то же идеей: minWidth=maxWidth=100, minHeight=maxHeight=50

// Loose: максимум 200×100, минимум 0
BoxConstraints.loose(const Size(200, 100));

// Unbounded по высоте — типично внутри Column/ListView по main axis
const BoxConstraints(maxWidth: 300); // maxHeight = infinity
```

В задачах модуля это отражено через `SimpleConstraints` / `isTight` / `isLoose` / `isUnboundedWidth`.

## 2. Как ребёнок «вписывается»

Желаемый размер clamp'ится в `[min, max]`. Если `max == infinity`, верхнюю границу не режем — берём desired:

```dart
double clampAxis(double desired, double min, double max) {
  final upper = max.isFinite ? max : desired;
  return desired.clamp(min, upper);
}
```

`constrain(c, desired)` применяет это к width и height. `tighten(c, size)` сжимает constraints до точного размера (всё ещё внутри min/max родителя) — аналог идеи `BoxConstraints.tighten`.

## 3. Flex: Expanded / Flexible

`Expanded`/`Flexible` делят **свободное** место по main axis:

```
size = available * (flex / totalFlex)
```

Их **нельзя** класть в родителя с **unbounded** main axis:

- `Row` с unbounded **шириной** → Expanded по горизонтали падает;
- `Column` с unbounded **высотой** → Expanded по вертикали падает.

Проверка в духе задачи: `canUseFlexAlong(c, vertical: true)` → false, если `maxHeight == infinity`.

## 4. Классика: ListView внутри Column

```dart
Column(
  children: [
    Text('Заголовок'),
    ListView(...), // без Expanded / высоты → ERROR
  ],
);
```

Почему: `Column` по main axis даёт детям **unbounded height**. `ListView` хочет бесконечную высоту (сам скроллится) → конфликт. Код причины в задаче: `'unbounded_height'`.

Стратегии:

| Ситуация | Стратегия |
|---|---|
| Высота Column **bounded** | обернуть ListView в `Expanded` |
| Высота **unbounded** | `ListView(shrinkWrap: true)` или другая компоновка |

`shrinkWrap: true` заставляет список измерить **всех** детей — дорого на длинных списках. Предпочтительнее `Expanded` / фиксированная высота / `CustomScrollView`.

## 5. LayoutBuilder vs MediaQuery

- **LayoutBuilder** — constraints **родителя** (адаптив внутри слота: «шире 600 → сетка»).
- **MediaQuery** — размер экрана / viewInsets / textScale.

Для «как влезло в этот контейнер» — чаще LayoutBuilder.

## 6. Overflow

Жёлто-чёрные полосы `RenderFlex overflowed` — ребёнок выбрал размер больше, чем дал родитель. Чини: `Expanded`/`Flexible`, `Flexible`+`TextOverflow`, скролл, меньший padding, `FittedBox` точечно.

Отладка: Inspector → «Debug paint» / смотреть constraints у RenderObject.

## 7. Зачем это знать

- Понимать, откуда «бесконечная высота».
- Не ставить `Expanded` в scrollable children без нужды.
- Выбирать `expanded` vs `shrink_wrap` осознанно.
- Читать overflow не как «баг Flutter», а как нарушение контракта constraints.

---

Дальше: `constraints_task.dart`, затем практика в `layout/`.
