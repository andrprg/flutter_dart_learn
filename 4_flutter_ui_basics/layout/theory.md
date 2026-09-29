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

## 9. CustomPainter

`CustomPaint` + `CustomPainter`: рисуешь на `Canvas` (`drawRRect`, `Paint`). `shouldRepaint` — когда перерисовывать (сравни progress).

---

Дальше: `layout_task.dart`. Скролл глубже — в `scrolling/`.
