# Шпаргалка: ChangeNotifier / Listenable

`ChangeNotifier` и `ValueNotifier` — фундамент подписок во Flutter до Riverpod. Идея простая: модель хранит слушателей и при изменении состояния вызывает их через `notifyListeners()`. Дальше решай `change_notifier_task.dart`.

## 1. Listenable → ChangeNotifier → ValueNotifier

| Тип | Роль |
|---|---|
| `Listenable` | Контракт: `addListener` / `removeListener` |
| `ChangeNotifier` | Реализация + `notifyListeners()`; удобен для сложной модели |
| `ValueNotifier<T>` | Один `value`; при `value = ...` сам уведомляет (если значение изменилось) |

```dart
class CounterNotifier extends ChangeNotifier {
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }
}

final title = ValueNotifier<String>('Hello');
title.value = 'Hi'; // notify
```

Правило из задач: `ValueNotifier` — когда хватает **одного** примитива/флага (`single_value`); `ChangeNotifier` — когда state **сложный** (списки, вычисляемые поля, несколько методов).

## 2. Подписка и отписка

```dart
void listenTemporarily(
  ChangeNotifier notifier,
  VoidCallback listener,
  void Function() action,
) {
  notifier.addListener(listener);
  try {
    action();
  } finally {
    notifier.removeListener(listener); // всегда снять
  }
}
```

- `notifyListeners()` вызывает слушателей **синхронно**.
- После `dispose()` уведомлять нельзя — assert/падение. Обёртка вроде `safeNotify` ловит «уже disposed».
- В UI обычно `ListenableBuilder` / `AnimatedBuilder`; в тестах — `addListener` + проверка значений без виджетов.

## 3. Корзина как пример модели

```dart
class CartNotifier extends ChangeNotifier {
  final List<CartLine> _lines = [];
  List<CartLine> get lines => List.unmodifiable(_lines);

  int get total => _lines.fold(0, (s, e) => s + e.price * e.qty);

  void add(CartLine line) {
    _lines.add(line);
    notifyListeners();
  }

  void updateQty(String id, int qty) {
    // найти, заменить / удалить при qty <= 0
    notifyListeners();
  }
}
```

Иммутабельные строки через `copyWith`; наружу — `unmodifiable`, чтобы UI не мутировал список в обход notifier.

## 4. Listenable.merge

Когда виджет зависит от **двух** источников (например, theme + cart):

```dart
final merged = Listenable.merge([a, b]);
// любое notify у a или b → rebuild слушателя merged
```

## 5. Связь с Provider / Riverpod

- Старый `provider` часто оборачивал `ChangeNotifier` (`ChangeNotifierProvider`).
- Riverpod — другой runtime (нет обязательного `BuildContext` для чтения), но идея та же: **подписка на изменение + точечный rebuild**.
- Понимание `notifyListeners` помогает понять, зачем в Riverpod `ref.watch` и зачем не звать side effects «впустую».

## 6. Когда уведомление доходит до UI

`notifyListeners` синхронно вызывает каждого слушателя. Слушатель, который снова меняет модель и зовёт `notify`, получит вложенный обход. Это легко превращается в цикл. Правило: в слушателе не менять тот же notifier. Отложенное изменение — через кадр или флаг.

`ListenableBuilder` подписывается в `initState` своего Element и снимает подписку в `dispose`. Ручной `addListener` в `State` обязан сделать `removeListener` до dispose notifier, иначе колбэк переживёт экран.

`ValueNotifier` не зовёт слушателей, если новый `value` равен старому через `==`. Повторная запись того же `int` молчит. `List` сравнивается по ссылке: `list.add(item)` без новой ссылки ничего не сообщит, и присваивание `value = тот же list` тоже не сообщит, потому что `==` истинен. Либо кладут новую коллекцию `value = [...list, item]`, либо свой `ChangeNotifier` с явным `notifyListeners` после мутации внутреннего списка.

Наружу отдают `List.unmodifiable` или копию. Иначе виджет сделает `cart.lines.add` и обойдёт модель: часть слушателей не узнает, инварианты разъедутся.

`dispose` у `ChangeNotifier` отцепляет слушателей и помечает объект. Следующий `notifyListeners` в debug бросает. `safeNotify` в задачах ловит этот случай, когда событие пришло позже смерти модели. В продакшене лучше отменить источник события, чем глушить ошибку.

`AnimatedBuilder` — тот же слушатель `Listenable`. Для анимации и для корзины механизм один.

## 7. Типичные ошибки

- Забыли `notifyListeners` после мутации — UI молчит.
- Мутировали список по ссылке и не уведомили.
- Уведомили из слушателя того же объекта — реентрантность.
- Не сняли listener и не вызвали `dispose` — вызов после смерти виджета.
- Держат `BuildContext` внутри notifier и показывают SnackBar оттуда. Модель не знает про дерево. Событие наружу — колбэк, флаг ошибки, `Listenable`.

## 8. Вопросы с собеса (кратко)

1. Как работает? — список listeners + синхронный `notifyListeners`.
2. Value vs Change? — одно value vs произвольная модель.
3. Dispose обязателен? — да для своих notifier/animation.
4. merge? — один Listenable из нескольких.
5. Provider/Riverpod? — та же идея подписки, другой API.
6. notify после dispose? — опасно.
7. Когда ValueNotifier? — один примитив.
8. Тесты? — listener + expect, без UI.

Дальше: `change_notifier_task.dart` → `architecture/` → `riverpod/`.
