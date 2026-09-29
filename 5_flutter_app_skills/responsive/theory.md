# Шпаргалка: Responsive и Adaptive UI

**Responsive** — один layout тянется (колонки, padding, шрифт). **Adaptive** — меняется паттерн UI: на телефоне bottom bar, на планшете NavigationRail, на десктопе master-detail. Часто нужны оба подхода сразу.

Перед задачами прочитай этот файл, затем решай `responsive_task.dart`.

## 1. Breakpoints (size class)

Ориентир Material / Windows size classes:

| Ширина | Класс | Колонки |
|---|---|---|
| `< 600` | compact | 1 |
| `< 840` | medium | 2 |
| `≥ 840` | expanded | 3 |

```dart
WindowSizeClass sizeClassForWidth(double width) {
  if (width < 600) return WindowSizeClass.compact;
  if (width < 840) return WindowSizeClass.medium;
  return WindowSizeClass.expanded;
}
```

Берёшь ширину из `LayoutBuilder` (доступное место) или `MediaQuery.sizeOf(context)` (экран). Для вложенных панелей предпочтительнее `LayoutBuilder`.

## 2. Adaptive navigation

```dart
@override
Widget build(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  final compact = sizeClassForWidth(width) == WindowSizeClass.compact;

  if (compact) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        items: const [ /* ... */ ],
      ),
    );
  }
  return Scaffold(
    body: Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: const [ /* ... */ ],
        ),
        Expanded(child: body),
      ],
    ),
  );
}
```

## 3. Master-detail

На compact: либо список, либо деталь (навигация). На expanded: список слева + деталь справа.

```dart
if (sizeClass == WindowSizeClass.compact) {
  return selectedItem == null ? list : detail;
}
return Row(children: [
  SizedBox(width: 320, child: list),
  Expanded(child: detail ?? placeholder),
]);
```

## 4. Ограничение ширины и padding

На широких экранах контент не должен тянуться на весь монитор:

```dart
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 720),
    child: child,
  ),
);
```

Padding растёт с шириной (например 16 → 24 → 32). Шрифты — через size class или `MediaQuery.textScaler`.

## 5. Orientation и SafeArea

```dart
final orientation = MediaQuery.orientationOf(context);
// portrait: Column(top, bottom)
// landscape: Row(top, bottom)
```

- `SafeArea` — вырезы, статус-бар, home indicator.
- `viewInsets` — клавиатура; учитывай при формах и bottom sheets.
- `FittedBox` — крайний случай (масштабировать «впихнуть»); лучше перестроить layout.

## 6. Тестирование

`tester.binding.setSurfaceSize(Size(390, 844))` / `Size(1280, 800)` + `pumpWidget` — проверяешь, что на compact виден BottomNav, на expanded — rail и две колонки.

## 7. Зачем это знать

- Responsive ≠ adaptive: растягивать и менять паттерн — разные решения.
- Breakpoints — договорённость команды (часто 600 / 840).
- Master-detail — главный win на планшетах.
- Не забывай text scale и SafeArea — это тоже «responsive».

Дальше по маршруту: `responsive_task.dart` → `interview_questions.md`.
