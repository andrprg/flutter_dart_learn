# Шпаргалка: Forms и валидация

Перед задачами прочитай этот файл, затем решай `forms_task.dart`.

Форма во Flutter — обычно `Form` + `TextFormField` + `GlobalKey<FormState>`. Валидаторы возвращают **строку ошибки или `null`**.

## 1. Form + GlobalKey

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(validator: emailValidator),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // всё ок — submit
          }
        },
        child: const Text('Войти'),
      ),
    ],
  ),
);
```

`validate()` пробегает все `FormField` и показывает ошибки. Без `Form` единой точки submit нет.

`FormField` — общий контракт; `TextFormField` — поле ввода, реализующее FormField.

## 2. Валидаторы

```dart
String? requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Обязательное поле';
  return null;
}

String? emailValidator(String? value) { /* пустой + формат */ }
String? passwordValidator(String? value) {
  // минимум 8 символов, хотя бы одна цифра
}
String? confirmPasswordValidator(String? value, String password) {
  // совпадение с password
}
```

Чистые функции — удобно тестировать и переиспользовать (Login / Register / collectRegisterErrors).

## 3. TextEditingController

```dart
late final TextEditingController _email;

@override
void initState() {
  super.initState();
  _email = TextEditingController(text: initial);
}

@override
void dispose() {
  _email.dispose();
  super.dispose();
}
```

Контроллер нужен, чтобы читать/писать текст, слушать изменения, сбрасывать форму. **Всегда dispose**. Не создавай новый контроллер в каждом `build`.

## 4. autovalidateMode

| Режим | Когда валидировать |
|---|---|
| `disabled` | только по `validate()` |
| `always` | постоянно |
| `onUserInteraction` | после первого взаимодействия с полем |

Для UX часто: сначала disabled / onUserInteraction, после неудачного submit — always.

## 5. FocusNode

Управляет фокусом: OTP из 4 полей, «дальше» после цифры, `requestFocus` / `unfocus`.

```dart
final nodes = List.generate(4, (_) => FocusNode());
// в dispose — каждый node.dispose()
```

`FocusScope.of(context).unfocus()` — спрятать клавиатуру перед submit.

## 6. Async submit

Не блокируй UI: кнопка в состоянии loading, `onPressed: null` пока идёт Future.

```dart
// идея AsyncSubmitButton
bool _loading = false;
onPressed: _loading
    ? null
    : () async {
        setState(() => _loading = true);
        try {
          await widget.onPressed();
        } finally {
          if (mounted) setState(() => _loading = false);
        }
      };
```

Проверяй `mounted` после `await`. Ошибки API — баннер (`FormErrorBanner`) или SnackBar, не только красные поля.

## 7. Debounce поиска

Не дергай API на каждый символ:

```dart
Timer? _debounce;
onChanged: (v) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 300), () {
    onChangedDebounced(v);
  });
};
// dispose: _debounce?.cancel(); controller.dispose();
```

## 8. Сброс и initialData

`ProfileEditForm`: заполни контроллеры из `initialData`; кнопка «Сброс» возвращает исходные значения. При смене `initialData` извне — `didUpdateWidget`.

Чекбокс согласия в Register — часть draft; `collectRegisterErrors` собирает все сообщения в список.

---

Дальше: `forms_task.dart`. Оверлеи после submit — в `overlays/`.
