# Шпаргалка: FocusNode во Flutter

Фокус — кто сейчас принимает клавиатуру и кто подсвечен для a11y/TV/desktop. `FocusNode` — ручка к узлу фокуса; `FocusScope` — область, внутри которой Tab ходит по детям.

Перед задачами прочитай этот файл, затем решай `focus_node_task.dart`.

## 1. Создание и dispose

```dart
final node = FocusNode(debugLabel: 'email');

node.requestFocus(); // взять фокус
node.unfocus();      // снять с этого node
FocusManager.instance.primaryFocus?.unfocus(); // снять primary

node.dispose(); // обязательно, если создавал сам
```

Созданный тобой `FocusNode` / `FocusScopeNode` — как `TextEditingController`: **dispose в `State.dispose`**.

## 2. Слушатель фокуса

```dart
@override
void initState() {
  super.initState();
  widget.focusNode.addListener(_onFocus);
}

void _onFocus() => setState(() {});

@override
void dispose() {
  widget.focusNode.removeListener(_onFocus);
  super.dispose();
}
```

`hintText` / рамка могут зависеть от `focusNode.hasFocus`.

## 3. Переход Next между полями

```dart
TextField(
  focusNode: emailNode,
  textInputAction: TextInputAction.next,
  onSubmitted: (_) => passwordNode.requestFocus(),
);

TextField(
  focusNode: passwordNode,
  textInputAction: TextInputAction.done,
  onSubmitted: (_) => passwordNode.unfocus(),
);
```

`TextInputAction.next` меняет кнопку на клавиатуре; сам переход фокуса часто делают явно в `onSubmitted`.

## 4. Тап вне поля

```dart
GestureDetector(
  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
  behavior: HitTestBehavior.opaque,
  child: child,
);
```

Или `Listener` / обёртка scaffold — чтобы клавиатура скрывалась.

## 5. Traversal и skip

```dart
Focus(
  skipTraversal: true, // Tab пропускает
  child: ActionChip(label: Text(label), onPressed: onPressed),
);

FocusTraversalOrder(
  order: NumericFocusOrder(index.toDouble()),
  child: field,
);
```

`canRequestFocus: false` — поле disabled: фокус не получит.

## 6. autofocus

`autofocus: true` у `TextField` / `Focus` — запросить фокус после первого кадра. Не злоупотребляй на каждом экране.

## 7. Focus и accessibility

Видимый focus indicator обязателен для клавиатуры. Screen reader тоже ходит по focusable semantics. Связка: `Focus` + `Semantics` + контрастная обводка.

## 8. Кто держит фокус

В дереве есть один `primaryFocus` — узел, который получает клавиатурный ввод. `FocusNode.hasFocus` истинен у него. `hasPrimaryFocus` — у самого узла, не у предка. `FocusScope` может `hasFocus`, пока фокус у ребёнка внутри области, и при этом не быть primary.

`requestFocus()` поднимает узел и по правилам scope. Если узел `skipTraversal` или `canRequestFocus: false`, запрос не сработает. `unfocus()` снимает фокус с узла; `FocusNode(canRequestFocus: false)` на время disabled поля надёжнее, чем оставлять фокус на неактивном `TextField`.

`onKeyEvent` у `Focus` обрабатывает клавишу до текста. Для «Enter отправляет форму» чаще хватает `onSubmitted` поля. Глобальные хоткеи — `Shortcuts` + `Actions` выше по дереву, не ручной разбор каждого `Focus`.

`FocusTraversalGroup` изолирует Tab внутри диалога или панели: Tab не уходит на фон под модалкой. У `showDialog` это уже устроено маршрутом. Свой оверлей без отдельной scope отдает Tab экрану под ним.

`autofocus` срабатывает после первого кадра, если ни у кого ещё нет более приоритетного запроса. Два `autofocus: true` на экране — гонка, побеждает один. На каждом шаге мастера фокус ставят явно в `requestFocus`, а не вторым autofocus.

## 9. Форма, клавиатура и dispose

`TextInputAction.next` только меняет значок на клавиатуре (стрелка вместо «готово»). Переход делает `onEditingComplete` / `onSubmitted` или `TextInputAction` вместе с `FocusTraversalPolicy`, если поля в одной группе и политика это умеет. В задачах модуля переход явный: так предсказуемо.

Снятие фокуса прячет мягкую клавиатуру, если это был текстовый узел. `unfocus` на кнопке, у которой фокуса не было, клавиатуру не уберёт. Поэтому тап по «пустому» месту шлёт `primaryFocus?.unfocus()`.

`HitTestBehavior.opaque` нужен, когда у обёртки нет цвета: иначе жест проваливается сквозь пустой `GestureDetector`. Не вешай этот жест на виджет, который сам содержит поля так, что тап по полю сначала unfocus, а потом фокус — порядок бывает дёрганым. Обычно жест на `Scaffold.body` вокруг, а поля сверху по дереву hit-test получают событие первыми.

Свой `FocusNode` без `dispose` течёт и может обновить слушателя после unmount. Узел, созданный внутри `TextField(focusNode: null)`, поле dispose-ит само. Узел извне — твоя ответственность. Не dispose-ь чужой узел в `State`, если его передал родитель: родитель переживёт этот экран.

Слушатель `addListener` на фокус и `setState` — нормальный способ рисовать обводку. Сними слушатель до `dispose` узла, если узел принадлежит родителю. Если узел твой — `dispose` узла сам отцепляет слушателей, но явный `removeListener` до dispose не вредит.

## 10. Типичные ошибки

- `requestFocus` в `initState` до того, как узел прикреплён к дереву. Надёжнее `autofocus` или post-frame callback.
- `FocusScope.of(context).unfocus()` и `primaryFocus.unfocus()` путают. Оба снимают текущий фокус; scope — если есть область. `FocusManager.instance.primaryFocus` работает и без `context`.
- Забыть `skipTraversal` на декоративном `Focus` и получить лишний Tab.
- Хранить `hasFocus` своей булевой копией и забыть слушатель — рамка врёт.
- Передать один `FocusNode` двум `TextField`. Жест фокуса будет прыгать.

## 11. Зачем это знать

- `FocusNode` vs `FocusScope`: узел vs область обхода.
- Сам создал — сам `dispose`.
- `TextInputAction.next` + `requestFocus` — UX форм.
- `skipTraversal` / `FocusTraversalPolicy` — desktop и TV.
- Unfocus по тапу снаружи — ожидаемое поведение mobile.

Дальше по маршруту: `focus_node_task.dart` → `interview_questions.md`.
