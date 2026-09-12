import 'package:flutter/material.dart';

// ============================================================
// 20 ЗАДАЧ ПО ВИДЖЕТАМ FLUTTER
// ============================================================
// Для запуска этих задач необходим Flutter SDK.
// Добавь в pubspec.yaml:
//   dependencies:
//     flutter:
//       sdk: flutter
// ============================================================

/// Базовый уровень (1–5)

// ЗАДАЧА 1
// Создай StatelessWidget с именем GreetingCard.
// Он должен отображать текст "Привет, Flutter!" по центру экрана,
// красным цветом, размером шрифта 24.
//
// Подсказка: используй Center, Text, TextStyle.
//
// Ожидаемый результат: по центру экрана красный текст "Привет, Flutter!"

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Привет, Flutter!",
            style: TextStyle(color: Colors.red, fontSize: 24)));
  }
}

// ЗАДАЧА 2
// Создай виджет StyledBox — Container с шириной 200, высотой 100,
// синим цветом фона, скруглёнными углами (borderRadius 16),
// белым текстом "Styled Box" по центру.
//
// Подсказка: используй Container, BoxDecoration, BorderRadius, Text.
//
// Ожидаемый результат: синий прямоугольник со скруглёнными углами и текстом.

class StyledBox extends StatelessWidget {
  const StyledBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(16)),
      child: Text(
        "Styled Box",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

// ЗАДАЧА 3
// Создай виджет ProfileRow, который отображает строку (Row) из:
// — аватара (CircleAvatar с буквой "А", синий фон)
// — отступа SizedBox(width: 12)
// — колонки (Column) с именем "Алексей" (жирный шрифт) и подписью "Flutter Dev"
//
// Подсказка: Row, Column, CircleAvatar, SizedBox, Text, FontWeight.bold.

class ProfileRow extends StatelessWidget {
  const ProfileRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Text("A"),
          backgroundColor: Colors.blue,
        ),
        SizedBox(
          width: 12,
        ),
        Column(
          children: [
            Text(
              "Алексей",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Flutter Dev")
          ],
        ),
      ],
    );
  }
}

// ЗАДАЧА 4
// Создай StatefulWidget CounterWidget.
// Отображай число (начальное значение 0) и две кнопки: "+" и "−".
// При нажатии "+" увеличивай счётчик, при "−" уменьшай (не ниже 0).
//
// Подсказка: setState, ElevatedButton, Text.
//
// Ожидаемый результат: нажатие кнопок меняет отображаемое число.

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 5
// Создай виджет ColoredList — ListView из 5 элементов.
// Каждый элемент — Container высотой 60, с чередующимися цветами
// (нечётные — Colors.blue[100], чётные — Colors.green[100]).
// Внутри каждого — текст "Элемент N" (N — номер от 1 до 5).
//
// Подсказка: ListView.builder, itemCount.

class ColoredList extends StatelessWidget {
  const ColoredList({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

/// Средний уровень (6–12)

// ЗАДАЧА 6
// Создай виджет CardGrid — GridView из 6 карточек (2 колонки).
// Каждая карточка — Card с иконкой (Icons.star) и текстом "Карточка N".
// Используй GridView.builder с SliverGridDelegateWithFixedCrossAxisCount.
//
// Подсказка: GridView.builder, Card, Column, Icon, Text.

class CardGrid extends StatelessWidget {
  const CardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 7
// Создай виджет StackBadge — Stack из:
// — большого синего квадрата 100x100
// — маленького красного круга (диаметр 24) в правом верхнем углу с числом "3"
//
// Подсказка: Stack, Positioned, Container, BoxShape.circle.

class StackBadge extends StatelessWidget {
  const StackBadge({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8
// Создай StatefulWidget LoginForm с двумя полями TextFormField:
// "Email" и "Пароль" (пароль скрыт), кнопкой "Войти".
// При нажатии "Войти" валидируй поля:
// — Email не должен быть пустым
// — Пароль не менее 6 символов
// При успехе показывай SnackBar "Добро пожаловать!".
//
// Подсказка: Form, GlobalKey<FormState>, validator, ScaffoldMessenger.

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9
// Создай виджет TapCounter — GestureDetector, который считает:
// — одиночные нажатия (onTap)
// — двойные нажатия (onDoubleTap)
// — долгие нажатия (onLongPress)
// Отображай каждый счётчик в отдельной строке.
//
// Подсказка: GestureDetector, setState, Column, Text.

class TapCounter extends StatefulWidget {
  const TapCounter({super.key});

  @override
  State<TapCounter> createState() => _TapCounterState();
}

class _TapCounterState extends State<TapCounter> {
  int _taps = 0;
  int _doubleTaps = 0;
  int _longPresses = 0;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10
// Создай два экрана: HomeScreen и DetailScreen.
// HomeScreen содержит кнопку "Открыть детали", при нажатии
// переходи на DetailScreen, передавая строку "Привет от Home!".
// DetailScreen отображает переданный текст и кнопку "Назад".
//
// Подсказка: Navigator.push, Navigator.pop, MaterialPageRoute, arguments.

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class DetailScreen extends StatelessWidget {
  final String message;
  const DetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Создай виджет ConfirmButton — кнопка "Удалить".
// При нажатии показывай AlertDialog с вопросом "Вы уверены?"
// и кнопками "Отмена" и "Удалить".
// При подтверждении показывай SnackBar "Удалено!".
//
// Подсказка: showDialog, AlertDialog, TextButton, ScaffoldMessenger.

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 12
// Создай виджет TabsApp — Scaffold с AppBar и DefaultTabController на 3 вкладки:
// "Главная", "Профиль", "Настройки".
// Каждая вкладка отображает по центру своё название.
//
// Подсказка: DefaultTabController, TabBar, TabBarView, Tab.

class TabsApp extends StatelessWidget {
  const TabsApp({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

/// Продвинутый уровень (13–20)

// ЗАДАЧА 13
// Создай виджет AnimatedBox — нажатие на кнопку плавно меняет
// цвет контейнера между синим и оранжевым,
// а размер — между 100x100 и 200x200.
//
// Подсказка: AnimatedContainer, Duration, setState.

class AnimatedBox extends StatefulWidget {
  const AnimatedBox({super.key});

  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 14
// Создай виджет FadeInText — текст "Появляюсь!" плавно появляется
// при нажатии кнопки "Показать" (AnimatedOpacity, duration 1 секунда).
//
// Подсказка: AnimatedOpacity, setState, opacity от 0.0 до 1.0.

class FadeInText extends StatefulWidget {
  const FadeInText({super.key});

  @override
  State<FadeInText> createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText> {
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 15
// Создай виджет UserLoader — FutureBuilder, который:
// — делает "запрос" (Future.delayed 2 сек, возвращает Map с именем и email)
// — во время загрузки показывает CircularProgressIndicator
// — при успехе отображает имя и email
// — при ошибке — текст ошибки
//
// Подсказка: FutureBuilder, ConnectionState, AsyncSnapshot.

Future<Map<String, String>> fetchUser() async {
  throw UnimplementedError();
}

class UserLoader extends StatelessWidget {
  const UserLoader({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 16
// Создай виджет LiveTimer — StreamBuilder, отображающий текущее время
// (часы:минуты:секунды), обновляющееся каждую секунду.
//
// Подсказка: Stream.periodic, Duration(seconds: 1), DateTime.now(),
// StreamBuilder, AsyncSnapshot.

class LiveTimer extends StatelessWidget {
  const LiveTimer({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 17
// Создай виджет DrawerMenu — Scaffold с AppBar и Drawer.
// Drawer содержит заголовок (DrawerHeader) и 3 пункта меню:
// "Главная", "Профиль", "Выход" — с иконками.
// При выборе пункта закрывай Drawer и показывай SnackBar с названием пункта.
//
// Подсказка: Drawer, DrawerHeader, ListTile, Navigator.pop, ScaffoldMessenger.

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 18
// Создай виджет BottomNavApp — BottomNavigationBar с тремя вкладками:
// "Дом" (Icons.home), "Поиск" (Icons.search), "Профиль" (Icons.person).
// При переключении вкладок отображай соответствующий экран.
//
// Подсказка: BottomNavigationBar, BottomNavigationBarItem, setState, IndexedStack.

class BottomNavApp extends StatefulWidget {
  const BottomNavApp({super.key});

  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 19
// Создай виджет ThemeToggleApp — приложение с переключателем темы
// (светлая / тёмная). Кнопка в AppBar переключает тему MaterialApp.
//
// Подсказка: ValueNotifier<ThemeMode>, ValueListenableBuilder, MaterialApp,
// ThemeMode.light / ThemeMode.dark, IconButton, Icons.dark_mode / Icons.light_mode.

class ThemeToggleApp extends StatefulWidget {
  const ThemeToggleApp({super.key});

  @override
  State<ThemeToggleApp> createState() => _ThemeToggleAppState();
}

class _ThemeToggleAppState extends State<ThemeToggleApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 20
// Создай виджет DraggableCard — перетаскиваемая карточка по экрану.
// Карточка — Container 80x80, синий фон, скруглённые углы.
// При перетаскивании она следует за пальцем / мышью.
//
// Подсказка: GestureDetector.onPanUpdate, setState, Positioned, Stack,
// Offset или переменные dx/dy.

class DraggableCard extends StatefulWidget {
  const DraggableCard({super.key});

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  double _x = 100;
  double _y = 100;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
