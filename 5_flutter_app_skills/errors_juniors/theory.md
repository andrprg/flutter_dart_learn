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

## 9. Контекст, навигация и оверлеи

`BuildContext` — ссылка на Element. После `await` Element мог размонтироваться. `mounted` у `State` и `context.mounted` отвечают на один вопрос с разных сторон. Проверка нужна **после** каждого `await`, перед `setState`, `Navigator`, `ScaffoldMessenger`, `Theme.of`.

```dart
final messenger = ScaffoldMessenger.of(context);
await save();
messenger.showSnackBar(...); // messenger взяли до await
```

Так можно не держать `context`, если объект уже найден. Нельзя заранее взять `Navigator` и думать, что route жив, если тебе нужен именно этот State.

Навигация и `showDialog` во время `build` запрещены: дерево ещё собирается, overlay не готов. Отложенный кадр:

```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (!mounted) return;
  showDialog<void>(context: context, builder: ...);
});
```

`InheritedWidget` (`Theme`, `MediaQuery`, `Provider`) в `initState` не подписывает Element. Чтение может сработать случайно и не обновиться, либо бросить. Место — `didChangeDependencies` или `build`.

Два `Scaffold` вложенно: `Scaffold.of` находит ближайший. SnackBar и `BottomSheet` привяжутся к внутреннему и обрежутся. Один scaffold на экран, мессенджер — `ScaffoldMessenger` у `MaterialApp`.

## 10. Жесты, краска и списки

`InkWell` рисует сплэш на `Material` под собой. Если между ними непрозрачный `Container` с цветом, сплэш есть, но его не видно. Цвет кладут на `Material(color:)` или `Ink`.

`Color(0xFFFFFF)` — альфа в старшем байте равна 0, цвет полностью прозрачный. Непрозрачный белый — `Color(0xFFFFFFFF)` или `Colors.white`.

`ListView(children:)` строит всех детей сразу. Длинная лента — `builder` и стабильный `Key`. `shrinkWrap: true` у длинного списка внутри `Column` измеряет всех и снова дорогой.

`const` конструктор виджета с не-const полем не соберётся. Поля `StatelessWidget` — `final`, иначе виджет врёт, что он immutable, и `const` невозможен.

Тяжёлый синхронный цикл в `build` блокирует кадр так же, как в event loop. Вынос в `compute` / `Isolate.run` — если работа реально длиннее пары миллисекунд и это не «десять строк JSON».

## 11. Как читать симптом

| Симптом | Куда смотреть |
|---|---|
| `setState() called after dispose()` | `await` без `mounted`, слушатель без `dispose` |
| `setState() or markNeedsBuild() called during build` | эффект внутри `build` |
| `Vertical viewport was given unbounded height` | список в `Column` без `Expanded` |
| `RenderFlex overflowed` | нет flex / нет переноса текста |
| `Looking up a deactivated widget's ancestor` | `context` после ухода route |
| `Duplicate GlobalKey` | один ключ на два виджета |
| жёлто-чёрных полос нет, тап «не жмётся» | нет hit-test (`color` / `behavior`) |
| сплэш не виден | цвет не на `Material` |

Сообщение Flutter почти всегда называет виджет и предлагает направление фикса. Сначала прочитай его целиком, потом код.

## 12. Зачем это знать

- Эти 10 паттернов закрывают половину junior-багрепортов.
- Симптом («overflow», «setState after dispose») → одна из строк выше.
- Читай ошибки Flutter: в них обычно уже написан фикс.

Дальше по маршруту: `flutter_erros.dart` → `flutter_errors_answers.md` → `interview_questions.md`.
