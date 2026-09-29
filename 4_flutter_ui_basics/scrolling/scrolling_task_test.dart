import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'scrolling_task.dart';

class _FixedMetrics extends FixedScrollMetrics {
  _FixedMetrics({
    required super.minScrollExtent,
    required super.maxScrollExtent,
    required super.pixels,
    required super.viewportDimension,
    required super.axisDirection,
    required super.devicePixelRatio,
  });
}

void main() {
  group('Scrolling helpers', () {
    test('scrollProgress и isNearEnd', () {
      final mid = _FixedMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 1000,
        pixels: 250,
        viewportDimension: 400,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1,
      );
      expect(scrollProgress(mid), 0.25);
      expect(isNearEnd(mid, threshold: 200), isFalse);

      final near = _FixedMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 1000,
        pixels: 850,
        viewportDimension: 400,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1,
      );
      expect(isNearEnd(near, threshold: 200), isTrue);

      final empty = _FixedMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 0,
        pixels: 0,
        viewportDimension: 400,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1,
      );
      expect(scrollProgress(empty), 0);
    });

    test('shouldLoadMore / pageIndex / overscrollEdge', () {
      final near = _FixedMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 1000,
        pixels: 900,
        viewportDimension: 400,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1,
      );

      expect(
        shouldLoadMore(metrics: near, isLoading: false, hasMore: true),
        isTrue,
      );
      expect(
        shouldLoadMore(metrics: near, isLoading: true, hasMore: true),
        isFalse,
      );

      expect(pageIndexForOffset(0, 200), 0);
      expect(pageIndexForOffset(250, 200), 1);
      expect(() => pageIndexForOffset(0, 0), throwsArgumentError);

      expect(
        overscrollEdge(
          _FixedMetrics(
            minScrollExtent: 0,
            maxScrollExtent: 100,
            pixels: -10,
            viewportDimension: 50,
            axisDirection: AxisDirection.down,
            devicePixelRatio: 1,
          ),
        ),
        'top',
      );
      expect(
        overscrollEdge(
          _FixedMetrics(
            minScrollExtent: 0,
            maxScrollExtent: 100,
            pixels: 120,
            viewportDimension: 50,
            axisDirection: AxisDirection.down,
            devicePixelRatio: 1,
          ),
        ),
        'bottom',
      );
    });

    test('ScrollController create/dispose', () {
      final c = createScrollController(initialOffset: 12);
      expect(c.initialScrollOffset, 12);
      disposeScrollController(c);
    });

    testWidgets('ProgressHeader показывает процент', (tester) async {
      final metrics = _FixedMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 100,
        pixels: 42,
        viewportDimension: 50,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1,
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ProgressHeader(metrics: metrics))),
      );
      expect(find.text('42%'), findsOneWidget);
    });

    testWidgets('NumbersList и RefreshableList', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumbersList(items: const [1, 2, 3], controller: controller),
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      var refreshed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RefreshableList(
              items: const ['a', 'b'],
              onRefresh: () async {
                refreshed = true;
              },
            ),
          ),
        ),
      );
      expect(find.byType(RefreshIndicator), findsOneWidget);
      await tester.fling(find.text('a'), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
    });

    testWidgets('SimplePager показывает страницы', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SimplePager(itemCount: 3)),
        ),
      );
      expect(find.text('0'), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('LoadMoreListener вызывает onLoadMore', (tester) async {
      var loads = 0;
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 200,
              child: LoadMoreListener(
                isLoading: false,
                hasMore: true,
                threshold: 50,
                onLoadMore: () => loads++,
                child: ListView.builder(
                  controller: controller,
                  itemCount: 40,
                  itemBuilder: (_, i) => SizedBox(
                    height: 40,
                    child: Text('item-$i'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      controller.jumpTo(controller.position.maxScrollExtent);
      await tester.pump();
      // Триггерим ScrollUpdateNotification жестом.
      await tester.drag(find.byType(ListView), const Offset(0, -80));
      await tester.pump();
      expect(loads, greaterThan(0));
    });
  });
}
