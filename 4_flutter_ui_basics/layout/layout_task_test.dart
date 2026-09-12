import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'layout_task.dart';

// ============================================================
// ТЕСТЫ ДЛЯ 20 ЗАДАЧ ПО LAYOUT FLUTTER
// ============================================================
// Запуск:
//   flutter test flutter/layout/layout_task_test.dart
//
// Тесты падают с UnimplementedError до реализации — это ожидаемо.
// Цель: реализовать виджеты так, чтобы все тесты стали зелёными.
// ============================================================

/// Вспомогательная функция — оборачивает виджет в MaterialApp + Scaffold.
Widget wrap(Widget child) => MaterialApp(
      home: Scaffold(body: child),
    );

void main() {
  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 1 — ProfileCard
  // ──────────────────────────────────────────────────────────
  group('Задача 1 — ProfileCard', () {
    testWidgets('содержит Row', (tester) async {
      await tester.pumpWidget(wrap(const ProfileCard()));
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('содержит CircleAvatar', (tester) async {
      await tester.pumpWidget(wrap(const ProfileCard()));
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('отображает "Мария Петрова"', (tester) async {
      await tester.pumpWidget(wrap(const ProfileCard()));
      expect(find.text('Мария Петрова'), findsOneWidget);
    });

    testWidgets('отображает "Flutter Dev"', (tester) async {
      await tester.pumpWidget(wrap(const ProfileCard()));
      expect(find.text('Flutter Dev'), findsOneWidget);
    });

    testWidgets('Column имеет crossAxisAlignment.start', (tester) async {
      await tester.pumpWidget(wrap(const ProfileCard()));
      final columns = tester.widgetList<Column>(find.byType(Column));
      final hasStart = columns
          .any((c) => c.crossAxisAlignment == CrossAxisAlignment.start);
      expect(hasStart, isTrue);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 2 — NotificationBadge
  // ──────────────────────────────────────────────────────────
  group('Задача 2 — NotificationBadge', () {
    testWidgets('содержит Stack', (tester) async {
      await tester.pumpWidget(wrap(const NotificationBadge()));
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('содержит иконку notifications', (tester) async {
      await tester.pumpWidget(wrap(const NotificationBadge()));
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('содержит Positioned', (tester) async {
      await tester.pumpWidget(wrap(const NotificationBadge()));
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('отображает число "5" на бейдже', (tester) async {
      await tester.pumpWidget(wrap(const NotificationBadge()));
      expect(find.text('5'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 3 — GradientCard
  // ──────────────────────────────────────────────────────────
  group('Задача 3 — GradientCard', () {
    testWidgets('содержит Container', (tester) async {
      await tester.pumpWidget(wrap(const GradientCard()));
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('отображает текст "Premium"', (tester) async {
      await tester.pumpWidget(wrap(const GradientCard()));
      expect(find.text('Premium'), findsOneWidget);
    });

    testWidgets('Container имеет BoxDecoration с LinearGradient', (tester) async {
      await tester.pumpWidget(wrap(const GradientCard()));
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasGradient = containers.any((c) {
        final dec = c.decoration;
        return dec is BoxDecoration && dec.gradient is LinearGradient;
      });
      expect(hasGradient, isTrue);
    });

    testWidgets('Container имеет boxShadow', (tester) async {
      await tester.pumpWidget(wrap(const GradientCard()));
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasShadow = containers.any((c) {
        final dec = c.decoration;
        return dec is BoxDecoration &&
            dec.boxShadow != null &&
            dec.boxShadow!.isNotEmpty;
      });
      expect(hasShadow, isTrue);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 4 — FlexNavBar
  // ──────────────────────────────────────────────────────────
  group('Задача 4 — FlexNavBar', () {
    testWidgets('содержит Row', (tester) async {
      await tester.pumpWidget(wrap(const FlexNavBar()));
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('содержит ровно 3 Expanded', (tester) async {
      await tester.pumpWidget(wrap(const FlexNavBar()));
      expect(find.byType(Expanded), findsNWidgets(3));
    });

    testWidgets('отображает "Главная", "Поиск", "Профиль"', (tester) async {
      await tester.pumpWidget(wrap(const FlexNavBar()));
      expect(find.text('Главная'), findsOneWidget);
      expect(find.text('Поиск'), findsOneWidget);
      expect(find.text('Профиль'), findsOneWidget);
    });

    testWidgets('Expanded используют flex 2, 1, 2', (tester) async {
      await tester.pumpWidget(wrap(const FlexNavBar()));
      final expanded =
          tester.widgetList<Expanded>(find.byType(Expanded)).toList();
      expect(expanded.length, 3);
      expect(expanded[0].flex, 2);
      expect(expanded[1].flex, 1);
      expect(expanded[2].flex, 2);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 5 — FilterTagCloud
  // ──────────────────────────────────────────────────────────
  group('Задача 5 — FilterTagCloud', () {
    testWidgets('содержит Wrap', (tester) async {
      await tester.pumpWidget(wrap(const FilterTagCloud()));
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('содержит ровно 6 Chip', (tester) async {
      await tester.pumpWidget(wrap(const FilterTagCloud()));
      expect(find.byType(Chip), findsNWidgets(6));
    });

    testWidgets('Wrap имеет spacing: 8 и runSpacing: 8', (tester) async {
      await tester.pumpWidget(wrap(const FilterTagCloud()));
      final w = tester.widget<Wrap>(find.byType(Wrap));
      expect(w.spacing, 8.0);
      expect(w.runSpacing, 8.0);
    });

    testWidgets('отображает все 6 тегов', (tester) async {
      await tester.pumpWidget(wrap(const FilterTagCloud()));
      for (final tag in
          ['Flutter', 'Dart', 'Mobile', 'UI/UX', 'Animations', 'State']) {
        expect(find.text(tag), findsOneWidget, reason: 'Тег "$tag" не найден');
      }
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 6 — PercentButton
  // ──────────────────────────────────────────────────────────
  group('Задача 6 — PercentButton', () {
    testWidgets('содержит FractionallySizedBox', (tester) async {
      await tester.pumpWidget(wrap(const PercentButton()));
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('FractionallySizedBox имеет widthFactor 0.8', (tester) async {
      await tester.pumpWidget(wrap(const PercentButton()));
      final fsb =
          tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox));
      expect(fsb.widthFactor, 0.8);
    });

    testWidgets('содержит ElevatedButton с текстом "Войти"', (tester) async {
      await tester.pumpWidget(wrap(const PercentButton()));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Войти'), findsOneWidget);
    });

    testWidgets('кнопка уже FractionallySizedBox в иерархии', (tester) async {
      await tester.pumpWidget(wrap(const PercentButton()));
      // ElevatedButton должен быть потомком FractionallySizedBox
      final fsbFinder = find.byType(FractionallySizedBox);
      final btnInsideFsb =
          find.descendant(of: fsbFinder, matching: find.byType(ElevatedButton));
      expect(btnInsideFsb, findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 7 — EqualHeightRow
  // ──────────────────────────────────────────────────────────
  group('Задача 7 — EqualHeightRow', () {
    testWidgets('содержит IntrinsicHeight', (tester) async {
      await tester.pumpWidget(wrap(const EqualHeightRow()));
      expect(find.byType(IntrinsicHeight), findsOneWidget);
    });

    testWidgets('содержит VerticalDivider', (tester) async {
      await tester.pumpWidget(wrap(const EqualHeightRow()));
      expect(find.byType(VerticalDivider), findsOneWidget);
    });

    testWidgets('отображает "Левая" и "Правая"', (tester) async {
      await tester.pumpWidget(wrap(const EqualHeightRow()));
      expect(find.text('Левая'), findsOneWidget);
      expect(find.text('Правая'), findsOneWidget);
    });

    testWidgets('обе колонки имеют одинаковую высоту', (tester) async {
      await tester.pumpWidget(wrap(const EqualHeightRow()));
      // Внутри IntrinsicHeight все дочерние Expanded должны иметь равную высоту
      final expanded =
          tester.widgetList<Expanded>(find.byType(Expanded)).toList();
      expect(expanded.length, greaterThanOrEqualTo(2));
      final heights = expanded
          .map((e) => tester.getSize(find.byWidget(e)).height)
          .toList();
      expect(heights[0], closeTo(heights[1], 1.0));
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 8 — ScrollableTileList
  // ──────────────────────────────────────────────────────────
  group('Задача 8 — ScrollableTileList', () {
    testWidgets('содержит ListView', (tester) async {
      await tester.pumpWidget(wrap(const ScrollableTileList()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('отображает "Элемент 1" и "Элемент 2"', (tester) async {
      await tester.pumpWidget(wrap(const ScrollableTileList()));
      expect(find.text('Элемент 1'), findsOneWidget);
      expect(find.text('Элемент 2'), findsOneWidget);
    });

    testWidgets('содержит ListTile', (tester) async {
      await tester.pumpWidget(wrap(const ScrollableTileList()));
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('содержит иконку chevron_right', (tester) async {
      await tester.pumpWidget(wrap(const ScrollableTileList()));
      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('содержит Divider-разделитель', (tester) async {
      await tester.pumpWidget(wrap(const ScrollableTileList()));
      expect(find.byType(Divider), findsWidgets);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 9 — PhotoGrid
  // ──────────────────────────────────────────────────────────
  group('Задача 9 — PhotoGrid', () {
    testWidgets('содержит GridView', (tester) async {
      await tester.pumpWidget(wrap(const PhotoGrid()));
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('отображает "Фото 1"', (tester) async {
      await tester.pumpWidget(wrap(const PhotoGrid()));
      expect(find.text('Фото 1'), findsOneWidget);
    });

    testWidgets('отображает "Фото 2"', (tester) async {
      await tester.pumpWidget(wrap(const PhotoGrid()));
      expect(find.text('Фото 2'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 10 — SliverCatalogPage
  // ──────────────────────────────────────────────────────────
  group('Задача 10 — SliverCatalogPage', () {
    testWidgets('содержит CustomScrollView', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SliverCatalogPage()));
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('содержит SliverAppBar', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SliverCatalogPage()));
      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('SliverAppBar pinned и имеет expandedHeight 200', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SliverCatalogPage()));
      final appBar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(appBar.pinned, isTrue);
      expect(appBar.expandedHeight, 200.0);
    });

    testWidgets('отображает заголовок "Каталог"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SliverCatalogPage()));
      expect(find.text('Каталог'), findsOneWidget);
    });

    testWidgets('отображает "Товар 1"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SliverCatalogPage()));
      expect(find.text('Товар 1'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 11 — AdaptiveColumns
  // ──────────────────────────────────────────────────────────
  group('Задача 11 — AdaptiveColumns', () {
    testWidgets('содержит LayoutBuilder', (tester) async {
      await tester.pumpWidget(wrap(const AdaptiveColumns()));
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('на узком экране (400px) отображает ListView', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(const AdaptiveColumns()));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('на широком экране (800px) отображает GridView', (tester) async {
      tester.view.physicalSize = const Size(800, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(const AdaptiveColumns()));
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 12 — OrientationAwareLayout
  // ──────────────────────────────────────────────────────────
  group('Задача 12 — OrientationAwareLayout', () {
    testWidgets('содержит OrientationBuilder', (tester) async {
      await tester.pumpWidget(wrap(const OrientationAwareLayout()));
      expect(find.byType(OrientationBuilder), findsOneWidget);
    });

    testWidgets('в portrait-режиме корневой виджет — Column', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(const OrientationAwareLayout()));
      // В portrait должна быть Column внутри OrientationBuilder
      final obFinder = find.byType(OrientationBuilder);
      final colInsideOb =
          find.descendant(of: obFinder, matching: find.byType(Column));
      expect(colInsideOb, findsWidgets);
    });

    testWidgets('в landscape-режиме корневой виджет — Row', (tester) async {
      tester.view.physicalSize = const Size(800, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(const OrientationAwareLayout()));
      final obFinder = find.byType(OrientationBuilder);
      final rowInsideOb =
          find.descendant(of: obFinder, matching: find.byType(Row));
      expect(rowInsideOb, findsWidgets);
    });

    testWidgets('отображает текст "Описание"', (tester) async {
      await tester.pumpWidget(wrap(const OrientationAwareLayout()));
      expect(find.text('Описание'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 13 — ClippedAvatar
  // ──────────────────────────────────────────────────────────
  group('Задача 13 — ClippedAvatar', () {
    testWidgets('содержит ClipRRect', (tester) async {
      await tester.pumpWidget(wrap(const ClippedAvatar()));
      expect(find.byType(ClipRRect), findsWidgets);
    });

    testWidgets('содержит ClipOval', (tester) async {
      await tester.pumpWidget(wrap(const ClippedAvatar()));
      expect(find.byType(ClipOval), findsWidgets);
    });

    testWidgets('содержит Stack', (tester) async {
      await tester.pumpWidget(wrap(const ClippedAvatar()));
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('ClipOval находится внутри Positioned', (tester) async {
      await tester.pumpWidget(wrap(const ClippedAvatar()));
      final positionedFinder = find.byType(Positioned);
      final clipOvalInPositioned = find.descendant(
        of: positionedFinder,
        matching: find.byType(ClipOval),
      );
      expect(clipOvalInPositioned, findsWidgets);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 14 — RotatedPriceTag
  // ──────────────────────────────────────────────────────────
  group('Задача 14 — RotatedPriceTag', () {
    testWidgets('содержит Transform', (tester) async {
      await tester.pumpWidget(wrap(const RotatedPriceTag()));
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('отображает текст "-20%"', (tester) async {
      await tester.pumpWidget(wrap(const RotatedPriceTag()));
      expect(find.text('-20%'), findsOneWidget);
    });

    testWidgets('Container имеет красный цвет фона', (tester) async {
      await tester.pumpWidget(wrap(const RotatedPriceTag()));
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasRed = containers.any((c) {
        final dec = c.decoration;
        if (dec is BoxDecoration) return dec.color == Colors.red;
        return c.color == Colors.red;
      });
      expect(hasRed, isTrue);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 15 — OverlappingAvatars
  // ──────────────────────────────────────────────────────────
  group('Задача 15 — OverlappingAvatars', () {
    testWidgets('содержит Stack', (tester) async {
      await tester.pumpWidget(wrap(const OverlappingAvatars()));
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('содержит ровно 4 CircleAvatar', (tester) async {
      await tester.pumpWidget(wrap(const OverlappingAvatars()));
      expect(find.byType(CircleAvatar), findsNWidgets(4));
    });

    testWidgets('содержит ровно 4 Positioned', (tester) async {
      await tester.pumpWidget(wrap(const OverlappingAvatars()));
      expect(find.byType(Positioned), findsNWidgets(4));
    });

    testWidgets('Stack имеет clipBehavior: Clip.none', (tester) async {
      await tester.pumpWidget(wrap(const OverlappingAvatars()));
      final stacks = tester.widgetList<Stack>(find.byType(Stack));
      final hasClipNone =
          stacks.any((s) => s.clipBehavior == Clip.none);
      expect(hasClipNone, isTrue);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 16 — ExpandableCard
  // ──────────────────────────────────────────────────────────
  group('Задача 16 — ExpandableCard', () {
    testWidgets('содержит AnimatedContainer', (tester) async {
      await tester.pumpWidget(wrap(const ExpandableCard()));
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('отображает заголовок "Детали"', (tester) async {
      await tester.pumpWidget(wrap(const ExpandableCard()));
      expect(find.text('Детали'), findsOneWidget);
    });

    testWidgets('содержит IconButton для переключения', (tester) async {
      await tester.pumpWidget(wrap(const ExpandableCard()));
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('при нажатии AnimatedContainer меняет высоту', (tester) async {
      await tester.pumpWidget(wrap(const ExpandableCard()));
      await tester.pump();

      final collapsedHeight = tester
          .getSize(find.byType(AnimatedContainer).first)
          .height;

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();

      final expandedHeight = tester
          .getSize(find.byType(AnimatedContainer).first)
          .height;

      expect(expandedHeight, greaterThan(collapsedHeight));
    });

    testWidgets('повторное нажатие сворачивает карточку', (tester) async {
      await tester.pumpWidget(wrap(const ExpandableCard()));
      await tester.pump();

      // Раскрыть
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      final expandedHeight = tester
          .getSize(find.byType(AnimatedContainer).first)
          .height;

      // Свернуть
      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();
      final collapsedHeight = tester
          .getSize(find.byType(AnimatedContainer).first)
          .height;

      expect(collapsedHeight, lessThan(expandedHeight));
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 17 — ProgressBar
  // ──────────────────────────────────────────────────────────
  group('Задача 17 — ProgressBar', () {
    testWidgets('содержит CustomPaint', (tester) async {
      await tester.pumpWidget(wrap(const ProgressBar(progress: 0.5)));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('принимает progress 0.0 без ошибок', (tester) async {
      await tester.pumpWidget(wrap(const ProgressBar(progress: 0.0)));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('принимает progress 1.0 без ошибок', (tester) async {
      await tester.pumpWidget(wrap(const ProgressBar(progress: 1.0)));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('CustomPaint использует ProgressPainter', (tester) async {
      await tester.pumpWidget(wrap(const ProgressBar(progress: 0.7)));
      final paints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
      final hasProgressPainter =
          paints.any((p) => p.painter is ProgressPainter);
      expect(hasProgressPainter, isTrue);
    });

    testWidgets('ProgressPainter хранит правильный progress', (tester) async {
      await tester.pumpWidget(wrap(const ProgressBar(progress: 0.42)));
      final paints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
      final painter = paints
          .map((p) => p.painter)
          .whereType<ProgressPainter>()
          .first;
      expect(painter.progress, closeTo(0.42, 0.001));
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 18 — PriceCard
  // ──────────────────────────────────────────────────────────
  group('Задача 18 — PriceCard', () {
    testWidgets('содержит Column', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('отображает название "Наушники Pro"', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      expect(find.text('Наушники Pro'), findsOneWidget);
    });

    testWidgets('отображает актуальную цену "₽2 990"', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      expect(find.text('₽2 990'), findsOneWidget);
    });

    testWidgets('отображает старую цену "₽4 990"', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      expect(find.text('₽4 990'), findsOneWidget);
    });

    testWidgets('старая цена имеет TextDecoration.lineThrough', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      final texts = tester.widgetList<Text>(find.text('₽4 990'));
      final hasLineThrough = texts.any((t) {
        final style = t.style;
        return style?.decoration == TextDecoration.lineThrough;
      });
      expect(hasLineThrough, isTrue);
    });

    testWidgets('отображает ровно 5 звёздных иконок', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      expect(find.byIcon(Icons.star), findsNWidgets(5));
    });

    testWidgets('отображает количество отзывов "(128)"', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      expect(find.text(' (128)'), findsOneWidget);
    });

    testWidgets('содержит Spacer между ценами', (tester) async {
      await tester.pumpWidget(wrap(const PriceCard()));
      expect(find.byType(Spacer), findsWidgets);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 19 — SwipeableListItem
  // ──────────────────────────────────────────────────────────
  group('Задача 19 — SwipeableListItem', () {
    testWidgets('содержит Dismissible', (tester) async {
      await tester.pumpWidget(wrap(SwipeableListItem(onDeleted: () {})));
      expect(find.byType(Dismissible), findsOneWidget);
    });

    testWidgets('содержит ListTile', (tester) async {
      await tester.pumpWidget(wrap(SwipeableListItem(onDeleted: () {})));
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('отображает текст "Элемент списка"', (tester) async {
      await tester.pumpWidget(wrap(SwipeableListItem(onDeleted: () {})));
      expect(find.text('Элемент списка'), findsOneWidget);
    });

    testWidgets('background содержит иконку check', (tester) async {
      await tester.pumpWidget(wrap(SwipeableListItem(onDeleted: () {})));
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('secondaryBackground содержит иконку delete', (tester) async {
      await tester.pumpWidget(wrap(SwipeableListItem(onDeleted: () {})));
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('свайп влево вызывает onDeleted', (tester) async {
      bool deleted = false;
      await tester.pumpWidget(
        wrap(SwipeableListItem(onDeleted: () => deleted = true)),
      );
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(deleted, isTrue);
    });
  });

  // ──────────────────────────────────────────────────────────
  // ЗАДАЧА 20 — StoreFrontPage
  // ──────────────────────────────────────────────────────────
  group('Задача 20 — StoreFrontPage', () {
    testWidgets('содержит CustomScrollView', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('содержит SliverAppBar', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('SliverAppBar pinned и expandedHeight 250', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      final appBar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(appBar.pinned, isTrue);
      expect(appBar.expandedHeight, 250.0);
    });

    testWidgets('отображает заголовок "Магазин"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      expect(find.text('Магазин'), findsOneWidget);
    });

    testWidgets('содержит SliverToBoxAdapter', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      expect(find.byType(SliverToBoxAdapter), findsWidgets);
    });

    testWidgets('содержит SliverGrid', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      expect(find.byType(SliverGrid), findsOneWidget);
    });

    testWidgets('отображает FilterChip "Все"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      expect(find.text('Все'), findsOneWidget);
    });

    testWidgets('отображает все 5 FilterChip категорий', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      for (final label in ['Все', 'Новинки', 'Скидки', 'Топ', 'Избранное']) {
        expect(find.text(label), findsOneWidget,
            reason: 'FilterChip "$label" не найден');
      }
    });

    testWidgets('сетка содержит карточки PriceCard', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: StoreFrontPage()));
      expect(find.byType(PriceCard), findsWidgets);
    });
  });
}
