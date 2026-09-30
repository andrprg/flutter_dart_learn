# Шпаргалка: Accessibility (a11y) во Flutter

Доступность — чтобы приложением могли пользоваться люди с screen reader (TalkBack / VoiceOver), крупным шрифтом, клавиатурой и слабым зрением. Flutter даёт дерево **Semantics**: то, что «слышит» вспомогательная технология.

Перед задачами прочитай этот файл, затем решай `a11y_task.dart`.

## 1. Tap target

Минимум Material — **48×48** логических пикселей:

```dart
bool isTapTargetTooSmall(Size size) =>
    size.width < 48 || size.height < 48;
```

Иконка 24×24 — ок, если hit area (padding / `IconButton`) ≥ 48.

## 2. Semantics: label, exclude, merge

```dart
Semantics(
  label: 'Удалить $itemTitle',
  button: true,
  child: IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
);

// декоративная иконка рядом с текстом — не дублировать:
ExcludeSemantics(child: Icon(Icons.star));

// склеить «цена» + «120 ₽» в одно объявление:
MergeSemantics(child: Row(children: [Text('Цена'), Text('120 ₽')]));
```

Для чисел и статусов задавай человекочитаемый `semanticLabel`: «Цена: 120 рублей», а не «120».

## 3. Live region и объявления

```dart
Semantics(
  liveRegion: true,
  label: isLoading ? 'Загрузка' : null,
  child: child,
);
```

`SemanticsService.announce(...)` — разовое сообщение (успех сохранения и т.п.).

## 4. Клавиатура и focus

Интерактивные карточки без `InkWell`/`Button` сами не в фокусе. Оберни в `Focus` + видимое состояние:

```dart
Focus(
  child: Builder(builder: (context) {
    final focused = Focus.of(context).hasFocus;
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: focused ? Border.all(width: 2) : null,
        ),
        child: Text(title),
      ),
    );
  }),
);
```

Порядок обхода: Tab / стрелки, `FocusTraversalOrder`, `OrdinalSortKey` для screen reader.

## 5. Крупный текст

Не фиксируй высоту строк «на глаз». Учитывай `MediaQuery.textScalerOf(context)`:

```dart
Text(
  text,
  maxLines: 3,
  overflow: TextOverflow.ellipsis,
);
```

Контраст текста к фону — WCAG (ориентир 4.5:1 для обычного текста).

## 6. Формы

`InputDecoration(labelText:, hintText:, errorText:)` уже попадает в semantics. Дублируй смысл, если кастомный UI без стандартных полей.

## 7. Тестирование

- `tester.getSemantics(find.byType(...))`
- флаг `showSemanticsDebugger: true` у `MaterialApp`
- ручной прогон TalkBack / VoiceOver

## 8. Как читается дерево Semantics

Screen reader не видит пиксели. Он обходит семантические узлы: роль (кнопка, заголовок, поле), имя, значение, подсказка, действия.

У `Text` имя — сам текст. У `IconButton` без `tooltip` имени может не быть: озвучится «кнопка». `tooltip` и `Semantics(label:)` как раз дают имя. Дублировать и текст на кнопке, и тот же `label` не нужно: получится «Сохранить. Сохранить».

`ExcludeSemantics` выкидывает поддерево из обхода. Декоративная звезда рядом с заголовком «Избранное» иначе читается отдельно и шумит. `MergeSemantics` склеивает детей в один узел, чтобы «Цена» и «120» не были двумя свайпами.

`button: true` говорит роль. Без роли у `GestureDetector` получается просто «кликабельная область» без типа, и порядок объявления хуже. У стандартных `ElevatedButton` / `IconButton` роль уже есть.

`liveRegion: true` просит проговорить изменение, даже если фокус в другом месте (появилась ошибка формы, закончилась загрузка). Злоупотребление — болтливый экран на каждый `setState`. Разовое событие «черновик сохранён» — `SemanticsService.announce`, не вечный live region.

Порядок обхода по умолчанию — геометрический. `OrdinalSortKey` / `FocusTraversalOrder` нужен, когда визуальный порядок (ряд из двух колонок) не совпадает с логическим (сначала вся левая карточка).

## 9. Контраст, цвет и масштаб

WCAG для обычного текста ориентир — контраст 4.5:1, для крупного — 3:1. `onSurface` на `surface` в ColorScheme к этому стремится. Свой серый `#9E9E9E` на белом часто не дотягивает.

Цвет не единственный канал: ошибка поля — текст и иконка, не только красная обводка. Выбранная вкладка — не только другой цвет, но и состояние selected в semantics (его даёт `NavigationBar`).

`textScaler` 2.0 не должен обрезать кнопку и не должен включать горизонтальный скролл всего приложения. Проверка: системный крупный шрифт или `MediaQuery` с `TextScaler.linear(2)` в тесте.

Минимальная зона 48×48 — логические пиксели до учёта масштаба. Маленькая иконка в `IconButton` имеет padding как раз ради этого. Свой `GestureDetector` вокруг `Icon(size: 16)` зону не увеличивает.

## 10. Типичные ошибки

- Картинка без `semanticLabel` там, где она несёт смысл (не декор). Для декора — `ExcludeSemantics`.
- Прятать текст `opacity: 0` и оставить его в semantics — reader читает невидимое. Убирай из дерева или `ExcludeSemantics`.
- Подпись только `hint`, без `label`. Hint — дополнение, не имя.
- Фокус есть, обводки нет — клавиатурный пользователь не видит, где он.
- Тест на semantics не написан, сломали `label` при рефакторинге иконки.

## 11. Зачем это знать

- Screen reader читает Semantics, не «картинку».
- Декор — `ExcludeSemantics`, смысл — явный label.
- 48×48, focus ring, text scale — базовый чеклист.
- Цвет не единственный носитель смысла (иконка + текст / статус).

Дальше по маршруту: `a11y_task.dart` → `interview_questions.md`.
