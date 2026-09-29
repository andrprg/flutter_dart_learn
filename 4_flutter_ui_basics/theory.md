# Шпаргалка: базовые виджеты Flutter

Перед задачами прочитай этот файл, затем решай `flutter_widgets_task.dart`.

Виджет — **immutable-конфиг** UI. Дерево виджетов описывает «что показать»; Element и RenderObject решают «как жить» и «как нарисовать». `build` должен быть чистым: без сети, таймеров и тяжёлой работы.

## 1. Stateless vs Stateful

| | StatelessWidget | StatefulWidget |
|---|---|---|
| State | Нет локального мутабельного state | Есть `State` + `setState` |
| Когда | UI из props/контекста | Счётчик, форма, вкладки, жесты |
| Lifecycle | Только `build` | `initState`, `dispose`, `didUpdateWidget`… |

```dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$_count'),
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: const Text('+'),
        ),
      ],
    );
  }
}
```

`setState` помечает Element dirty → на следующем кадре снова `build`. Не вызывай `setState` после `dispose`.

## 2. Базовая композиция

- **Center / Text / TextStyle** — текст и выравнивание.
- **Container + BoxDecoration** — размер, цвет, радиус, тень.
- **Row / Column / SizedBox** — оси и отступы.
- **CircleAvatar, Card, Icon** — типовые куски Material.
- **Stack + Positioned** — слои (бейдж поверх иконки).

```dart
Row(
  children: [
    const CircleAvatar(child: Text('А')),
    const SizedBox(width: 12),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Алексей', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Flutter Dev'),
      ],
    ),
  ],
);
```

## 3. Списки и сетки

`ListView` / `ListView.builder` — вертикальный (или горизонтальный) скролл. **builder** создаёт детей лениво — для длинных списков.

`GridView.builder` + `SliverGridDelegateWithFixedCrossAxisCount` — сетка с фиксированным числом колонок.

Ключи в списках: стабильный `ValueKey(id)`, не index при сортировке/фильтре (см. модуль `widget_keys`).

## 4. Жесты и навигация

`GestureDetector`: `onTap`, `onDoubleTap`, `onLongPress`, `onPanUpdate` (перетаскивание).

Navigator 1.0:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => DetailScreen(message: 'Привет!')),
);
// назад: Navigator.pop(context);
```

Аргументы — через конструктор или `ModalRoute.of(context)?.settings.arguments`.

## 5. Диалоги, SnackBar, вкладки

- Диалог: `showDialog` + `AlertDialog`, результат через `Navigator.pop(context, value)`.
- SnackBar: **`ScaffoldMessenger.of(context).showSnackBar(...)`**, не старый `Scaffold.of`.
- Вкладки: `DefaultTabController` + `TabBar` / `TabBarView`.
- Нижняя навигация: `BottomNavigationBar` + `IndexedStack` (сохраняет state вкладок).
- Drawer: `Drawer` + `ListTile` + `Navigator.pop` чтобы закрыть.

## 6. Простые анимации

`AnimatedContainer`, `AnimatedOpacity` — **implicit**: меняешь свойство + `Duration`, фреймворк интерполирует. Для контроллеров и Tween — модуль `animations`.

## 7. FutureBuilder и StreamBuilder

```dart
FutureBuilder<Map<String, String>>(
  future: fetchUser(), // НЕ создавай Future внутри build!
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) return Text('Ошибка: ${snapshot.error}');
    final user = snapshot.data!;
    return Text('${user['name']} — ${user['email']}');
  },
);
```

**Антипаттерн:** `future: fetchUser()` прямо в `build` — на каждый rebuild новый Future. Создавай Future в `initState`, поле класса или провайдере.

`StreamBuilder` + `Stream.periodic` — то же с `AsyncSnapshot`, но для потока (таймер, websocket).

## 8. Тема и const

`MaterialApp(theme: ..., darkTheme: ..., themeMode: ...)` + `ValueListenableBuilder` / `setState` для переключения.

`const` виджеты — меньше аллокаций и проще сверка Element tree (canonical instances).

## 9. InheritedWidget (кратко)

Данные вниз по дереву без передачи через каждый конструктор. `Theme.of(context)`, `MediaQuery.of` — подписка через `dependOnInheritedWidgetOfExactType`: при изменении Inherited — rebuild подписчиков.

---

Дальше по маршруту: `flutter_widgets_task.dart`, затем подпапки `constraints/`, `layout/`, `scrolling/` …
