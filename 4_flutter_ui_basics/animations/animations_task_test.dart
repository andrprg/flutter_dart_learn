import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'animations_task.dart';

void main() {
  group('Animations helpers', () {
    test('implicit / ticker / progress / lerp / ease / status', () {
      expect(isImplicitAnimation('AnimatedContainer'), isTrue);
      expect(isImplicitAnimation('AnimationController'), isFalse);
      expect(needsTickerProvider('AnimationController'), isTrue);
      expect(needsTickerProvider('AnimatedOpacity'), isFalse);

      expect(
        animationProgress(const Duration(milliseconds: 50), const Duration(milliseconds: 100)),
        0.5,
      );
      expect(lerpDoubleValue(0, 10, 0.5), 5);
      expect(easeInProgress(0), 0);
      expect(easeInProgress(1), 1);
      expect(statusLabel(AnimationStatus.completed), 'completed');
      expect(mustDisposeAnimationController(), isTrue);
    });

    testWidgets('createController / tween', (tester) async {
      late AnimationController controller;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: _TickerHost(
            onReady: (vsync) {
              controller = createController(
                vsync: vsync,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
        ),
      );
      addTearDown(controller.dispose);

      final animation = createTweenAnimation(
        controller: controller,
        begin: 0,
        end: 1,
      );
      expect(animation.value, 0);
    });

    testWidgets('FadeBox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FadeBox(visible: false, child: Text('X')),
          ),
        ),
      );
      final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
      expect(opacity.opacity, 0);
    });

    testWidgets('ScaleOnTap и PulseDot строятся', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScaleOnTap(child: Text('tap')),
          ),
        ),
      );
      expect(find.text('tap'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PulseDot()),
        ),
      );
      expect(find.byType(PulseDot), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 50));
    });
  });
}

class _TickerHost extends StatefulWidget {
  const _TickerHost({required this.onReady});

  final void Function(TickerProvider vsync) onReady;

  @override
  State<_TickerHost> createState() => _TickerHostState();
}

class _TickerHostState extends State<_TickerHost>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onReady(this);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
