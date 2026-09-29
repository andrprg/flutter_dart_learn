# Шпаргалка: Widget Keys

Перед задачами прочитай этот файл, затем решай `widget_keys_task.dart`.

Key говорит Flutter: «это **тот же** логический виджет», даже если позиция в списке детей изменилась. Без ключа сверка идёт **по порядку и runtimeType** — State может «переехать» не туда.

## 1. Зачем Key

- Сохранить `State` при reorder / swap детей.
- Не путать поля формы и чекбоксы при фильтре списка.
- `Dismissible`, `AnimatedList`, `ReorderableListView` — требуют стабильный Key.
- `GlobalKey` — доступ к `State` снаружи (`FormState.validate`).

Ключи **не** нужно вешать на каждый виджет — только где важна идентичность.

## 2. Типы ключей

| Тип | Смысл | Пример |
|---|---|---|
| **ValueKey(T)** | равенство по `value` | `ValueKey(item.id)` |
| **ObjectKey** | идентичность объекта (`==` / identity) | `ObjectKey(item)` |
| **UniqueKey** | всегда новый, ничему не равен | сброс State «с нуля» |
| **GlobalKey** | уникален в приложении, доступ к Element/State | `GlobalKey<FormState>()` |

Все кроме Global — **LocalKey** (локальная сверка среди siblings).

```dart
ValueKey<String> valueKeyForItem(Item item) => ValueKey(item.id);
ObjectKey objectKeyForItem(Item item) => ObjectKey(item);
UniqueKey newUniqueKey() => UniqueKey();
GlobalKey<FormState> createFormKey() => GlobalKey<FormState>();
```

## 3. Почему index — плохой Key

```dart
// плохо при сортировке / удалении / фильтре
ListTile(key: ValueKey(index), ...);
```

После удаления элемента с index=0 бывший «1» становится «0» — State чекбокса/контроллера липнет к **другому** item. Бери стабильный **id** сущности. `isIndexSafeAsKey()` → `false`.

## 4. Выбор по use-case

| Сценарий | kind |
|---|---|
| Стабильный id сущности | `'value'` |
| Одноразовый сброс state | `'unique'` |
| Доступ к State (`validate`) | `'global'` |

## 5. GlobalKey: правила

```dart
bool validateForm(GlobalKey<FormState> formKey) {
  return formKey.currentState?.validate() ?? false;
}
```

- Один GlobalKey — **в одном месте** дерева. Два виджета с одним GlobalKey — ошибка.
- Тяжелее обычных ключей; не для каждого ListTile.
- Нужен, когда без него не достать State (форма, «проскроллить к виджету»).

## 6. Демо: swap счётчиков

Два `CounterBox` ('A' и 'B'). Без ключей после swap State остаётся **по позиции** (счётчик «поедет» с местом). С `ValueKey('A')` / `ValueKey('B')` State следует за лейблом.

`LabeledCheckItem` + `ValueKey(item.id)` + карта `id → checked` — состояние галочек вне виджета, ключ не даёт перепутать элементы при перестройке Column.

## 7. AnimatedList / ReorderableListView

Вставка/удаление/перестановка анимируются корректно только со стабильными ключами — иначе фреймворк не поймёт, кто ушёл и кто пришёл.

## 8. Кратко

- Key = идентичность в Element tree.
- Списки с мутацией порядка → ValueKey(id).
- Index — нет.
- GlobalKey — редко и точечно.
- UniqueKey — «сделай виджет новым».

---

Дальше: `widget_keys_task.dart`.
