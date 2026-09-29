// ============================================================
// 12 ЗАДАЧ ПО LAYOUT CONSTRAINTS
// ============================================================
// Цель: понять tight/loose/unbounded constraints — основу Flutter layout.
// Без этого сложно отлаживать «RenderFlex overflowed» и странные размеры.

/// Упрощённое описание ограничений (зеркало идей BoxConstraints).
class SimpleConstraints {
  const SimpleConstraints({
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
  });

  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  static const unbounded = SimpleConstraints(
    minWidth: 0,
    maxWidth: double.infinity,
    minHeight: 0,
    maxHeight: double.infinity,
  );
}

/// Размер, который хочет виджет.
class SimpleSize {
  const SimpleSize(this.width, this.height);

  final double width;
  final double height;
}

// ЗАДАЧА 1
// Constraints tight по обеим осям: min == max для width и height.
bool isTight(SimpleConstraints c) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Loose: minWidth == 0 && minHeight == 0, при этом max конечны.
bool isLoose(SimpleConstraints c) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Unbounded по ширине: maxWidth == infinity.
bool isUnboundedWidth(SimpleConstraints c) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Создай tight constraints заданного размера.
SimpleConstraints tightSize(double width, double height) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Создай loose constraints с максимумами width/height (min = 0).
SimpleConstraints looseSize(double width, double height) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// «Впиши» desired в constraints:
// width = desired.width.clamp(minWidth, maxWidth) — с учётом infinity.
// Если max == infinity, верхнюю границу не ограничивай (используй desired).
double clampAxis(double desired, double min, double max) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Примени constraints к desired size -> итоговый SimpleSize.
SimpleSize constrain(SimpleConstraints c, SimpleSize desired) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Усиль (tighten) constraints до точного размера, но не выходя за max/min.
// Итог: tight width/height = clampAxis(size.*, min, max).
SimpleConstraints tighten(SimpleConstraints c, SimpleSize size) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Можно ли положить Expanded/Flexible в этого родителя?
// false, если ось main unbounded (для Row — width, для Column — height).
bool canUseFlexAlong(SimpleConstraints c, {required bool vertical}) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Почему ListView внутри Column без Expanded даёт ошибку?
// Верни короткий код причины: 'unbounded_height'.
String listViewInColumnErrorCode() {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Доля flex: при totalFlex и available пикселей верни размер для flex-фактора.
// size = available * (flex / totalFlex). totalFlex <= 0 или flex < 0 -> ArgumentError.
double flexExtent({
  required int flex,
  required int totalFlex,
  required double available,
}) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Выбери стратегию для скролла внутри Column:
// - если высота bounded -> 'expanded'
// - если unbounded -> 'shrink_wrap'
String scrollStrategyForColumn(SimpleConstraints columnConstraints) {
  throw UnimplementedError();
}
