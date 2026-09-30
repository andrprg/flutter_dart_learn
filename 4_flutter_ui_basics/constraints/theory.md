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

Важно: `Column` **не отдаёт** свою конечную высоту обычным детям. Даже на экране не-flex ребёнок получает `maxHeight = infinity`. Поэтому голый `ListView` падает и в «ограниченном» `Column`. Конечный `maxHeight` у `Column` значит другое: внутри него **можно** поставить `Expanded`.

## 5. Expanded в детях scrollable — только по делу

`ListView` / `GridView` / `SingleChildScrollView` по **оси скролла** дают детям unbounded:

- вертикальный список → `maxHeight = infinity`, ширина конечная (ширина viewport);
- горизонтальный → `maxWidth = infinity`, высота конечная.

`Expanded` / `Flexible` / `Spacer` делят свободное место: конечный `max` минус уже занятое. Если `max` бесконечен, делить нечего.

Две разные ошибки:

```dart
// 1. Expanded — прямой ребёнок списка. ListView не Flex.
ListView(
  children: [
    Expanded(child: Text('тело')), // Incorrect use of ParentDataWidget
  ],
);

// 2. Flex есть, но его main axis unbounded (список отдал бесконечную высоту).
SingleChildScrollView(
  child: Column(
    children: [
      Text('Шапка'),
      Expanded(child: Text('тело')), // non-zero flex, incoming height unbounded
    ],
  ),
);
```

`Expanded` внутри вертикального списка **нормален**, если он делит **ширину** — она у item конечная:

```dart
ListView(
  children: [
    Row(
      children: [
        Icon(Icons.place),
        Expanded(child: Text('адрес')), // main axis Row — ширина, она bounded
      ],
    ),
  ],
);
```

Строка остаётся высотой по тексту. Скролл как раз про это: дети по контенту вдоль оси прокрутки, а не «на весь экран».

Обратная схема — частый правильный вариант. `Expanded` оборачивает **сам** список, а не сидит у него в `children`:

```dart
Column( // высота конечная: body Scaffold, SizedBox, другой Expanded
  children: [
    Text('Шапка'),
    Expanded(child: ListView(children: items)),
  ],
);
```

Список получает tight-высоту (остаток `Column`) и скроллит внутри себя. Вдоль оси скролла item остаётся по контенту: пустое место под коротким списком — свойство viewport, его не заполняют `Expanded` у детей.

Редкий случай, когда flex внутри скролла нужен: футер у нижнего края, пока контент короче экрана, и уезжает вместе со страницей, когда контент длиннее. Голый `Expanded` тут нельзя. Официальный приём — минимальная высота viewport и второй проход раскладки:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Text('Контент'),
              Spacer(),
              Text('Футер'),
            ],
          ),
        ),
      ),
    );
  },
);
```

`IntrinsicHeight` меряет детей дважды. Для обычной ленты это лишнее.

## 6. `expanded` vs `shrink_wrap`

Коды из задачи 12: скролл внутри `Column`.

| | `'expanded'` | `'shrink_wrap'` |
|---|---|---|
| Условие | у `Column` конечный `maxHeight` | у `Column` `maxHeight == infinity` |
| Приём | `Expanded(child: ListView(...))` | `ListView(shrinkWrap: true)` |
| Высота списка | остаток родителя, список — viewport | сумма детей |
| Скролл | внутри списка | обычно у внешнего родителя |
| Цена | ленивая раскладка видимых item | измеряются **все** дети |

`shrinkWrap: true` говорит списку: «не занимай max, стань высотой контента». Это обязательный обход, когда `Expanded` запрещён (родитель unbounded). На длинной ленте цена большая: чтобы узнать полную высоту, надо разложить каждый item. Ленивость `ListView.builder` почти пропадает, высота пересчитывается, когда контент меняется.

При конечной высоте `Column` `shrinkWrap` уместен, только если item точно помещаются и список не должен занять остаток. Сумма детей больше `max` этого `Column` — overflow: список вырос вместо того, чтобы скроллиться. Для ленты, которая может быть длиннее экрана, нужен `'expanded'`.

Когда `shrink_wrap` осознанный:

- `Column` уже внутри другого скролла, пунктов мало (форма, несколько строк);
- нужны `separator` / `builder`, а жест должен достаться внешнему скроллу — часто вместе с `physics: NeverScrollableScrollPhysics()`.

Если пунктов мало и снаружи уже есть скролл, `ListView` не нужен: дети сразу в `Column`.

Если лента длинная, а шапка, список и футер должны ехать **одним** жестом — не вкладывать `ListView` в `Column`. Один `CustomScrollView` со slivers, без `shrinkWrap` и без второго скролла.

```
Высота Column конечная?
  да  → Expanded(child: ListView())          // 'expanded'
  нет → пунктов мало: shrinkWrap или Column  // 'shrink_wrap'
        лента длинная: один CustomScrollView
```

## 7. LayoutBuilder vs MediaQuery

- **LayoutBuilder** — constraints **родителя** (адаптив внутри слота: «шире 600 → сетка»).
- **MediaQuery** — размер экрана / viewInsets / textScale.

Для «как влезло в этот контейнер» — чаще LayoutBuilder.

## 8. Overflow

Жёлто-чёрные полосы `RenderFlex overflowed` — ребёнок выбрал размер больше, чем дал родитель. Чини: `Expanded`/`Flexible`, `Flexible`+`TextOverflow`, скролл, меньший padding, `FittedBox` точечно.

Отладка: Inspector → «Debug paint» / смотреть constraints у RenderObject.

## 9. Как проходит один layout-проход

Родитель вызывает у ребёнка `layout(constraints)`. Ребёнок обязан вернуть `Size`, который этим constraints удовлетворяет: `min <= size <= max` по каждой оси. Потом родитель в `performLayout` вызывает `position` — у Flex это `offset` вдоль main axis.

`RenderFlex` (Row/Column):

1. Детям без flex отдаёт unbounded по main axis и смотрит, сколько они заняли.
2. Остаток делит между flex по `flex` / сумме.
3. Flex-ребёнок получает tight (Expanded) или max = его доля (Flexible loose) по main axis.

Если на шаге 1 ребёнок сам хочет бесконечность (ListView, другой Expanded), а max уже бесконечен — flex падает с unbounded. Если не-flex ребёнок вернул размер больше входящего max по cross axis — overflow полосы.

`Center` ослабляет constraints до loose: ребёнок может быть меньше центра и не обязан занять весь экран. `Align` делает то же. `SizedBox.expand` наоборот ужесточает до max родителя.

`Padding` вычитает отступы из входящих constraints и передаёт ребёнку меньшую рамку. Двойной padding 400 при max 300 — ребёнок получит нулевую или отрицательную математику, которую Flutter зажимает, и контент визуально «исчезнет», не всегда с overflow.

## 10. Unbounded не только у Column

Unbounded main axis появляется у:

- `Column` / `Row` для обычных детей;
- `ListView` / `PageView` / `SingleChildScrollView` вдоль оси скролла;
- `UnconstrainedBox` — сознательно снимает рамку; частый источник overflow, потому что родитель всё равно должен куда-то положить «бесконечный» ребёнок.

По cross axis список как раз **ограничен**: вертикальный `ListView` даёт детям ширину viewport. Поэтому `Row` + `Expanded` внутри item — нормальный приём, а `Column` + `Expanded` внутри того же item — нет.

`IntrinsicHeight` спрашивает детей «какая высота вам нужна, если ширина такая», потом второй проход. Дорого и ломается на виджетах без intrinsic (тот же ListView). Для выравнивания высоты карточек в ряду иногда нужен, для ленты — нет.

## 11. Как читать ошибку в консоли

`Vertical viewport was given unbounded height` — скролл лежит в Column/Row без высоты.

`RenderFlex children have non-zero flex but incoming height constraints are unbounded` — Expanded в Column, у которого нет конечной высоты (часто Column сам внутри скролла).

`Incorrect use of ParentDataWidget` — Expanded/Positioned не прямой ребёнок Flex/Stack. Обёртка в `Padding` или `Center` разрывает связь: ParentData должен увидеть именно Flex.

`A RenderFlex overflowed by N pixels` — ребёнок не flex и шире/выше оставшегося места. Число пикселей — на сколько вылез, не «на сколько уменьшить шрифт наугад».

## 12. Зачем это знать

- Понимать, откуда «бесконечная высота».
- Не ставить `Expanded` в scrollable children без нужды.
- Выбирать `expanded` vs `shrink_wrap` осознанно.
- Читать overflow не как «баг Flutter», а как нарушение контракта constraints.

---

Дальше: `constraints_task.dart`, затем практика в `layout/`.
