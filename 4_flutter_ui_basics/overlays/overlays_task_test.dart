import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'overlays_task.dart';

void main() {
  group('Overlays helpers', () {
    test('isValidSnackMessage и snackBackground', () {
      expect(isValidSnackMessage('ok'), isTrue);
      expect(isValidSnackMessage('   '), isFalse);

      expect(
        snackBackground(const SnackConfig(message: 'e', isError: true)),
        Colors.red.shade700,
      );
      expect(
        snackBackground(const SnackConfig(message: 'ok')),
        isNull,
      );
    });

    test('buildSnackBar и confirmTitleFor / needsHardBarrier', () {
      final bar = buildSnackBar(
        const SnackConfig(message: 'Hi', actionLabel: 'Undo'),
      );
      expect(bar.content, isA<Text>());
      expect(bar.action?.label, 'Undo');
      expect(
        () => buildSnackBar(const SnackConfig(message: '')),
        throwsArgumentError,
      );

      expect(confirmTitleFor('delete'), 'Удалить?');
      expect(confirmTitleFor('logout'), 'Выйти?');
      expect(() => confirmTitleFor('noop'), throwsArgumentError);

      expect(needsHardBarrier('delete'), isTrue);
      expect(needsHardBarrier('edit'), isFalse);
    });

    testWidgets('showAppSnackBar и SnackDemoButton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SnackDemoButton())),
      );
      await tester.tap(find.byType(SnackDemoButton));
      await tester.pump();
      expect(find.text('Готово'), findsOneWidget);
    });

    testWidgets('ConfirmDialog возвращает значения', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () async {
                    result = await showDialog<bool>(
                      context: context,
                      builder: (_) => const ConfirmDialog(title: 'Удалить?'),
                    );
                  },
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Удалить?'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('showConfirm и ConfirmDemoButton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ConfirmDemoButton())),
      );

      await tester.tap(find.byType(ConfirmDemoButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('Удалено'), findsOneWidget);
    });

    testWidgets('SimpleBottomSheet и showAppBottomSheet', (tester) async {
      String? sheetResult;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () async {
                    sheetResult = await showAppBottomSheet<String>(
                      context,
                      builder: (_) => SimpleBottomSheet(
                        title: 'Меню',
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, 'pick'),
                          child: const Text('pick'),
                        ),
                      ),
                    );
                  },
                  child: const Text('sheet'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Меню'), findsOneWidget);
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
      expect(sheetResult, 'pick');
    });
  });
}
