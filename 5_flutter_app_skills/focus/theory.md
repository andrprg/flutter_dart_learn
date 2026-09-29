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

## 8. Зачем это знать

- `FocusNode` vs `FocusScope`: узел vs область обхода.
- Сам создал — сам `dispose`.
- `TextInputAction.next` + `requestFocus` — UX форм.
- `skipTraversal` / `FocusTraversalPolicy` — desktop и TV.
- Unfocus по тапу снаружи — ожидаемое поведение mobile.

Дальше по маршруту: `focus_node_task.dart` → `interview_questions.md`.
