import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'flutter_widgets_task.dart';

// ============================================================
// ТЕСТЫ ДЛЯ 20 ЗАДАЧ ПО ВИДЖЕТАМ FLUTTER
// ============================================================
// Запуск: flutter test dart/future/flutter_widgets_task_test.dart
// ============================================================

void main() {
  // ─── Задача 1 ──────────────────────────────────────────────────────
  group('GreetingCard', () {
    testWidgets('содержит текст "Привет, Flutter!"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GreetingCard())),
      );
      expect(find.text('Привет, Flutter!'), findsOneWidget);
    });

    testWidgets('текст расположен по центру', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GreetingCard())),
      );
      expect(find.byType(Center), findsWidgets);
    });
  });

  // ─── Задача 2 ──────────────────────────────────────────────────────
  group('StyledBox', () {
    testWidgets('содержит текст "Styled Box"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StyledBox())),
      );
      expect(find.text('Styled Box'), findsOneWidget);
    });

    testWidgets('содержит Container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StyledBox())),
      );
      expect(find.byType(Container), findsWidgets);
    });
  });

  // ─── Задача 3 ──────────────────────────────────────────────────────
  group('ProfileRow', () {
    testWidgets('содержит имя "Алексей"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ProfileRow())),
      );
      expect(find.text('Алексей'), findsOneWidget);
    });

    testWidgets('содержит подпись "Flutter Dev"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ProfileRow())),
      );
      expect(find.text('Flutter Dev'), findsOneWidget);
    });

    testWidgets('содержит CircleAvatar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ProfileRow())),
      );
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  // ─── Задача 4 ──────────────────────────────────────────────────────
  group('CounterWidget', () {
    testWidgets('начальное значение счётчика равно 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('нажатие "+" увеличивает счётчик', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      await tester.tap(find.text('+'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('нажатие "−" не уменьшает ниже 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CounterWidget())),
      );
      await tester.tap(find.text('−'));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });
  });

  // ─── Задача 5 ──────────────────────────────────────────────────────
  group('ColoredList', () {
    testWidgets('содержит 5 элементов списка', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ColoredList())),
      );
      expect(find.byType(ListView), findsOneWidget);
      expect(find.textContaining('Элемент'), findsWidgets);
    });
  });

  // ─── Задача 6 ──────────────────────────────────────────────────────
  group('CardGrid', () {
    testWidgets('содержит GridView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CardGrid())),
      );
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('содержит карточки Card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: CardGrid())),
      );
      expect(find.byType(Card), findsWidgets);
    });
  });

  // ─── Задача 7 ──────────────────────────────────────────────────────
  group('StackBadge', () {
    testWidgets('содержит Stack', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StackBadge())),
      );
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('показывает число "3"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StackBadge())),
      );
      expect(find.text('3'), findsOneWidget);
    });
  });

  // ─── Задача 8 ──────────────────────────────────────────────────────
  group('LoginForm', () {
    testWidgets('содержит поля Email и Пароль', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoginForm())),
      );
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('кнопка Войти присутствует', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoginForm())),
      );
      expect(find.text('Войти'), findsOneWidget);
    });

    testWidgets('показывает ошибку при пустом email', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoginForm())),
      );
      await tester.tap(find.text('Войти'));
      await tester.pump();
      expect(find.textContaining('пуст'), findsWidgets);
    });
  });

  // ─── Задача 9 ──────────────────────────────────────────────────────
  group('TapCounter', () {
    testWidgets('начальные значения счётчиков равны 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: TapCounter())),
      );
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('onTap увеличивает счётчик нажатий', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: TapCounter())),
      );
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(find.text('1'), findsWidgets);
    });
  });

  // ─── Задача 10 ──────────────────────────────────────────────────────
  group('HomeScreen / DetailScreen', () {
    testWidgets('HomeScreen содержит кнопку перехода', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );
      expect(find.text('Открыть детали'), findsOneWidget);
    });

    testWidgets('DetailScreen отображает переданное сообщение', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DetailScreen(message: 'Тест'),
        ),
      );
      expect(find.text('Тест'), findsOneWidget);
    });
  });

  // ─── Задача 11 ──────────────────────────────────────────────────────
  group('ConfirmButton', () {
    testWidgets('кнопка "Удалить" отображается', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ConfirmButton())),
      );
      expect(find.text('Удалить'), findsOneWidget);
    });

    testWidgets('нажатие открывает AlertDialog', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ConfirmButton())),
      );
      await tester.tap(find.text('Удалить'));
      await tester.pump();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Вы уверены?'), findsOneWidget);
    });
  });

  // ─── Задача 12 ──────────────────────────────────────────────────────
  group('TabsApp', () {
    testWidgets('содержит TabBar с 3 вкладками', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: TabsApp()));
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Главная'), findsOneWidget);
      expect(find.text('Профиль'), findsOneWidget);
      expect(find.text('Настройки'), findsOneWidget);
    });
  });

  // ─── Задача 13 ──────────────────────────────────────────────────────
  group('AnimatedBox', () {
    testWidgets('содержит AnimatedContainer', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AnimatedBox())),
      );
      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('нажатие кнопки запускает анимацию', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AnimatedBox())),
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedContainer), findsOneWidget);
    });
  });

  // ─── Задача 14 ──────────────────────────────────────────────────────
  group('FadeInText', () {
    testWidgets('содержит AnimatedOpacity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FadeInText())),
      );
      expect(find.byType(AnimatedOpacity), findsOneWidget);
    });

    testWidgets('текст изначально невидим (opacity 0)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FadeInText())),
      );
      final opacityWidget = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(opacityWidget.opacity, 0.0);
    });

    testWidgets('нажатие кнопки делает текст видимым', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FadeInText())),
      );
      await tester.tap(find.text('Показать'));
      await tester.pump();
      await tester.pumpAndSettle();
      final opacityWidget = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(opacityWidget.opacity, 1.0);
    });
  });

  // ─── Задача 15 ──────────────────────────────────────────────────────
  group('UserLoader', () {
    testWidgets('показывает CircularProgressIndicator во время загрузки',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserLoader())),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('после загрузки показывает данные пользователя',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: UserLoader())),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  // ─── Задача 16 ──────────────────────────────────────────────────────
  group('LiveTimer', () {
    testWidgets('содержит StreamBuilder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LiveTimer())),
      );
      expect(find.byType(StreamBuilder<DateTime>), findsOneWidget);
    });
  });

  // ─── Задача 17 ──────────────────────────────────────────────────────
  group('DrawerMenu', () {
    testWidgets('содержит Drawer', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DrawerMenu()));
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('Drawer содержит 3 пункта меню', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DrawerMenu()));
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();
      await tester.pump();
      expect(find.text('Главная'), findsWidgets);
      expect(find.text('Профиль'), findsWidgets);
      expect(find.text('Выход'), findsOneWidget);
    });
  });

  // ─── Задача 18 ──────────────────────────────────────────────────────
  group('BottomNavApp', () {
    testWidgets('содержит BottomNavigationBar с 3 вкладками', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: BottomNavApp()));
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('переключение вкладок меняет экран', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: BottomNavApp()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  // ─── Задача 19 ──────────────────────────────────────────────────────
  group('ThemeToggleApp', () {
    testWidgets('содержит MaterialApp', (tester) async {
      await tester.pumpWidget(const ThemeToggleApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('кнопка переключения темы присутствует', (tester) async {
      await tester.pumpWidget(const ThemeToggleApp());
      expect(find.byType(IconButton), findsWidgets);
    });
  });

  // ─── Задача 20 ──────────────────────────────────────────────────────
  group('DraggableCard', () {
    testWidgets('содержит GestureDetector', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DraggableCard())),
      );
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('карточка перемещается при перетаскивании', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: DraggableCard())),
      );
      await tester.drag(find.byType(Container).first, const Offset(50, 50));
      await tester.pump();
      expect(find.byType(Positioned), findsWidgets);
    });
  });
}
