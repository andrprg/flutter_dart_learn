import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'focus_node_task.dart';

void main() {
  group('FocusNode helpers', () {
    test('createLabeledFocusNode задаёт debugLabel', () {
      final node = createLabeledFocusNode('email');
      addTearDown(node.dispose);

      expect(node.debugLabel, 'email');
    });

    testWidgets('requestFieldFocus и clearFieldFocus управляют фокусом', (
      tester,
    ) async {
      final node = FocusNode();
      addTearDown(node.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(focusNode: node),
          ),
        ),
      );

      requestFieldFocus(node);
      await tester.pump();
      expect(isNodeFocused(node), isTrue);

      clearFieldFocus(node);
      await tester.pump();
      expect(isNodeFocused(node), isFalse);
    });

    test('disposeFocusNode освобождает FocusNode', () {
      final node = FocusNode();
      disposeFocusNode(node);

      expect(() => node.hasFocus, throwsFlutterError);
    });

    test('canRequestFocusWhen зависит от enabled', () {
      expect(canRequestFocusWhen(true), isTrue);
      expect(canRequestFocusWhen(false), isFalse);
    });

    test('focusOrderForIndex создаёт NumericFocusOrder', () {
      expect(focusOrderForIndex(3).order, 3);
    });
  });
}
