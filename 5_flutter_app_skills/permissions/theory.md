# Шпаргалка: Permissions

Разрешения — мост между фичей приложения и системным диалогом. Не «запросить всё на старте», а: статус → rationale → request → при необходимости настройки.

Перед задачами прочитай этот файл, затем решай `permissions_task.dart`.

## 1. Статусы

| Status | Смысл |
|---|---|
| `denied` | ещё нет / можно спросить снова |
| `granted` | полный доступ |
| `limited` | частичный (фото iOS 14+) |
| `permanentlyDenied` | «больше не спрашивать» → настройки |
| `restricted` | система/MDM/родительский контроль |

```dart
bool isPermissionUsable(PermissionStatus s) =>
    s == PermissionStatus.granted || s == PermissionStatus.limited;

bool canRequestAgain(PermissionStatus s) => s == PermissionStatus.denied;

bool shouldOpenSettings(PermissionStatus s) =>
    s == PermissionStatus.permanentlyDenied;
```

`limited` для UX часто считают успехом (можно работать с выбранными фото).

## 2. Feature → permission → access

```dart
AppPermission permissionForFeature(String feature) => switch (feature) {
  'chat_voice' => AppPermission.microphone,
  'avatar_camera' => AppPermission.camera,
  'avatar_gallery' => AppPermission.photos,
  'nearby_map' => AppPermission.location,
  'push_inbox' => AppPermission.notifications,
  _ => throw ArgumentError.value(feature),
};

FeatureAccess accessFromStatus(PermissionStatus s) {
  if (isPermissionUsable(s)) return FeatureAccess.allowed;
  if (canRequestAgain(s)) return FeatureAccess.needsRequest;
  if (s == PermissionStatus.permanentlyDenied) return FeatureAccess.needsSettings;
  return FeatureAccess.unavailable; // restricted
}
```

## 3. ensureAccess

```dart
Future<FeatureAccess> ensureAccess(
  PermissionGateway gateway,
  AppPermission permission,
) async {
  final current = await gateway.status(permission);
  if (isPermissionUsable(current)) return FeatureAccess.allowed;
  if (canRequestAgain(current)) {
    final next = await gateway.request(permission);
    return accessFromStatus(next);
  }
  if (current == PermissionStatus.permanentlyDenied) {
    return FeatureAccess.needsSettings;
  }
  return FeatureAccess.unavailable;
}
```

Если уже usable — **не** зови `request` снова.

## 4. Rationale и настройки

Перед системным диалогом покажи свой текст «зачем»:

```dart
// notifications -> 'Нужны, чтобы сообщать о новых событиях'
// camera -> 'Нужна, чтобы сделать фото профиля'
```

`needsSettings` → кнопка «Открыть настройки» → `openAppSettings()`. Не открывай настройки молча при каждом отказе.

## 5. Android 13 notifications

```dart
String? androidPermissionName(AppPermission p) =>
    p == AppPermission.notifications
        ? 'android.permission.POST_NOTIFICATIONS'
        : null;
```

В манифесте + runtime request. На старых Android поведение другое — проверяй API level в проде.

## 6. Тесты

`FakePermissionGateway` с заранее заданными статусами и `nextRequestResult` — без реальных диалогов.

## 7. Зачем это знать

- Статус решает UX-ветку: request / settings / unavailable.
- Just-in-time: permission у фичи, не у splash.
- `limited` ≠ отказ.
- Связь feature flag ↔ permission держи явной.

Дальше по маршруту: `permissions_task.dart` → `interview_questions.md`.
