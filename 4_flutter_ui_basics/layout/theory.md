# Шпаргалка: Layout-виджеты

Перед задачами прочитай этот файл, затем решай `layout_task.dart`. Модуль `constraints/` — про правила размеров; здесь — про готовые виджеты компоновки.

## 1. Row / Column

- **Main axis** — направление детей (`Row` → горизонталь, `Column` → вертикаль).
- **Cross axis** — перпендикуляр (`crossAxisAlignment: start/center/stretch/…`).
- `mainAxisAlignment` — распределение вдоль main.
- `mainAxisSize: min/max` — сжиматься по детям или занять max.

```dart
Row(
  children: [
    CircleAvatar(...),
    const SizedBox(width: 12),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text('Имя'), Text('Роль')],
    ),
  ],
);
```

## 2. Expanded vs Flexible

Оба в `Row`/`Column` с **bounded** main axis.

| | Expanded | Flexible |
|---|---|---|
| fit | `FlexFit.tight` | по умолчанию `loose` |
| смысл | забрать долю и **растянуться** | доля, но можно меньше |

`flex: 2 : 1 : 2` — пропорции свободного места (задача FlexNavBar).

## 3. Stack и Positioned

`Stack` кладёт детей слоями. Без `Positioned` — выравнивание через `alignment`. С `Positioned(left/top/right/bottom)` — абсолютные отступы от краёв стека.

Типично: иконка + бейдж, аватар + статус-точка, перекрывающиеся аватары (`clipBehavior: Clip.none`).

## 4. Wrap

Когда в ряд не влезает — перенос на следующую «дорожку». `spacing` / `runSpacing`. Теги, Chip-облака — сюда, не в бесконечный `Row`.

## 5. Размеры от родителя

- **FractionallySizedBox** — доля от max constraints (`widthFactor: 0.8`).
- **AspectRatio** — ширина/высота в фиксированной пропорции.
- **IntrinsicHeight / IntrinsicWidth** — измерить «естественный» размер детей (дорого; EqualHeightRow).
- **Transform.rotate** — визуальный поворот (layout box часто остаётся прежним).

## 6. Списки, сетки, slivers

```dart
ListView.separated(
  itemCount: 20,
  separatorBuilder: (_, __) => const Divider(indent: 72),
  itemBuilder: (_, i) => ListTile(...),
);

GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1,
  ),
  itemBuilder: ...,
);
```

`CustomScrollView` + **slivers** — один скролл из кусков:

- `SliverAppBar` (pinned / floating / FlexibleSpaceBar)
- `SliverList` / `SliverGrid` / `SliverPadding`
- `SliverToBoxAdapter` — обычный виджет (горизонтальный ряд чипов) внутри sliver-скролла

## 7. Адаптив

```dart
LayoutBuilder(
  builder: (context, c) {
    if (c.maxWidth < 600) return ListView(...);
    return GridView(...); // 2 колонки
  },
);

OrientationBuilder(
  builder: (context, orientation) {
    return orientation == Orientation.portrait
        ? Column(...)
        : Row(...);
  },
);
```

LayoutBuilder смотрит на **слот**, OrientationBuilder — на ориентацию устройства.

## 8. Клиппинг и жесты списка

- `ClipRRect` / `ClipOval` — обрезать по радиусу/кругу.
- `Dismissible` — свайп; нужен **Key**; `background` / `secondaryBackground`; `onDismissed`.
- `AnimatedContainer` — плавно менять высоту раскрываемой карточки.

## 9. Baseline, stretch и mainAxisSize

`crossAxisAlignment: stretch` даёт детям tight по cross axis: в `Column` это ширина колонки. Несрастянутый ребёнок получает max = ширине, но min = 0, и сам решает быть уже (текст). `stretch` нужен, когда кнопка или `ColoredBox` должны занять всю ширину без `SizedBox(width: double.infinity)`.

`mainAxisSize: min` — Row/Column сжимается по детям. Внутри `Align` или свободного места экрана ряд не растянется на всю ширину, и `Expanded` будет делить уже не экран, а сумму... нет: `Expanded` требует оставшееся место родителя. При `mainAxisSize: min` свободного места нет, flex-дети получают нулевую долю сверх своего min. Не мешай `Expanded` и `MainAxisSize.min` без понимания: типичный симптом — полоска нулевой ширины.

`MainAxisAlignment.spaceBetween` при одном ребёнке ничего не «распределяет». При overflow alignment не лечит вылезание: он только раскладывает то, что уже влезло в max.

## 10. Stack: размер и клипы

Без `Positioned` и без `fit: StackFit.expand` размер `Stack` — максимум нес-positioned детей. Если все дети `Positioned`, размер стека нулевой или от родителя, если родитель дал tight (например `SizedBox`). Бейдж «в углу» на нулевом стеке уезжает в точку.

`Positioned.fill` — все четыре края 0, ребёнок получает размер стека. `Positioned(top: 0, right: 0)` без ширины — ребёнок по своему размеру, прижат к углу.

`clipBehavior: Clip.hardEdge` обрежет вылезающий бейдж. Для аватаров, которые должны чуть выступать, ставят `Clip.none` и следят, чтобы родитель не клипал сам.

`IndexedStack` держит всех детей живыми и показывает одного по index. Дороже `switch` по виджету, зато `State` вкладок не сбрасывается. Сродни идее нижней навигации.

## 11. Sliver и обычный виджет

`CustomScrollView` принимает только slivers. Обычный `Row` внутрь нельзя: нужен `SliverToBoxAdapter`. `SliverList` ленивый, как `ListView.builder`. `SliverFillRemaining` занимает хвост viewport — место для футера «прижать к низу, если контент короткий», без `IntrinsicHeight`.

`SliverAppBar(pinned: true)` остаётся видимым. `floating: true` выезжает, как только потянули вниз, даже если ещё не наверху списка. Оба флага вместе — привычная «шапка ленты».

## 12. Типичные ошибки

- `Spacer()` в `Row` внутри горизонтального `ListView` — unbounded ширина.
- `Wrap` с `Expanded` среди детей. Wrap не Flex.
- `FractionallySizedBox` без конечного max родителя — доля от бесконечности.
- `Transform.rotate` ждут, что хит-тест и размер соседа изменятся. Layout-размер остаётся прежним, рисунок визуально вылезает.
- Два скролла в одном направлении без `NeverScrollableScrollPhysics` у внутреннего — жест забирает случайный из них.

## 13. CustomPainter

`CustomPaint` + `CustomPainter`: рисуешь на `Canvas` (`drawRRect`, `Paint`). `shouldRepaint` — когда перерисовывать (сравни progress).

---

Дальше: `layout_task.dart`. Скролл глубже — в `scrolling/`.
