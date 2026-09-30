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

## 7. Очередь SnackBar и время жизни

`ScaffoldMessenger` показывает один SnackBar и держит очередь. Второй `showSnackBar`, пока первый на экране, встанет следующим, а не заменит его, если не вызвать `hideCurrentSnackBar`. Для ошибок «сохранить не удалось» часто прячут текущий, чтобы не копить три одинаковых плашки.

`SnackBar` с `duration` сам исчезает. С `action` пользователь может не успеть — длительность увеличивают. `SnackBarAction.onPressed` вызывается и бар закрывается. Повторный показ из `build`, потому что `hasError == true`, откроет бесконечную очередь: показ — в колбэке или `ref.listen`, когда флаг **стал** true.

Мессенджер ищут вверх по дереву. `ScaffoldMessenger` обычно стоит внутри `MaterialApp`. Вызов из диалога, который лежит на root navigator, всё ещё находит мессенджер приложения — в этом смысл отказа от `Scaffold.of`.

## 8. Dialog, фокус и вложенные navigator

`showDialog` пушит route. Системная кнопка Back вызывает `pop` и завершает Future значением `null`, если не передал результат. `PopScope` / `WillPopScope` на маршруте диалога перехватывает этот Back, когда закрытие надо запретить (несохранённая форма).

`barrierDismissible: false` не блокирует Back само по себе на всех платформах одинаково предсказуемо для пользователя: на Android Back — это pop route. Для «только кнопками» обрабатывай и barrier, и pop.

`useRootNavigator: true` кладёт диалог над вкладками. Закрытие: `Navigator.of(context, rootNavigator: true).pop(result)`. Если показать с root, а закрыть вложенным `Navigator.pop(context)`, закроется вкладка под диалогом, диалог останется. Бери `context`, который `builder` диалога получил, — он уже на нужном навигаторе. Это самый спокойный вариант.

Bottom sheet — тоже route (`ModalBottomSheetRoute`). Клавиатура и `isScrollControlled: true` нужны, когда внутри поля: иначе лист короткий, поле под клавиатурой. `DraggableScrollableSheet` — лист, который тянется на всю высоту и скроллит контент.

## 9. Типичные ошибки

- Считать `null` из `showDialog` подтверждением. Это отмена.
- `await showDialog` и дальше `setState` без `mounted`.
- Показать диалог из `initState` напрямую — нет overlay. Только `addPostFrameCallback` или после кадра.
- Два `ScaffoldMessenger` (свой на экране и от `MaterialApp`) — SnackBar уезжает не в тот.
- Тяжёлая работа в `builder` диалога на каждый rebuild route.

## 10. Практика модуля

- `SnackConfig` / `buildSnackBar` / `showAppSnackBar`
- `ConfirmDialog` + `showConfirm` + `needsHardBarrier`
- `showAppBottomSheet`, демо-кнопки Snack / Confirm

---

Дальше: `overlays_task.dart`.
