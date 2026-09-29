import 'package:flutter_test/flutter_test.dart';

import 'notifications_task.dart';

void main() {
  group('Local notifications helpers', () {
    test('createWebsocketChannel создаёт канал с high importance', () {
      final channel = createWebsocketChannel();

      expect(channel.id, 'websocket_events');
      expect(channel.name, 'WebSocket events');
      expect(channel.description, 'Notifications received from WebSocket');
      expect(channel.importance, NotificationImportance.high);
      expect(isHeadsUpChannel(channel), isTrue);
    });

    test('createConfirmAction возвращает confirm', () {
      final action = createConfirmAction();

      expect(action.id, 'confirm');
      expect(action.title, 'Подтвердить');
    });

    test('interactionTypeFrom различает tap и action', () {
      expect(interactionTypeFrom(null), NotificationInteractionType.tap);
      expect(interactionTypeFrom(''), NotificationInteractionType.tap);
      expect(interactionTypeFrom('confirm'), NotificationInteractionType.action);
    });

    test('buildResponse и shouldHandleAction работают вместе', () {
      final tap = buildResponse(payload: 'event:1');
      final action = buildResponse(actionId: 'confirm', payload: 'event:1');

      expect(tap.type, NotificationInteractionType.tap);
      expect(shouldHandleAction(tap), isFalse);
      expect(shouldHandleAction(action), isTrue);
    });

    test('validateShowRequest проверяет поля', () {
      expect(
        () => validateShowRequest(
          const ShowNotificationRequest(id: -1, title: 't', body: 'b'),
        ),
        throwsArgumentError,
      );
      expect(
        () => validateShowRequest(
          const ShowNotificationRequest(id: 1, title: '', body: 'b'),
        ),
        throwsArgumentError,
      );
      expect(
        () => validateShowRequest(
          const ShowNotificationRequest(id: 1, title: 't', body: 'b'),
        ),
        returnsNormally,
      );
    });

    test('eventPayload и parseEventId', () {
      expect(eventPayload('42'), 'event:42');
      expect(parseEventId('event:42'), '42');
      expect(parseEventId('bad'), isNull);
      expect(parseEventId(null), isNull);
    });

    test('NotificationService показывает только после initialize', () async {
      final handled = <String>[];
      final service = NotificationService(
        onAction: (actionId, payload) async {
          handled.add('$actionId:$payload');
        },
      );

      expect(service.isInitialized, isFalse);

      expect(
        () => service.show(
          const ShowNotificationRequest(id: 1, title: 't', body: 'b'),
        ),
        throwsStateError,
      );

      await service.initialize();
      expect(service.isInitialized, isTrue);

      await service.show(
        const ShowNotificationRequest(
          id: 1,
          title: 'Hello',
          body: 'World',
          payload: 'event:7',
        ),
      );
      expect(service.shown, hasLength(1));

      await service.handleResponse(
        const NotificationResponse(
          type: NotificationInteractionType.tap,
          payload: 'event:7',
        ),
      );
      expect(handled, isEmpty);

      await service.handleResponse(
        const NotificationResponse(
          type: NotificationInteractionType.action,
          actionId: 'confirm',
          payload: 'event:7',
        ),
      );
      expect(handled, ['confirm:event:7']);
    });

    test('requiredNotificationPermissions и category id', () {
      expect(
        requiredNotificationPermissions(),
        ['alert', 'badge', 'sound'],
      );
      expect(iosWebsocketCategoryId(), 'websocket_event');
    });
  });
}
