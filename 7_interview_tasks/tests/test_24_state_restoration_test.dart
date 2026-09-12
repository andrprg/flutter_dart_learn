import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../task_24_state_restoration.dart';

void main() {
  group('Task 24 State Restoration', () {
    testWidgets('answer screen shows restorable counter and text field', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          restorationScopeId: 'app',
          home: RestorableNotesScreenAnswer(),
        ),
      );

      expect(find.text('Counter: 0'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      await tester.tap(find.text('+1'));
      await tester.pump();

      expect(find.text('Counter: 1'), findsOneWidget);
    });
  });
}
