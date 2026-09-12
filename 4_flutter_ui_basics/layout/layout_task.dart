// ignore_for_file: unused_import
import 'package:flutter/material.dart';

// ============================================================
// 20 ЗАДАЧ ПО LAYOUT FLUTTER
// ============================================================
// Зависимости (pubspec.yaml):
//   dependencies:
//     flutter:
//       sdk: flutter
//   dev_dependencies:
//     flutter_test:
//       sdk: flutter
//
// Запуск тестов:
//   flutter test flutter/layout/layout_task_test.dart
// ============================================================

/// ─── Базовый уровень (1–5) ───────────────────────────────────────────────────

// ЗАДАЧА 1
// Создай StatelessWidget ProfileCard.
// Отображай Row из:
//   — CircleAvatar (radius: 28, синий фон, буква "М" белым цветом)
//   — SizedBox(width: 12)
//   — Column (crossAxisAlignment: CrossAxisAlignment.start) с:
//       • Text "Мария Петрова" (FontWeight.bold, fontSize: 16)
//       • Text "Flutter Dev"   (Colors.grey, fontSize: 14)
//
// Подсказка: Row, Column, CircleAvatar, CrossAxisAlignment, TextStyle.

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children : [
        CircleAvatar(radius: 28, backgroundColor: Colors.blue, child: Text('М', style: TextStyle(color: Colors.white),),),
        SizedBox(width: 12,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('Мария Петрова', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('Flutter Dev', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ])
      ]      
    );
  }
}

// ЗАДАЧА 2
// Создай StatelessWidget NotificationBadge.
// Stack из:
//   — Icon(Icons.notifications, size: 40)
//   — Positioned(right: 0, top: 0): CircleAvatar(radius: 10,
//     красный фон, Text "5" белым цветом, fontSize: 10)
//
// Подсказка: Stack, Positioned, CircleAvatar.

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context) {
   return Stack(children: [
    Icon(Icons.notifications, size: 40),
    Positioned(right: 0, top: 0, child: CircleAvatar(radius: 10, backgroundColor: Colors.red, 
      child: Text('5', style: TextStyle(color: Colors.white, fontSize: 10)))),
   ]);
  }
}

// ЗАДАЧА 3
// Создай StatelessWidget GradientCard.
// Container (width: 200, height: 100) с BoxDecoration:
//   — LinearGradient от Colors.blue до Colors.purple (слева направо)
//   — borderRadius: BorderRadius.circular(16)
//   — boxShadow: offset (0, 4), blurRadius: 12,
//     цвет Colors.blue.withOpacity(0.4)
// По центру — Text "Premium" (белый, FontWeight.bold, fontSize: 18).
//
// Подсказка: BoxDecoration, LinearGradient, BorderRadius, BoxShadow.

class GradientCard extends StatelessWidget {
  const GradientCard({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 4
// Создай StatelessWidget FlexNavBar.
// Row с тремя Expanded и коэффициентами flex 2 : 1 : 2.
// Каждый Expanded оборачивает Container высотой 48 с текстом по центру:
//   flex=2 → "Главная" (Colors.blue[100])
//   flex=1 → "Поиск"   (Colors.green[100])
//   flex=2 → "Профиль" (Colors.orange[100])
//
// Подсказка: Row, Expanded(flex: ...), Container, Alignment.center.

class FlexNavBar extends StatelessWidget {
  const FlexNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 5
// Создай StatelessWidget FilterTagCloud.
// Wrap (spacing: 8, runSpacing: 8) из 6 тегов:
//   "Flutter", "Dart", "Mobile", "UI/UX", "Animations", "State"
// Каждый тег — Chip с соответствующим label.
//
// Подсказка: Wrap, Chip, List.map.

class FilterTagCloud extends StatelessWidget {
  const FilterTagCloud({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

/// ─── Средний уровень (6–12) ──────────────────────────────────────────────────

// ЗАДАЧА 6
// Создай StatelessWidget PercentButton.
// Center → FractionallySizedBox(widthFactor: 0.8)
//         → ElevatedButton с текстом "Войти".
// Кнопка должна занимать ровно 80% доступной ширины.
//
// Подсказка: Center, FractionallySizedBox(widthFactor: 0.8).

class PercentButton extends StatelessWidget {
  const PercentButton({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 7
// Создай StatelessWidget EqualHeightRow.
// IntrinsicHeight → Row из:
//   — Expanded: Column с Text "Левая" (жирный) и 3-строчным lorem-текстом.
//   — VerticalDivider()
//   — Expanded: Column с Text "Правая" (жирный) и 1-строчным текстом.
// Обе колонки должны растянуться до одинаковой высоты.
//
// Подсказка: IntrinsicHeight, Row, Expanded, VerticalDivider.

class EqualHeightRow extends StatelessWidget {
  const EqualHeightRow({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8
// Создай StatelessWidget ScrollableTileList.
// ListView.separated с 20 элементами.
// Каждый элемент — ListTile:
//   — leading: CircleAvatar с номером (Text "N")
//   — title: Text "Элемент N"
//   — subtitle: Text "Подзаголовок N"
//   — trailing: Icon(Icons.chevron_right)
// separatorBuilder: Divider(indent: 72).
//
// Подсказка: ListView.separated, ListTile, Divider.

class ScrollableTileList extends StatelessWidget {
  const ScrollableTileList({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9
// Создай StatelessWidget PhotoGrid.
// GridView.builder: 12 ячеек, 2 колонки, childAspectRatio: 1.0.
// Каждая ячейка — Container с цветом
//   Colors.primaries[index % Colors.primaries.length]
// По центру — Text "Фото N" (белый, FontWeight.bold).
//
// Подсказка: GridView.builder, SliverGridDelegateWithFixedCrossAxisCount,
//            Colors.primaries.

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Создай StatelessWidget SliverCatalogPage.
// Scaffold → CustomScrollView с:
//   — SliverAppBar(expandedHeight: 200, floating: false, pinned: true,
//       flexibleSpace: FlexibleSpaceBar(title: Text("Каталог")))
//   — SliverList: 10 Card с Text "Товар N" по центру.
//
// Подсказка: CustomScrollView, SliverAppBar, SliverList,
//            SliverChildBuilderDelegate.

class SliverCatalogPage extends StatelessWidget {
  const SliverCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Создай StatelessWidget AdaptiveColumns.
// LayoutBuilder:
//   — если constraints.maxWidth < 600 → ListView (1 колонка)
//   — если constraints.maxWidth >= 600 → GridView (2 колонки)
// 6 элементов: Card с Text "Элемент N" по центру.
//
// Подсказка: LayoutBuilder, BoxConstraints, GridView.builder, ListView.builder.

class AdaptiveColumns extends StatelessWidget {
  const AdaptiveColumns({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 12
// Создай StatelessWidget OrientationAwareLayout.
// OrientationBuilder:
//   — portrait:  Column с двумя Expanded (серый Container + Text "Описание")
//   — landscape: Row    с двумя Expanded (серый Container + Text "Описание")
// Серый Container — заглушка изображения (Colors.grey[300]).
//
// Подсказка: OrientationBuilder, Orientation.portrait, Expanded.

class OrientationAwareLayout extends StatelessWidget {
  const OrientationAwareLayout({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

/// ─── Продвинутый уровень (13–20) ─────────────────────────────────────────────

// ЗАДАЧА 13
// Создай StatelessWidget ClippedAvatar.
// Stack:
//   — ClipRRect(borderRadius: 24) → Container 80x80 синего цвета.
//   — Positioned(right: 0, bottom: 0):
//       ClipOval → Container 20x20 оранжевого цвета.
//
// Подсказка: Stack, ClipRRect, ClipOval, Positioned, Container.

class ClippedAvatar extends StatelessWidget {
  const ClippedAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 14
// Создай StatelessWidget RotatedPriceTag.
// Transform.rotate(angle: -0.3) оборачивает Container:
//   — padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6)
//   — цвет фона: Colors.red
//   — borderRadius: 8
//   — Text "-20%" (белый, FontWeight.bold)
//
// Подсказка: Transform.rotate, angle в радианах (import 'dart:math' если нужно pi).

class RotatedPriceTag extends StatelessWidget {
  const RotatedPriceTag({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 15
// Создай StatelessWidget OverlappingAvatars.
// SizedBox(height: 40) → Stack(clipBehavior: Clip.none) из 4 CircleAvatar:
//   — radius: 20
//   — цвета: [Colors.red, Colors.blue, Colors.green, Colors.orange]
//   — каждый Positioned(left: index * 30.0)
//
// Подсказка: Stack, Positioned, List.generate, SizedBox.

class OverlappingAvatars extends StatelessWidget {
  const OverlappingAvatars({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 16
// Создай StatefulWidget ExpandableCard.
// Card с:
//   — Row: Text "Детали" (жирный) + Spacer + IconButton(Icons.expand_more/less)
//   — AnimatedContainer (duration: 300ms, curve: Curves.easeInOut):
//       height: _isExpanded ? 100 : 0
//       child: Text с описанием (overflow: TextOverflow.hidden)
// Нажатие IconButton переключает _isExpanded.
//
// Подсказка: AnimatedContainer, setState, Curves.easeInOut.

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({super.key});

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 17
// Создай StatelessWidget ProgressBar и CustomPainter ProgressPainter.
// ProgressBar принимает double progress (0.0–1.0).
// CustomPaint (height: 20, width: double.infinity) рисует через ProgressPainter:
//   — фоновая полоска: RRect высотой 8, Colors.grey[300], радиус 4
//   — цветная полоска: ширина = size.width * progress, Colors.blue, радиус 4
//
// Подсказка: CustomPainter, Canvas.drawRRect, RRect.fromRectAndRadius, Paint.

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;

  const ProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    throw UnimplementedError();
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ЗАДАЧА 18
// Создай StatelessWidget PriceCard — карточка товара.
// Column:
//   — Container(height: 120, color: Colors.grey[300]) — заглушка фото
//   — Padding → Column:
//       • Text "Наушники Pro" (FontWeight.bold, fontSize: 16)
//       • Row: Text "₽2 990" (синий, жирный, 18px) + Spacer +
//              Text "₽4 990" (серый, TextDecoration.lineThrough)
//       • Row: 5× Icon(Icons.star, size: 16, Colors.amber) + Text " (128)"
//
// Подсказка: Column, Row, Spacer, TextDecoration.lineThrough, List.generate.

class PriceCard extends StatelessWidget {
  const PriceCard({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 19
// Создай StatelessWidget SwipeableListItem.
// Dismissible (key: ValueKey('item')):
//   — ListTile: Text "Элемент списка"
//   — background: зелёный Container с Icon(Icons.check, белый) слева
//   — secondaryBackground: красный Container с Icon(Icons.delete, белый) справа
//   — onDismissed: вызывает переданный onDeleted callback
// Конструктор принимает required VoidCallback onDeleted.
//
// Подсказка: Dismissible, background, secondaryBackground, DismissDirection.

class SwipeableListItem extends StatelessWidget {
  final VoidCallback onDeleted;

  const SwipeableListItem({super.key, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 20
// Создай StatelessWidget StoreFrontPage — финальный экран магазина.
// Scaffold → CustomScrollView с:
//   — SliverAppBar(expandedHeight: 250, pinned: true,
//       flexibleSpace: FlexibleSpaceBar(title: Text("Магазин")))
//   — SliverToBoxAdapter: SingleChildScrollView(scrollDirection: Axis.horizontal)
//       с Row из 5 FilterChip: "Все", "Новинки", "Скидки", "Топ", "Избранное"
//   — SliverPadding(padding: EdgeInsets.all(8)) →
//       SliverGrid(2 колонки, childAspectRatio: 0.7): 6 PriceCard (из задачи 18)
//
// Подсказка: SliverToBoxAdapter, SliverPadding, SliverGrid,
//            SliverGridDelegateWithFixedCrossAxisCount, FilterChip.

class StoreFrontPage extends StatelessWidget {
  const StoreFrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
