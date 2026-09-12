import 'package:flutter/material.dart';

// ============================================================
// 12 ЗАДАЧ ПО THEMING И MATERIAL 3
// ============================================================
// Цель: освоить ColorScheme, ThemeData, ThemeExtension,
// dark/light themes и локальную переопределяемость темы.

// ЗАДАЧА 1
// Создай light theme на основе seedColor.
ThemeData buildLightTheme(Color seedColor) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Создай dark theme на основе seedColor.
ThemeData buildDarkTheme(Color seedColor) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Создай ThemeExtension AppSpacing.
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.small,
    required this.medium,
    required this.large,
  });

  final double small;
  final double medium;
  final double large;

  @override
  AppSpacing copyWith({
    double? small,
    double? medium,
    double? large,
  }) {
    throw UnimplementedError();
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 4
// Достань AppSpacing из Theme.of(context).extension<AppSpacing>().
AppSpacing spacingOf(BuildContext context) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Создай AppThemeScope, который добавляет AppSpacing в текущую тему.
class AppThemeScope extends StatelessWidget {
  const AppThemeScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 6
// Создай ThemeToggleButton, который вызывает onChanged с новым ThemeMode.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 7
// Карточка, которая использует цвета colorScheme.surfaceContainerHighest.
class ThemedInfoCard extends StatelessWidget {
  const ThemedInfoCard({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8
// Создай TextTheme preview экран.
class TextThemePreview extends StatelessWidget {
  const TextThemePreview({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9
// Локально переопредели primary color только для child.
class LocalPrimaryColor extends StatelessWidget {
  const LocalPrimaryColor({
    required this.color,
    required this.child,
    super.key,
  });

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Верни контрастный цвет текста для фона.
Color readableTextColor(Color background) {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Создай ChipThemeData для фильтров.
ChipThemeData buildFilterChipTheme(ColorScheme colorScheme) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Создай ThemeData с общими стилями кнопок.
ThemeData buildButtonTheme(Color seedColor) {
  throw UnimplementedError();
}
