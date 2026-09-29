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

## 8. Зачем это знать

- Screen reader читает Semantics, не «картинку».
- Декор — `ExcludeSemantics`, смысл — явный label.
- 48×48, focus ring, text scale — базовый чеклист.
- Цвет не единственный носитель смысла (иконка + текст / статус).

Дальше по маршруту: `a11y_task.dart` → `interview_questions.md`.
