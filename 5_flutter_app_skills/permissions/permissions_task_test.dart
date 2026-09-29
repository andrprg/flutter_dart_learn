import 'package:flutter_test/flutter_test.dart';

import 'permissions_task.dart';

void main() {
  group('Permissions helpers', () {
    test('isPermissionUsable / canRequestAgain / shouldOpenSettings', () {
      expect(isPermissionUsable(PermissionStatus.granted), isTrue);
      expect(isPermissionUsable(PermissionStatus.limited), isTrue);
      expect(isPermissionUsable(PermissionStatus.denied), isFalse);

      expect(canRequestAgain(PermissionStatus.denied), isTrue);
      expect(canRequestAgain(PermissionStatus.permanentlyDenied), isFalse);

      expect(shouldOpenSettings(PermissionStatus.permanentlyDenied), isTrue);
      expect(shouldOpenSettings(PermissionStatus.denied), isFalse);
    });

    test('rationaleFor и permissionForFeature', () {
      expect(
        rationaleFor(AppPermission.notifications),
        'Нужны, чтобы сообщать о новых событиях',
      );
      expect(permissionForFeature('push_inbox'), AppPermission.notifications);
      expect(permissionForFeature('chat_voice'), AppPermission.microphone);
      expect(() => permissionForFeature('unknown'), throwsArgumentError);
    });

    test('accessFromStatus', () {
      expect(accessFromStatus(PermissionStatus.granted), FeatureAccess.allowed);
      expect(accessFromStatus(PermissionStatus.denied), FeatureAccess.needsRequest);
      expect(
        accessFromStatus(PermissionStatus.permanentlyDenied),
        FeatureAccess.needsSettings,
      );
      expect(
        accessFromStatus(PermissionStatus.restricted),
        FeatureAccess.unavailable,
      );
    });

    test('ensureAccess запрашивает только при denied', () async {
      final gateway = FakePermissionGateway({
        AppPermission.camera: PermissionStatus.granted,
      });

      final already = await ensureAccess(gateway, AppPermission.camera);
      expect(already, FeatureAccess.allowed);

      gateway.setStatus(AppPermission.photos, PermissionStatus.denied);
      gateway.nextRequestResult = PermissionStatus.granted;
      final requested = await ensureAccess(gateway, AppPermission.photos);
      expect(requested, FeatureAccess.allowed);

      gateway.setStatus(
        AppPermission.location,
        PermissionStatus.permanentlyDenied,
      );
      final blocked = await ensureAccess(gateway, AppPermission.location);
      expect(blocked, FeatureAccess.needsSettings);
    });

    test('openSettingsIfNeeded', () async {
      final gateway = FakePermissionGateway();

      expect(
        await openSettingsIfNeeded(gateway, FeatureAccess.allowed),
        isFalse,
      );
      expect(gateway.settingsOpened, isFalse);

      expect(
        await openSettingsIfNeeded(gateway, FeatureAccess.needsSettings),
        isTrue,
      );
      expect(gateway.settingsOpened, isTrue);
    });

    test('areAllGranted и missingPermissions', () async {
      final gateway = FakePermissionGateway({
        AppPermission.camera: PermissionStatus.granted,
        AppPermission.photos: PermissionStatus.denied,
        AppPermission.microphone: PermissionStatus.limited,
      });

      expect(
        await areAllGranted(gateway, [
          AppPermission.camera,
          AppPermission.microphone,
        ]),
        isTrue,
      );

      final missing = await missingPermissions(gateway, [
        AppPermission.camera,
        AppPermission.photos,
        AppPermission.microphone,
      ]);
      expect(missing, [AppPermission.photos]);
    });

    test('androidPermissionName и statusLabel', () {
      expect(
        androidPermissionName(AppPermission.notifications),
        'android.permission.POST_NOTIFICATIONS',
      );
      expect(androidPermissionName(AppPermission.camera), isNull);

      expect(statusLabel(PermissionStatus.permanentlyDenied), 'blocked');
      expect(statusLabel(PermissionStatus.granted), 'granted');
      expect(statusLabel(PermissionStatus.limited), 'limited');
    });
  });
}
