# Шпаргалка: Scrolling

Перед задачами прочитай этот файл, затем решай `scrolling_task.dart`.

Скролл — это `Scrollable` + `Viewport` + метрики. Ты слушаешь offset, детектишь конец списка, делаешь pull-to-refresh и пейджинг.

## 1. ListView vs builder

| Конструктор | Поведение |
|---|---|
| `ListView(children: [...])` | Строит **всех** детей сразу |
| `ListView.builder` | Создаёт детей **лениво** по видимой области |
| `ListView.separated` | builder + разделители |

Для длинных списков — только builder (или slivers).

## 2. ScrollMetrics и прогресс

```dart
double scrollProgress(ScrollMetrics m) {
  if (m.maxScrollExtent == 0) return 0;
  return (m.pixels / m.maxScrollExtent).clamp(0.0, 1.0);
}

bool isNearEnd(ScrollMetrics m, {double threshold = 200}) {
  return m.maxScrollExtent - m.pixels <= threshold;
}
```

Пагинация: грузить следующую страницу, если near end **и** не `isLoading` **и** `hasMore`.

Overscroll:

- `pixels < minScrollExtent` → `'top'`
- `pixels > maxScrollExtent` → `'bottom'`
- иначе `'none'`

## 3. ScrollController

```dart
final controller = ScrollController(initialScrollOffset: 0);

controller.addListener(() { /* offset, position.metrics */ });
controller.animateTo(0, duration: ..., curve: ...);
controller.jumpTo(0);

@override
void dispose() {
  controller.dispose(); // обязательно
  super.dispose();
}
```

Без `dispose` — утечки слушателей. Не используй controller после dispose.

**PrimaryScrollController** — общий контроллер Scaffold (например, тап по статус-бару «вверх»). Два primary scrollable на одном экране конфликтуют → одному `primary: false`.

## 4. NotificationListener

```dart
NotificationListener<ScrollNotification>(
  onNotification: (n) {
    if (n is ScrollUpdateNotification) {
      final m = n.metrics;
      if (shouldLoadMore(...)) onLoadMore();
    }
    return false; // false = не останавливать всплытие
  },
  child: list,
);
```

Типы: `ScrollStartNotification`, `ScrollUpdateNotification`, `ScrollEndNotification`, `OverscrollNotification`.

Альтернатива — listener на `ScrollController`.

## 5. RefreshIndicator

```dart
RefreshIndicator(
  onRefresh: () async { await reload(); },
  child: ListView(...),
);
```

Нужен scrollable, который умеет **overscroll**. Короткий список: `physics: AlwaysScrollableScrollPhysics()`, иначе pull-to-refresh не сработает.

## 6. PageView

Страницы жестом (карусель), не путать с `TabBarView` (связан с `TabController` / вкладками).

```dart
PageView.builder(
  controller: pageController,
  itemCount: n,
  itemBuilder: (_, i) => Text('$i'),
);

// индекс ≈ round(offset / viewportWidth)
int pageIndexForOffset(double offset, double viewportWidth) {
  if (viewportWidth <= 0) throw ArgumentError();
  return (offset / viewportWidth).round();
}
```

## 7. NestedScrollView

Когда нужен **общий** header (SliverAppBar) + внутренний скролл вкладок — `NestedScrollView`. Иначе два независимых скролла «ломают» ощущение одного экрана.

## 8. Практика модуля

- `ProgressHeader` — процент из metrics.
- `LoadMoreListener` — NotificationListener + shouldLoadMore.
- `NumbersList` / `RefreshableList` / `SimplePager` — сборка контроллера, refresh, PageView.

---

Дальше: `scrolling_task.dart`.
