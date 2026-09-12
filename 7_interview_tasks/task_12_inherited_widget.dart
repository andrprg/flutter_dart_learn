/// ЗАДАЧА 12 — InheritedWidget и передача данных вниз по дереву
/// Уровень: Mid Flutter
/// Тема: InheritedWidget, BuildContext, dependency injection
///
/// Реализуйте без Provider/Riverpod:
///   1. [ThemeData] с полями: primaryColor, textColor, isDarkMode
///   2. [AppTheme] — InheritedWidget, хранящий ThemeData
///   3. [AppTheme.of(context)] — статический метод доступа
///   4. Виджет [ThemedText] — берёт цвет текста из AppTheme
///   5. Переключатель темы через StatefulWidget выше по дереву
///
/// Вопрос: когда вызывается updateShouldNotify и что он означает?

import 'package:flutter/material.dart' hide ThemeData;

// ─── Модель темы ─────────────────────────────────────────────────────────────

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
}

// ─── Ваше решение ────────────────────────────────────────────────────────────

class AppTheme extends InheritedWidget {
  final AppThemeData data;

  const AppTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static AppThemeData of(BuildContext context) {
    // TODO: реализуйте получение темы из контекста
    throw UnimplementedError();
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    // TODO: когда нужно оповещать потомков?
    throw UnimplementedError();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class AppThemeAnswer extends InheritedWidget {
  final AppThemeData data;

  const AppThemeAnswer({
    super.key,
    required this.data,
    required super.child,
  });

  static AppThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppThemeAnswer>();
    assert(widget != null, 'AppTheme не найден в дереве виджетов');
    return widget!.data;
  }

  @override
  bool updateShouldNotify(AppThemeAnswer oldWidget) => data != oldWidget.data;
}

// ─── Виджеты-потребители ─────────────────────────────────────────────────────

class ThemedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ThemedText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeAnswer.of(context);
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(color: theme.textColor),
    );
  }
}

// ─── Точка входа ─────────────────────────────────────────────────────────────

class ThemeToggleApp extends StatefulWidget {
  const ThemeToggleApp({super.key});
  @override
  State<ThemeToggleApp> createState() => _ThemeToggleAppState();
}

class _ThemeToggleAppState extends State<ThemeToggleApp> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    final themeData = _isDark ? AppThemeData.dark : AppThemeData.light;
    return AppThemeAnswer(
      data: themeData,
      child: Builder(builder: (ctx) {
        final theme = AppThemeAnswer.of(ctx);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: AppBar(
              title: const Text('InheritedWidget'),
              backgroundColor: theme.primaryColor,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ThemedText(
                    'Текущая тема: ${theme.isDark ? "Тёмная" : "Светлая"}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 24),
                  Switch(
                    value: _isDark,
                    onChanged: (v) => setState(() => _isDark = v),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

void main() => runApp(const ThemeToggleApp());
