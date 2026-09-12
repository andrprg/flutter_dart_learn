import 'package:flutter/material.dart';

// ============================================================
// 12 ЗАДАЧ ПО RESPONSIVE И ADAPTIVE UI
// ============================================================
// Цель: освоить LayoutBuilder, MediaQuery, breakpoints,
// adaptive navigation и разные представления одних данных.

enum WindowSizeClass {
  compact,
  medium,
  expanded,
}

// ЗАДАЧА 1
// Верни size class по ширине: <600 compact, <840 medium, иначе expanded.
WindowSizeClass sizeClassForWidth(double width) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Верни количество колонок: compact=1, medium=2, expanded=3.
int columnsForSizeClass(WindowSizeClass sizeClass) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Виджет AdaptiveScaffold:
// compact -> BottomNavigationBar, medium/expanded -> NavigationRail.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 4
// ResponsiveGrid строит GridView с колонками по ширине.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 5
// MasterDetail: compact показывает только список или деталь,
// expanded показывает список и деталь рядом.
class MasterDetail extends StatelessWidget {
  const MasterDetail({
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    super.key,
  });

  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 6
// Верни horizontal padding по ширине экрана.
double pageHorizontalPadding(double width) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Ограничь ширину контента maxWidth=720 и центрируй.
class MaxWidthContent extends StatelessWidget {
  const MaxWidthContent({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8
// ResponsiveText меняет fontSize по size class.
class ResponsiveText extends StatelessWidget {
  const ResponsiveText({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9
// AdaptiveDialogContent ограничивает высоту и добавляет scroll.
class AdaptiveDialogContent extends StatelessWidget {
  const AdaptiveDialogContent({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// OrientationAwareLayout меняет расположение в portrait/landscape.
class OrientationAwareLayout extends StatelessWidget {
  const OrientationAwareLayout({
    required this.top,
    required this.bottom,
    super.key,
  });

  final Widget top;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// ImageCard выбирает aspectRatio по ширине.
double imageAspectRatio(double width) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// BreakpointDebugBanner показывает текущий size class.
class BreakpointDebugBanner extends StatelessWidget {
  const BreakpointDebugBanner({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
