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

## 7. `LayoutBuilder` против размера экрана

`MediaQuery.sizeOf` — размер окна целиком, включая место под барами, если ты смотришь не ту метрику. `LayoutBuilder` даёт max constraints **этого** слота. Панель на 320 px внутри expanded-окна 1400 px должна верстать себя как compact, хотя телефонным устройство не является. Для навигации приложения берут ширину окна. Для карточки в боковой колонке — ширину слота.

Ориентация не равна size class. Телефон в landscape может перейти порог 600 и внезапно получить rail. Это нормально, если пороги завязаны на ширину. Если rail на телефоне в landscape не нужен — смотри меньшую сторону окна (`shortestSide`), а не текущую ширину.

`Flexible` и доля ширины не заменяют breakpoints, когда меняется **структура** (список вместо сетки, одна колонка вместо двух). Доля ширины — responsive внутри одного паттерна.

Текст и тач: при крупном шрифте две колонки по 300 px могут стать тесными раньше, чем сработает breakpoint. Имеет смысл проверять не только ширину, но и что подпись не обрезана. `FittedBox` уменьшит текст и ударит по доступности. Лучше перенос строки и другая компоновка.

## 8. Master-detail и навигация

На compact выбор элемента — это `go` на маршрут детали, Back возвращает список. На expanded тот же выбор меняет правую панель и URL (`/items/3`), список остаётся на экране. Один `selectedId` обслуживает оба режима, иначе на повороте экрана выбор потеряется.

Пустое состояние справа («выберите элемент») нужно только на expanded. На compact пустая деталь без выбора не показывается: показывают список.

`NavigationRail` не прячет `body` сам. Ширину рельса вычитают из ряда через `Expanded` у контента. `BottomNavigationBar` забирает высоту у body через `Scaffold`, не через `Column` вручную.

Поворот и `SafeArea`: вырез камеры в landscape оказывается сбоку. `SafeArea` со всех сторон проще, чем ручной padding «сверху 24». Внутри уже безопасного scaffold второй `SafeArea` удваивает отступ.

## 9. Типичные ошибки

- Захардкодить `600` в десяти виджетах. Одна функция `sizeClassForWidth`.
- Слушать только `OrientationBuilder` и считать это адаптивностью. Портретный планшет шире телефона.
- `Center` + `maxWidth` забыть у длинной строки формы на десктопе — поля на всю 4K-ширину.
- Тест без `setSurfaceSize` гоняет один размер по умолчанию и не видит сломанный rail.
- Прятать смысл за шириной: на compact пропадает единственная кнопка «создать», потому что её положили только в rail.

## 10. Зачем это знать

- Responsive ≠ adaptive: растягивать и менять паттерн — разные решения.
- Breakpoints — договорённость команды (часто 600 / 840).
- Master-detail — главный win на планшетах.
- Не забывай text scale и SafeArea — это тоже «responsive».

Дальше по маршруту: `responsive_task.dart` → `interview_questions.md`.
