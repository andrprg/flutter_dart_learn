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

## 8. Когда валидатор вызывается

`FormField` хранит своё состояние в `FormFieldState`: текущее значение, текст ошибки, был ли пользователь в поле. `validator` возвращает `String?`. Пустая строка `''` тоже считается ошибкой и может нарисовать пустой красный блок — возвращай `null` или осмысленный текст.

`validate()` идёт по потомкам `Form`. Поле вне этого `Form` (соседний виджет, другой route) в проверку не входит. Вложенная `Form` — отдельное дерево со своим ключом.

`onSaved` вызывается из `save()` **после** успешного `validate`. Паттерн: валидаторы проверяют, `onSaved` складывает значение в модель. Можно обойтись контроллерами и не звать `save()`, если значения и так в `TextEditingController`.

`autovalidateMode: onUserInteraction` не краснит поле в первую секунду фокуса, только после изменения. После неудачного `validate()` ошибки и так видны. Переключить режим на `always` имеет смысл, если хочешь проверять и те поля, которых пользователь не касался.

`TextInputType.emailAddress` и `obscureText` не заменяют валидатор. Клавиатура — подсказка ОС, формат проверяешь ты.

## 9. Ошибки полей и ошибка формы

Валидатор поля — про это поле. «Сервер отклонил логин» — не ошибка формата email. Её показывают баннером над кнопкой или `SnackBar`, не подменой `validator`.

Иначе после исправления опечатки старый текст «неверный пароль» останется, пока не сменится режим. Баннер сбрасывай при следующем `onChanged` или при новом submit.

`enabled: false` у кнопки на время запроса защищает от двойного POST. Спиннер на кнопке объясняет, почему она серая. Ошибку сети в `finally` не проглатывай: иначе кнопка снова живая, а человек думает, что всё сохранилось.

Пароль и подтверждение: валидатор подтверждения читает **текущий** текст пароля из контроллера, не снимок из `initState`. Иначе правка пароля не перепроверяет второе поле, пока его самого не тронут. После смены пароля позови `formKey.currentState?.validate()`, если второе поле уже показано с ошибкой.

## 10. Типичные ошибки

- `GlobalKey` создаётся в `build` — каждый кадр новый ключ, `currentState` пустой.
- Контроллер на `StatelessWidget` как поле, которое пересоздаётся... у stateless полей-мутаций быть не должно; контроллер живёт в `State`.
- `validator` бросает вместо возврата строки — форма падает, а не подсвечивается.
- Debounce-таймер не отменён в `dispose` — колбэк после ухода с экрана.
- Сравнение паролей без `trim` там, где email тримишь, и наоборот: пароль **не** тримят (пробел может быть частью), email тримят.

## 11. Сброс и initialData

`ProfileEditForm`: заполни контроллеры из `initialData`; кнопка «Сброс» возвращает исходные значения. При смене `initialData` извне — `didUpdateWidget`.

Чекбокс согласия в Register — часть draft; `collectRegisterErrors` собирает все сообщения в список.

---

Дальше: `forms_task.dart`. Оверлеи после submit — в `overlays/`.
