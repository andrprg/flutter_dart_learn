import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (скопирована из task_14_animations.dart) ─────────────────────

class PulseButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const PulseButton({super.key, required this.label, this.onPressed});

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AnimatedCard(
      {super.key, required this.child, this.delay = Duration.zero});

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  group('Задача 14 — Анимации Flutter', () {
    group('PulseButton', () {
      // После каждого теста диспозим виджет с бесконечной анимацией
      tearDown(() async {
        // Диспоз происходит при замене дерева в следующем тесте
      });

      testWidgets('Рендерится с правильным лейблом', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: Center(child: PulseButton(label: 'Тест'))),
        ));
        await tester.pump(const Duration(milliseconds: 700));
        expect(find.text('Тест'), findsOneWidget);
      });

      testWidgets('Использует ScaleTransition', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: Center(child: PulseButton(label: 'X'))),
        ));
        await tester.pump();
        // PulseButton и ElevatedButton оба могут использовать ScaleTransition
        expect(find.byType(ScaleTransition), findsWidgets);
      });

      testWidgets('Кнопка вызывает onPressed', (tester) async {
        bool pressed = false;
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Center(
              child: PulseButton(label: 'Жми', onPressed: () => pressed = true),
            ),
          ),
        ));
        await tester.pump();
        await tester.tap(find.byType(ElevatedButton));
        expect(pressed, isTrue);
      });

      testWidgets('Масштаб в диапазоне [1.0, 1.15]', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: Center(child: PulseButton(label: 'P'))),
        ));
        await tester.pump();
        // Первый ScaleTransition — наш PulseButton
        final scaleTransitions = tester.widgetList<ScaleTransition>(find.byType(ScaleTransition));
        expect(scaleTransitions.first.scale.value, inInclusiveRange(1.0, 1.15));
      });

      testWidgets('Dispose не вызывает ошибок', (tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: Center(child: PulseButton(label: 'X'))),
        ));
        await tester.pump();
        await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));
        await tester.pump(const Duration(milliseconds: 700));
        expect(tester.takeException(), isNull);
      });
    });

    // Завершает все таймеры и анимации AnimatedCard
    Future<void> settleAnimatedCard(WidgetTester tester) async {
      await tester.pump(); // срабатывает Future.delayed(Duration.zero)
      await tester.pump(const Duration(milliseconds: 500)); // завершает opacity/slide
    }

    group('AnimatedCard', () {
      testWidgets('Начально невидим (opacity = 0)', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: AnimatedCard(child: const Text('карточка'))),
        ));
        // До pump — opacity = 0 (visible=false)
        final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
        expect(opacity.opacity, equals(0.0));
        await settleAnimatedCard(tester);
      });

      testWidgets('После delay становится видимым', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: AnimatedCard(child: const Text('карточка'))),
        ));
        await settleAnimatedCard(tester);
        final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
        expect(opacity.opacity, equals(1.0));
      });

      testWidgets('Использует AnimatedSlide', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: AnimatedCard(child: const Text('test'))),
        ));
        expect(find.byType(AnimatedSlide), findsOneWidget);
        await settleAnimatedCard(tester);
      });

      testWidgets('Отображает дочерний виджет', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: AnimatedCard(child: const Text('visible content'))),
        ));
        expect(find.text('visible content'), findsOneWidget);
        await settleAnimatedCard(tester);
      });

      testWidgets('Работает с кастомной задержкой', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AnimatedCard(
              delay: const Duration(milliseconds: 300),
              child: const Text('delayed'),
            ),
          ),
        ));
        // До задержки — невидим
        expect(
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
          equals(0.0),
        );
        // После задержки + анимации — виден
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 500));
        expect(
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
          equals(1.0),
        );
      });
    });
  });
}
