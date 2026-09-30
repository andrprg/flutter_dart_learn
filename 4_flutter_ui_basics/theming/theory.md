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

## 8. `Theme.of` и локальный `Theme`

`Theme.of(context)` подписывает виджет на Theme. Смена `themeMode` перестраивает подписчиков. Читать тему один раз в `initState` в поле `Color` — снимок, который не обновится при переключении dark mode. Читай в `build`.

`Theme(data:, child:)` подменяет тему поддерева. `copyWith` на `ThemeData` поверхностный: вложенный `colorScheme` заменяй явно, иначе останется старая схема, а `primaryColor` (наследие Material 2) разъедется со схемой.

В Material 3 цвет кнопки по умолчанию берётся из `colorScheme`, не из устаревшего `primaryColor`. Хардкод `ElevatedButton.styleFrom(backgroundColor: Colors.blue)` обходит тему. Чтобы покрасить все такие кнопки — `elevatedButtonTheme` в `ThemeData`.

Контраст: `onPrimary` рисуют на `primary`, `onSurface` — на `surface`. Пара `primary` + `onSurface` контраст не гарантирует. Свой `readableTextColor` нужен, когда фон произвольный (аватар, чип категории), и схема не знает этот цвет.

`lerp` у `ThemeExtension` вызывается при анимации между темами. Если вернуть `this` без интерполяции, смена темы скакнёт, пока ColorScheme едет плавно. Для `double` — `lerpDouble` из `dart:ui`.

## 9. TextTheme и масштаб шрифта

Роли (`titleMedium`, `bodyLarge`) несут и размер, и вес, и межбуквенный интервал. Менять размер точечно у одного `Text` через `style: TextStyle(fontSize: 14)` сбрасывает остальное, если не сделать `textTheme.bodyMedium?.copyWith(fontSize: 14)`.

`MediaQuery.textScalerOf` увеличивает текст настройкой ОС. Виджет с фиксированной высотой 48 под подпись обрежет крупный шрифт. `maxLines` + `overflow` или высота от текста, не от магического числа.

`ThemeData` сам подстраивает `textTheme` под масштаб, если не подменять стили жёстким `fontSize` в каждом виджете.

## 10. Типичные ошибки

- `Colors.black` для текста в dark theme — текст пропадает на тёмном фоне.
- Забыть `darkTheme` и считать, что `themeMode: dark` «как-нибудь» инвертирует light.
- `extension<AppSpacing>()!` без регистрации extension — null и краш. Для необязательного токена проверяй null или давай дефолт.
- Свой `Theme` внутри диалога не наследует твои extensions, если передал `ThemeData` с нуля, а не `Theme.of(context).copyWith`.
- Анимировать смену темы и не реализовать `lerp`.

## 11. Preview

`TextThemePreview` — пройтись по стилям темы; удобно ловить регрессии типографики.

---

Дальше: `theming_task.dart`.
