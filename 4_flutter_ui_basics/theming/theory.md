# Шпаргалка: Theming и Material 3

Перед задачами прочитай этот файл, затем решай `theming_task.dart`.

Тема — единый источник цветов, типографики и стилей компонентов. В Material 3 центр — **ColorScheme**; `ThemeData` собирает схему + TextTheme + темы кнопок/чипов.

## 1. ThemeData vs ColorScheme

```dart
ThemeData buildLightTheme(Color seedColor) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
  );
}

ThemeData buildDarkTheme(Color seedColor) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
  );
}
```

- **ColorScheme** — роли: `primary`, `surface`, `error`, `onPrimary`, `surfaceContainerHighest`…
- **ThemeData** — схема + `textTheme`, `appBarTheme`, `elevatedButtonTheme`…

`ColorScheme.fromSeed` генерирует гармоничную палитру из одного seed.

## 2. Light / dark

```dart
MaterialApp(
  theme: buildLightTheme(Colors.teal),
  darkTheme: buildDarkTheme(Colors.teal),
  themeMode: ThemeMode.system, // или light / dark
);
```

Переключатель: `ThemeToggleButton` вызывает `onChanged` с новым `ThemeMode`. Храни mode выше (State / ValueNotifier).

## 3. Чтение темы в виджетах

```dart
final scheme = Theme.of(context).colorScheme;
final text = Theme.of(context).textTheme;

Container(
  color: scheme.surfaceContainerHighest,
  child: Text(title, style: text.titleMedium),
);
```

**Не хардкодь** `Colors.blue` в фичах — бери из `colorScheme`, иначе ломается dark mode и брендинг.

Роли TextTheme: `displayLarge`…`bodySmall`, `labelLarge` — смысловые уровни, не «просто размер».

## 4. ThemeExtension

Свои токены (отступы, радиусы бренда), которых нет в ColorScheme:

```dart
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({required this.small, required this.medium, required this.large});
  final double small, medium, large;

  @override
  AppSpacing copyWith({...}) => AppSpacing(...);

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    // интерполяция для анимации смены темы
  }
}

// доступ:
Theme.of(context).extension<AppSpacing>()!;
```

Подключай через `ThemeData(extensions: [AppSpacing(...)])` или `Theme(data: theme.copyWith(extensions: ...), child: ...)`.

## 5. Локальное переопределение

```dart
Theme(
  data: Theme.of(context).copyWith(
    colorScheme: Theme.of(context).colorScheme.copyWith(primary: color),
  ),
  child: child,
);
```

Только поддерево видит новый primary (`LocalPrimaryColor`).

## 6. Компонентные темы

`ChipThemeData`, `ElevatedButtonThemeData` и т.д. — единый вид фильтров/кнопок. Контраст текста к фону: светлый/тёмный по luminance (`readableTextColor`).

## 7. Dynamic Color

На Android 12+ можно брать wallpaper palette (`dynamic_color` / platform APIs) и кормить `fromSeed` / готовую scheme. На других платформах — fallback на seed бренда.

## 8. Preview

`TextThemePreview` — пройтись по стилям темы; удобно ловить регрессии типографики.

---

Дальше: `theming_task.dart`.
