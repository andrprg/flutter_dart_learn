import 'package:flutter_test/flutter_test.dart';

import 'lifecycle_task.dart';

void main() {
  group('App lifecycle helpers', () {
    test('foreground / invisible / persist / sync flags', () {
      expect(isForeground(AppLifeState.resumed), isTrue);
      expect(isForeground(AppLifeState.paused), isFalse);

      expect(isUiInvisible(AppLifeState.paused), isTrue);
      expect(isUiInvisible(AppLifeState.hidden), isTrue);
      expect(isUiInvisible(AppLifeState.inactive), isFalse);

      expect(shouldPersistDraft(AppLifeState.paused), isTrue);
      expect(shouldPersistDraft(AppLifeState.hidden), isTrue);
      expect(shouldPersistDraft(AppLifeState.inactive), isFalse);

      expect(shouldResumeSync(AppLifeState.resumed), isTrue);
      expect(shouldPauseSync(AppLifeState.detached), isTrue);
      expect(shouldPauseSync(AppLifeState.resumed), isFalse);
    });

    test('lifeStateLabel и createEvent', () {
      expect(lifeStateLabel(AppLifeState.paused), 'background');
      expect(lifeStateLabel(AppLifeState.resumed), 'active');

      final at = DateTime.utc(2026, 1, 1);
      final event = createEvent(
        from: AppLifeState.resumed,
        to: AppLifeState.inactive,
        at: at,
      );
      expect(event.from, AppLifeState.resumed);
      expect(event.to, AppLifeState.inactive);
      expect(event.at, at);
    });

    test('handleLifecycleChange управляет DraftBox', () {
      final box = DraftBox()..text = 'hello';

      handleLifecycleChange(box, AppLifeState.paused);
      expect(box.savedToDisk, isTrue);
      expect(box.syncPaused, isTrue);

      handleLifecycleChange(box, AppLifeState.resumed);
      expect(box.syncPaused, isFalse);
      expect(box.resumeCount, 1);
    });

    test('isValidTransition', () {
      expect(
        isValidTransition(AppLifeState.resumed, AppLifeState.inactive),
        isTrue,
      );
      expect(
        isValidTransition(AppLifeState.resumed, AppLifeState.paused),
        isFalse,
      );
      expect(
        isValidTransition(AppLifeState.detached, AppLifeState.resumed),
        isTrue,
      );
    });

    test('countResumes и backgroundDuration', () {
      final t0 = DateTime.utc(2026, 1, 1, 12, 0, 0);
      final t1 = DateTime.utc(2026, 1, 1, 12, 0, 5);
      final t2 = DateTime.utc(2026, 1, 1, 12, 0, 20);

      final events = [
        LifecycleEvent(from: AppLifeState.resumed, to: AppLifeState.inactive, at: t0),
        LifecycleEvent(from: AppLifeState.inactive, to: AppLifeState.paused, at: t1),
        LifecycleEvent(from: AppLifeState.paused, to: AppLifeState.resumed, at: t2),
      ];

      expect(countResumes(events), 1);
      expect(backgroundDuration(events), const Duration(seconds: 15));
      expect(backgroundDuration(events.take(2).toList()), isNull);
    });

    test('LifecycleController пишет историю и валидирует переход', () {
      final controller = LifecycleController();
      final now = DateTime.utc(2026, 2, 1);

      controller.changeTo(AppLifeState.inactive, now: now);
      expect(controller.current, AppLifeState.inactive);
      expect(controller.history, hasLength(1));

      expect(
        () => controller.changeTo(AppLifeState.detached, now: now),
        throwsStateError,
      );
    });
  });
}
