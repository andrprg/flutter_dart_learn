import 'package:flutter_test/flutter_test.dart';

import 'push_task.dart';

void main() {
  group('Push message kind and delivery', () {
    test('messageKind различает notification, data и both', () {
      expect(
        messageKind(const RemotePushMessage(messageId: '1', title: 'Hi')),
        PushMessageKind.notification,
      );
      expect(
        messageKind(
          const RemotePushMessage(
            messageId: '3',
            data: {'type': 'sync'},
          ),
        ),
        PushMessageKind.data,
      );
      expect(
        messageKind(
          const RemotePushMessage(
            messageId: '4',
            title: 'Заказ',
            data: {'type': 'order', 'id': '3'},
          ),
        ),
        PushMessageKind.both,
      );
      expect(
        () => messageKind(const RemotePushMessage(messageId: '5')),
        throwsArgumentError,
      );
    });

    test('пробельный title без data — ArgumentError', () {
      expect(
        () => messageKind(
          const RemotePushMessage(messageId: '1', title: '  ', body: ''),
        ),
        throwsArgumentError,
      );
    });

    test('arrivalPlan зависит от kind и состояния', () {
      expect(
        arrivalPlan(PushMessageKind.notification, PushAppState.foreground),
        PushArrival.onMessage,
      );
      expect(
        arrivalPlan(PushMessageKind.data, PushAppState.foreground),
        PushArrival.onMessage,
      );
      expect(
        arrivalPlan(PushMessageKind.both, PushAppState.foreground),
        PushArrival.onMessage,
      );
      expect(
        arrivalPlan(PushMessageKind.notification, PushAppState.background),
        PushArrival.systemTray,
      );
      expect(
        arrivalPlan(PushMessageKind.notification, PushAppState.terminated),
        PushArrival.systemTray,
      );
      expect(
        arrivalPlan(PushMessageKind.data, PushAppState.background),
        PushArrival.backgroundHandler,
      );
      expect(
        arrivalPlan(PushMessageKind.data, PushAppState.terminated),
        PushArrival.backgroundHandler,
      );
      expect(
        arrivalPlan(PushMessageKind.both, PushAppState.background),
        PushArrival.systemTrayAndBackground,
      );
      expect(
        arrivalPlan(PushMessageKind.both, PushAppState.terminated),
        PushArrival.systemTrayAndBackground,
      );
    });

    test('tapSource только для background и terminated', () {
      expect(tapSource(PushAppState.foreground), isNull);
      expect(tapSource(PushAppState.background), PushTapSource.openedApp);
      expect(tapSource(PushAppState.terminated), PushTapSource.initialMessage);
    });

    test('systemShowsBanner молчит в foreground и на data-only', () {
      for (final kind in PushMessageKind.values) {
        expect(systemShowsBanner(kind, PushAppState.foreground), isFalse);
      }
      expect(
        systemShowsBanner(PushMessageKind.notification, PushAppState.background),
        isTrue,
      );
      expect(
        systemShowsBanner(PushMessageKind.both, PushAppState.terminated),
        isTrue,
      );
      expect(
        systemShowsBanner(PushMessageKind.data, PushAppState.background),
        isFalse,
      );
      expect(
        systemShowsBanner(PushMessageKind.data, PushAppState.terminated),
        isFalse,
      );
    });
  });

  group('Token, route, dedup, topics', () {
    test('isValidFcmToken и shouldUploadToken', () {
      expect(isValidFcmToken(null), isFalse);
      expect(isValidFcmToken(''), isFalse);
      expect(isValidFcmToken('   '), isFalse);
      expect(isValidFcmToken('bad token'), isFalse);
      expect(isValidFcmToken('  token_one  '), isTrue);

      expect(shouldUploadToken(previous: null, next: 'token_one'), isTrue);
      expect(
        shouldUploadToken(previous: 'token_one', next: ' token_one '),
        isFalse,
      );
      expect(
        shouldUploadToken(previous: 'token_one', next: 'token_two'),
        isTrue,
      );
      expect(shouldUploadToken(previous: 'token_one', next: 'a b'), isFalse);
      expect(shouldUploadToken(previous: 'bad token', next: 'token_ok'), isTrue);
    });

    test('routeFromData предпочитает явный route', () {
      expect(routeFromData(const {'route': '/promo'}), '/promo');
      expect(
        routeFromData(const {
          'route': '/chat/1',
          'type': 'order',
          'id': '2',
        }),
        '/chat/1',
      );
      expect(routeFromData(const {'type': 'chat', 'id': '9'}), '/chat/9');
      expect(routeFromData(const {'type': 'order', 'id': '3'}), '/orders/3');
      expect(routeFromData(const {'type': 'promo', 'id': '1'}), isNull);
      expect(routeFromData(const {'type': 'chat', 'id': ''}), isNull);
      expect(routeFromData(const {'type': 'chat'}), isNull);
      expect(routeFromData(const {'route': 'chat/1'}), isNull);
      expect(routeFromData(const {}), isNull);
    });

    test('PushDeduper пропускает повтор и пустой id', () {
      final deduper = PushDeduper();

      expect(deduper.accept('a'), isTrue);
      expect(deduper.accept('a'), isFalse);
      expect(deduper.accept(''), isFalse);
      expect(deduper.accept('b'), isTrue);
      expect(deduper.seen, {'a', 'b'});
    });

    test('isValidTopic принимает имя FCM и отвергает путь', () {
      expect(isValidTopic('news'), isTrue);
      expect(isValidTopic('chat.user_1'), isTrue);
      expect(isValidTopic('a-b~c%1'), isTrue);
      expect(isValidTopic(''), isFalse);
      expect(isValidTopic('/topics/news'), isFalse);
      expect(isValidTopic('has space'), isFalse);
      expect(isValidTopic('новости'), isFalse);
      expect(isValidTopic('a' * 900), isTrue);
      expect(isValidTopic('a' * 901), isFalse);
    });

    test('collapseTray оставляет последнее сообщение с тем же ключом', () {
      final collapsed = collapseTray(const [
        RemotePushMessage(
          messageId: 'a',
          title: '1',
          collapseKey: 'chat',
        ),
        RemotePushMessage(messageId: 'b', title: 'other'),
        RemotePushMessage(
          messageId: 'c',
          title: '3',
          collapseKey: 'chat',
        ),
      ]);

      expect(collapsed.map((m) => m.messageId), ['c', 'b']);

      final twoKeys = collapseTray(const [
        RemotePushMessage(messageId: 'a', collapseKey: 'k1', title: '1'),
        RemotePushMessage(messageId: 'b', collapseKey: 'k2', title: '2'),
        RemotePushMessage(messageId: 'c', collapseKey: 'k1', title: '3'),
      ]);
      expect(twoKeys.map((m) => m.messageId), ['c', 'b']);

      final noCollapse = collapseTray(const [
        RemotePushMessage(messageId: 'a', collapseKey: '', title: '1'),
        RemotePushMessage(messageId: 'b', collapseKey: '', title: '2'),
      ]);
      expect(noCollapse.map((m) => m.messageId), ['a', 'b']);
    });

    test('canRegisterBackgroundHandler требует три условия сразу', () {
      expect(
        canRegisterBackgroundHandler(
          isTopLevelOrStatic: true,
          isAnonymous: false,
          registeredBeforeRunApp: true,
        ),
        isTrue,
      );
      expect(
        canRegisterBackgroundHandler(
          isTopLevelOrStatic: false,
          isAnonymous: false,
          registeredBeforeRunApp: true,
        ),
        isFalse,
      );
      expect(
        canRegisterBackgroundHandler(
          isTopLevelOrStatic: true,
          isAnonymous: true,
          registeredBeforeRunApp: true,
        ),
        isFalse,
      );
      expect(
        canRegisterBackgroundHandler(
          isTopLevelOrStatic: true,
          isAnonymous: false,
          registeredBeforeRunApp: false,
        ),
        isFalse,
      );
    });
  });

  group('DeviceTokenRegistry', () {
    test('синк, повтор того же токена и logout', () {
      final registry = DeviceTokenRegistry();

      expect(() => registry.onTokenRefresh(null), throwsArgumentError);
      expect(() => registry.onTokenRefresh(''), throwsArgumentError);
      expect(() => registry.onTokenRefresh('bad token'), throwsArgumentError);
      expect(() => registry.markSynced(), throwsStateError);
      expect(registry.needsSync, isFalse);

      registry.onTokenRefresh('  token_abc  ');
      expect(registry.token, 'token_abc');
      expect(registry.needsSync, isTrue);

      registry.onTokenRefresh('token_abc');
      expect(registry.needsSync, isTrue);

      registry.markSynced();
      expect(registry.needsSync, isFalse);

      registry.onTokenRefresh(' token_abc ');
      expect(registry.token, 'token_abc');
      expect(registry.needsSync, isFalse);

      registry.onTokenRefresh('token_xyz');
      expect(registry.token, 'token_xyz');
      expect(registry.needsSync, isTrue);

      registry.onLogout();
      expect(registry.token, isNull);
      expect(registry.needsSync, isFalse);
      expect(() => registry.markSynced(), throwsStateError);
    });
  });
}
