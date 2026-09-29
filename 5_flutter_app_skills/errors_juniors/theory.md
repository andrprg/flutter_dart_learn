# Шпаргалка: Типичные ошибки Junior Flutter

Большинство «странных» багов джуна — не магия фреймворка, а одни и те же ловушки: `setState` не вовремя, `context` после `await`, Future в `build`, забытый `dispose`, unconstrained layout. Файл `flutter_erros.dart` — тренажёр на 30 кейсов.

Перед задачами прочитай этот файл, затем разбирай `flutter_erros.dart` (ответы — `flutter_errors_answers.md`).

## 1. State и build

```dart
// Плохо: setState / навигация / SnackBar прямо в build
Widget build(BuildContext context) {
  setState(() => count++); // во время build
  Navigator.push(...);     // во время build
  return Text('$count');
}

// Плохо: мутация без setState
onChanged: (v) { isActive = v; }; // UI не обновится
```

`build` должен быть чистым: описал UI, не запускал побочные эффекты.

## 2. async + context + mounted

```dart
Future<void> saveAndNavigate() async {
  await save();
  if (!mounted) return;
  Navigator.of(context).pop();
}
```

После `await` виджет мог уйти из дерева. То же для `setState` в конце долгого Future.

`initState` **не** делают `async`. Запускают отдельный метод:

```dart
@override
void initState() {
  super.initState();
  _load(); // sync call
}

Future<void> _load() async { ... }
```

## 3. FutureBuilder

```dart
// Плохо — новый Future на каждый rebuild:
FutureBuilder(future: fetchData(), ...)

// Хорошо — один Future в State:
late final Future<String> _future = fetchData();
```

## 4. dispose обязателен

`TextEditingController`, `ScrollController`, `AnimationController`, `FocusNode`, `Timer`, `StreamSubscription` — создал в State → `dispose`. Иначе утечки и вызовы после unmount.

`AnimationController` нужен `SingleTickerProviderStateMixin` (или `TickerProviderStateMixin`).

## 5. Layout: unbounded / overflow

| Ошибка | Фикс |
|---|---|
| `ListView` в `Column` | `Expanded` / `Flexible` / `shrinkWrap` |
| Длинный `Text` в `Row` | `Expanded` + `overflow` |
| `Expanded` в `Stack` | `Positioned` / `SizedBox.expand` |
| `Positioned` вне `Stack` | только прямой ребёнок `Stack` |
| `height: infinity` в `Column` | `Expanded` |
| Вложенные `Scaffold` | один scaffold на экран |

`GestureDetector` на «пустом» `Container` без цвета может не ловить тапы — `color: Colors.transparent` или `behavior: HitTestBehavior.opaque`.

## 6. Inherited в initState

`MediaQuery.of(context)`, `Theme.of(context)`, `Provider` в `initState` — context ещё не подписан. Бери в `didChangeDependencies` или в `build`. SnackBar в `initState` — через `addPostFrameCallback`. `Theme.of` выше `MaterialApp` — нет темы; вынеси `home` ниже или используй `Builder`.

Всегда вызывай `super.initState()`.

## 7. Списки и производительность

```dart
// Плохо: 10_000 виджетов сразу
ListView(children: List.generate(10000, ...))
Column(children: [...List.generate(5000, ...)])

// Хорошо:
ListView.builder(itemCount: items.length, itemBuilder: ...)
```

У `ListView.builder` нужен `itemCount`. Stateful-дети в динамическом списке — с `Key`. Тяжёлый цикл в `build` — в isolate/`compute`.

## 8. Мелочи, которые ломают UI

- `Color(0xFFFFFF)` — альфа `00` (прозрачный); непрозрачный: `0xFFFFFFFF`.
- `InkWell` под цветным `Container` — splash не виден; цвет на `Material`/`Ink`.
- Поля `StatelessWidget` — `final`.
- Не мутируй props; не pantуй гигантский `build` — дроби виджеты.

## 9. Зачем это знать

- Эти 10 паттернов закрывают половину junior-багрепортов.
- Симптом («overflow», «setState after dispose») → одна из строк выше.
- Читай ошибки Flutter: в них обычно уже написан фикс.

Дальше по маршруту: `flutter_erros.dart` → `flutter_errors_answers.md` → `interview_questions.md`.
