import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../task_23_slivers.dart';

void main() {
  group('Task 23 Slivers', () {
    testWidgets('GoodSliversScreen uses one CustomScrollView with slivers', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GoodSliversScreen(),
        ),
      );

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.byType(SliverList), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.text('Item 0'), findsOneWidget);
    });
  });
}
