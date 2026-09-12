import 'package:flutter/material.dart' hide ThemeData;
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_12_inherited_widget.dart) ───────────────

class AppThemeData {
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final bool isDark;

  const AppThemeData({
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    required this.isDark,
  });

  static const light = AppThemeData(
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    textColor: Colors.black87,
    isDark: false,
  );

  static const dark = AppThemeData(
    primaryColor: Colors.teal,
    backgroundColor: Color(0xFF121212),
    textColor: Colors.white,
    isDark: true,
  );

  @override
  bool operator ==(Object other) =>
      other is AppThemeData &&
      other.primaryColor == primaryColor &&
      other.isDark == isDark;

  @override
  int get hashCode => Object.hash(primaryColor, isDark);
}

class AppThemeAnswer extends InheritedWidget {
  final AppThemeData data;

  const AppThemeAnswer({
    super.key,
    required this.data,
    required super.child,
  });

  static AppThemeData of(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  bool updateShouldNotify(AppThemeAnswer oldWidget) {
    throw UnimplementedError();
  }
}

// ─── Потребитель темы ─────────────────────────────────────────────────────────

class _ThemeDisplay extends StatelessWidget {
  const _ThemeDisplay();

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeAnswer.of(context);
    return Text(
      theme.isDark ? 'dark' : 'light',
      style: TextStyle(color: theme.textColor),
    );
  }
}

class _ThemeToggleWidget extends StatefulWidget {
  const _ThemeToggleWidget();

  @override
  State<_ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<_ThemeToggleWidget> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return AppThemeAnswer(
      data: _isDark ? AppThemeData.dark : AppThemeData.light,
      child: Builder(builder: (ctx) {
        return Column(
          children: [
            const _ThemeDisplay(),
            ElevatedButton(
              key: const Key('toggle'),
              onPressed: () => setState(() => _isDark = !_isDark),
              child: const Text('Toggle'),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 12 — InheritedWidget', () {
    group('AppThemeAnswer.of()', () {
      testWidgets('Возвращает переданные данные темы', (tester) async {
        AppThemeData? capturedData;

        await tester.pumpWidget(MaterialApp(
          home: AppThemeAnswer(
            data: AppThemeData.light,
            child: Builder(builder: (ctx) {
              capturedData = AppThemeAnswer.of(ctx);
              return const SizedBox();
            }),
          ),
        ));

        expect(capturedData, equals(AppThemeData.light));
        expect(capturedData!.isDark, isFalse);
      });

      testWidgets('Передаёт тёмную тему', (tester) async {
        AppThemeData? capturedData;

        await tester.pumpWidget(MaterialApp(
          home: AppThemeAnswer(
            data: AppThemeData.dark,
            child: Builder(builder: (ctx) {
              capturedData = AppThemeAnswer.of(ctx);
              return const SizedBox();
            }),
          ),
        ));

        expect(capturedData!.isDark, isTrue);
        expect(capturedData!.textColor, equals(Colors.white));
      });
    });

    group('updateShouldNotify()', () {
      test('false когда данные одинаковы', () {
        const widget = AppThemeAnswer(
          data: AppThemeData.light,
          child: SizedBox(),
        );
        const oldWidget = AppThemeAnswer(
          data: AppThemeData.light,
          child: SizedBox(),
        );
        expect(widget.updateShouldNotify(oldWidget), isFalse);
      });

      test('true когда данные отличаются', () {
        const widget = AppThemeAnswer(
          data: AppThemeData.dark,
          child: SizedBox(),
        );
        const oldWidget = AppThemeAnswer(
          data: AppThemeData.light,
          child: SizedBox(),
        );
        expect(widget.updateShouldNotify(oldWidget), isTrue);
      });
    });

    group('Реактивность — перестройка при смене темы', () {
      testWidgets('Начально показывает светлую тему', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: _ThemeToggleWidget()),
        ));
        expect(find.text('light'), findsOneWidget);
        expect(find.text('dark'), findsNothing);
      });

      testWidgets('После переключения показывает тёмную тему', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: _ThemeToggleWidget()),
        ));
        await tester.tap(find.byKey(const Key('toggle')));
        await tester.pump();
        expect(find.text('dark'), findsOneWidget);
        expect(find.text('light'), findsNothing);
      });

      testWidgets('Двойное переключение возвращает к светлой теме', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: _ThemeToggleWidget()),
        ));
        await tester.tap(find.byKey(const Key('toggle')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('toggle')));
        await tester.pump();
        expect(find.text('light'), findsOneWidget);
      });
    });

    group('AppThemeData константы', () {
      test('light.isDark == false', () {
        expect(AppThemeData.light.isDark, isFalse);
      });

      test('dark.isDark == true', () {
        expect(AppThemeData.dark.isDark, isTrue);
      });

      test('light.textColor == black', () {
        expect(AppThemeData.light.textColor, equals(Colors.black87));
      });

      test('dark.textColor == white', () {
        expect(AppThemeData.dark.textColor, equals(Colors.white));
      });
    });
  });
}
