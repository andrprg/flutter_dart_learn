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

## 7. Когда система больше не спрашивает

Первый `request` показывает системный диалог. Повторный `request`, пока статус `denied` и пользователь просто закрыл диалог, на Android часто можно показать снова. После «не спрашивать» / двух отказов статус становится `permanentlyDenied`: диалог не появится, `request` сразу вернёт отказ. Единственный ход — экран настроек приложения.

iOS отличается: отказ по многим разрешениям сразу «только настройки», отдельного permanentlyDenied плагин может отображать как `denied` или `permanentlyDenied` в зависимости от permission_handler и ОС. На ветки UX смотри статус, который вернул плагин, не заучивай одну таблицу на все версии.

`restricted` не лечится настройкой приложения: профиль устройства запретил камеру. Кнопка «открыть настройки» обещает невозможное. Показывай «недоступно на этом устройстве».

`limited` (фото) — пользователь выдал часть библиотеки. Фича работает. Отдельная кнопка «выбрать ещё фото» ведёт в системный пикер, а не в повторный request «дай всё».

Пока диалог на экране, приложение часто переходит в `inactive`. Не путай возврат из диалога с отказом. Жди результат `request`, не сигнал lifecycle.

## 8. Запрос в контексте и манифест

Разрешение в манифесте Android без runtime request на новых API не выдаётся. Runtime request без строки в манифесте не показывает диалог. Нужны оба.

Спрашивать в момент действия: нажали «снять аватар» — объяснение — системный диалог. Пачка из пяти диалогов на сплэше учит нажимать «запретить».

Своё объяснение (rationale) — до системного диалога, обычным экраном или диалогом приложения. После `permanentlyDenied` rationale уже не откроет системный диалог. Текст тогда про настройки: какой тумблер найти.

Проверка на возврате из настроек: `AppLifecycleState.resumed` → снова `status()`. Иначе на экране останется «доступ закрыт», хотя пользователь уже включил.

Один и тот же permission обслуживает разные фичи (`camera` для аватара и для сканера). Не показывай текст «для аватара», если сейчас открывают сканер. Текст привязан к действию, тип permission — к `permissionForFeature`.

## 9. Типичные ошибки

- Считать `granted` единственным успехом и отбрасывать `limited`.
- Вызывать `request`, когда уже `granted` — лишний диалог на части платформ и мигание.
- Открывать настройки на каждый `denied`, не дав системному диалогу случиться.
- Хранить «пользователь согласился» своим флагом в prefs и не спрашивать реальный статус. Тумблер в настройках ОС этот флаг не обновляет.
- Забыть `POST_NOTIFICATIONS` в манифесте и отлаживать «баннер не приходит» на Android 13.

## 10. Зачем это знать

- Статус решает UX-ветку: request / settings / unavailable.
- Just-in-time: permission у фичи, не у splash.
- `limited` ≠ отказ.
- Связь feature flag ↔ permission держи явной.

Дальше по маршруту: `permissions_task.dart` → `interview_questions.md`.
