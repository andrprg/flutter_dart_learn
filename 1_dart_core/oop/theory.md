# Шпаргалка: OOP в Dart

Классы, конструкторы, наследование, интерфейсы и mixin — база до Flutter-виджетов и моделей. Перед задачами прочитай этот файл, затем решай `oop_task.dart`.

## 1. Класс и конструкторы

```dart
class Money {
  const Money(this.amount, this.currency);

  final int amount;
  final String currency;

  factory Money.zero(String currency) => Money(0, currency);
}
```

| Вид | Что делает |
|---|---|
| Generative | Создаёт новый экземпляр (`Money(1, 'USD')`) |
| Named | Именованная точка входа (`Money.zero`) |
| `const` | Compile-time константа при константных аргументах |
| `factory` | Может вернуть существующий объект, подтип или бросить |

`factory` не обязан вызывать `this(...)` — часто `fromJson`, кэш, валидация.

## 2. Equality и `hashCode`

Value equality — объекты равны по полям, не по identity:

```dart
@override
bool operator ==(Object other) =>
    other is Money &&
    other.amount == amount &&
    other.currency == currency;

@override
int get hashCode => Object.hash(amount, currency);
```

Правило: если `a == b`, то `a.hashCode == b.hashCode`. Иначе сломаются `Map`/`Set`.

## 3. Операторы

```dart
Money operator +(Money other) {
  if (currency != other.currency) {
    throw ArgumentError('currency mismatch');
  }
  return Money(amount + other.amount, currency);
}
```

## 4. Abstract class vs interface

```dart
abstract class Shape {
  double get area; // без тела — обязан реализовать наследник
}

abstract interface class JsonEncodable {
  Map<String, Object?> toJson();
}

class User implements JsonEncodable {
  const User({required this.id, required this.name});
  final int id;
  final String name;

  @override
  Map<String, Object?> toJson() => {'id': id, 'name': name};

  factory User.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! int || name is! String) {
      throw FormatException('bad User json');
    }
    return User(id: id, name: name);
  }
}
```

| | `extends` | `implements` |
|---|---|---|
| Что берёшь | Реализацию + контракт | Только контракт |
| Множественно | Один суперкласс | Много интерфейсов |

`abstract class` может содержать реализацию. `interface` / `implements` — «обязуюсь реализовать методы».

## 5. Mixin

Переиспользование поведения без наследования:

```dart
mixin Loud {
  String shout(String message) => '${message.toUpperCase()}!';
}

class Announcer with Loud {
  const Announcer();
}
```

Dart: один `extends`, несколько `with` / `implements`. Множественного наследования классов нет.

## 6. Sealed (зачем знать)

`sealed class` ограничивает иерархию в одной библиотеке — `switch` по подтипам становится исчерпывающим. Полезно для состояний и ADT; в задачах модуля основной фокус — abstract/implements/mixin.

## 7. Полиморфизм

```dart
double totalArea(List<Shape> shapes) =>
    shapes.fold(0.0, (sum, s) => sum + s.area);
```

Список `Shape` — вызывается `area` у `Rectangle` / `Circle` без знания конкретного типа.

## 8. Class modifiers: что можно расширять

| Модификатор | Смысл |
|---|---|
| `abstract` | Нельзя `new`; можно `extends` и `implements` |
| `interface` | Снаружи библиотеки только `implements`, реализацию не наследуют |
| `base` | Снаружи только `extends`, не `implements` (сохраняется инвариант суперкласса) |
| `final` | Снаружи нельзя ни `extends`, ни `implements` |
| `sealed` | Подтипы только в этой библиотеке; `switch` исчерпывающий |
| `mixin class` | И класс, и mixin |

`abstract interface class` — контракт без наследования реализации. Так помечают порты репозитория: снаружи нельзя случайно `extends` и сломать инварианты, можно только `implements`.

## 9. `super`, инициализация, `noSuchMethod`

Порядок создания: инициализаторы полей → `super` → тело конструктора. В списке инициализации `this` ещё не готов для методов, которые читают поля.

```dart
class Rectangle extends Shape {
  Rectangle(this.width, this.height);
  final double width;
  final double height;
  @override
  double get area => width * height;
}
```

Именованные конструкторы не наследуются. `super.named(...)` вызывают явно.

`==` переопределяют вместе с `hashCode`. Для моделей с кучей полей удобен пакет `equatable` или Dart 3 records как ключ, но контракт тот же: равные объекты → равные хеши, хеш стабилен, пока объект в `Map`/`Set`.

## 10. Mixin: линейный порядок и ограничения

`class C extends A with M1, M2` — цепочка `A → M1 → M2 → C`. Метод `M2` перекрывает `M1`. `super` в mixin идёт к предыдущему в цепочке, не «к классу вообще».

`on` ограничивает, куда mixin можно навесить:

```dart
mixin NameLabel on User {
  String get label => name.toUpperCase();
}
```

Без `on` mixin не видит поля `User`. С `on` — только классы, которые уже `extends`/`implements` `User`.

## 11. Типичные ошибки

- `factory` назвали обычным конструктором и ждут `this` в теле — у factory нет `this`, пока не вызван generative.
- Переопределили `==` без `hashCode` — объект «пропадает» из `Set`.
- Мутируемое поле участвует в `==` — после изменения ключ Map не находится.
- `implements` вместо `extends`, когда нужна реализация `area` по умолчанию: implements обязывает написать всё заново.
- Два mixin с одним методом — побеждает последний в `with`; это не ошибка компилятора, это порядок.

## 12. Зачем это знать

- Модели (`User`, `Money`) с `fromJson` / `toJson` и value equality.
- Разделять контракт (`implements`) и переиспользование кода (`mixin` / `extends`).
- Не ломать `Map`/`Set` кривым `==`/`hashCode`.
- Во Flutter всё — виджеты-классы; тот же OOP.

Дальше: `oop_task.dart` и `interview_questions.md`.
