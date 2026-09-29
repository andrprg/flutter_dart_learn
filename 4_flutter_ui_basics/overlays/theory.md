# Шпаргалка: Overlays (SnackBar, Dialog, BottomSheet)

Перед задачами прочитай этот файл, затем решай `overlays_task.dart`.

Оверлеи — feedback и модалки поверх текущего экрана. Важно: **кто показывает** (`ScaffoldMessenger` vs `Navigator`) и **как вернуть результат**.

## 1. SnackBar через ScaffoldMessenger

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message),
    backgroundColor: isError ? Colors.red.shade700 : null,
    action: actionLabel == null
        ? null
        : SnackBarAction(label: actionLabel, onPressed: () {}),
  ),
);
```

Старый `Scaffold.of(context).showSnackBar` устарел: мессенджер переживает смену Scaffold (полезно при навигации).

Пустой `message.trim()` — невалиден (`ArgumentError` / не показывать). Action — опциональная кнопка на баре («Отменить»).

## 2. showDialog и Future

```dart
final result = await showDialog<bool>(
  context: context,
  barrierDismissible: true,
  builder: (ctx) => ConfirmDialog(title: 'Удалить?'),
);
// result: true / false / null (тап по barrier)
```

В диалоге: `Navigator.pop(context, true)` / `false`. `null` при dismiss через barrier обычно трактуй как **canceled**.

`barrierDismissible: false` — нельзя закрыть тапом снаружи (опасные действия: delete / logout → «жёсткий» barrier).

## 3. ConfirmDialog-паттерн

```dart
AlertDialog(
  title: Text(title),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context, false),
      child: Text(cancelText),
    ),
    TextButton(
      onPressed: () => Navigator.pop(context, true),
      child: Text(confirmText),
    ),
  ],
);
```

Обёртка `showConfirm` → `ConfirmResult.confirmed | canceled`.

## 4. Bottom sheet: modal vs ordinary

| | Modal (`showModalBottomSheet`) | Ordinary (`showBottomSheet`) |
|---|---|---|
| Barrier | Да, блокирует фон | Нет, часть Scaffold |
| Результат | `Future<T?>` | через Scaffold/controller |
| Типичный UX | выбор, форма, меню | persistent панель |

```dart
final value = await showModalBottomSheet<T>(
  context: context,
  isDismissible: true,
  builder: builder,
);
```

Контент: `SimpleBottomSheet(title, child)` + padding. Результат: `Navigator.pop(context, value)`.

## 5. Async gap и context

```dart
onPressed: () async {
  final r = await showConfirm(context, title: 'Удалить?');
  if (!context.mounted) return; // после await дерево могло уйти
  if (r == ConfirmResult.confirmed) {
    showAppSnackBar(context, SnackConfig(message: 'Удалено'));
  }
};
```

Не используй `context` после async без проверки `mounted` / `context.mounted`.

## 6. rootNavigator

`showDialog(context: context, useRootNavigator: true)` (по умолчанию часто true) кладёт диалог на **корневой** Navigator — поверх вложенных (вкладки, вложенные routes). Для диалога «на весь app» — root; для локального nested flow — `useRootNavigator: false`.

## 7. Практика модуля

- `SnackConfig` / `buildSnackBar` / `showAppSnackBar`
- `ConfirmDialog` + `showConfirm` + `needsHardBarrier`
- `showAppBottomSheet`, демо-кнопки Snack / Confirm

---

Дальше: `overlays_task.dart`.
