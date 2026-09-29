# Шпаргалка: Локальные уведомления

**Local** — приложение само планирует/показывает уведомление на устройстве. **Push** — сервер → FCM/APNs → устройство. Модуль про локальные: каналы Android, category/actions iOS, payload, permissions и сервис-обёртка без привязки к плагину.

Перед задачами прочитай этот файл, затем решай `notifications_task.dart`.

## 1. Android channel

С Android 8 каждое уведомление идёт в **channel**. Важность канала задаёт heads-up, звук, badge. Пользователь может заглушить канал в настройках системы.

```dart
AndroidChannelConfig createWebsocketChannel() => const AndroidChannelConfig(
  id: 'websocket_events',
  name: 'WebSocket events',
  description: 'Notifications received from WebSocket',
  importance: NotificationImportance.high,
);

bool isHeadsUpChannel(AndroidChannelConfig c) =>
    c.importance == NotificationImportance.high;
```

## 2. iOS category и actions

На iOS кнопки живут в **category**. Один и тот же `action.id` удобно держать кроссплатформенно:

```dart
NotificationAction createConfirmAction() =>
    const NotificationAction(id: 'confirm', title: 'Подтвердить');

String iosWebsocketCategoryId() => 'websocket_event';
```

## 3. Tap vs action + payload

```dart
NotificationInteractionType interactionTypeFrom(String? actionId) =>
    (actionId == null || actionId.isEmpty)
        ? NotificationInteractionType.tap
        : NotificationInteractionType.action;

// payload — строка «контекста», например:
String eventPayload(String eventId) => 'event:$eventId';
String? parseEventId(String? payload) {
  if (payload == null || !payload.startsWith('event:')) return null;
  return payload.substring('event:'.length);
}
```

Тап по телу → открыть экран по payload. Тап по кнопке → `onAction(actionId, payload)`. Не путай: `shouldHandleAction` только для `action`.

## 4. Сервис и валидация

```dart
void validateShowRequest(ShowNotificationRequest r) {
  if (r.title.isEmpty || r.body.isEmpty || r.id < 0) {
    throw ArgumentError('invalid notification request');
  }
}

// initialize() → isInitialized = true
// show() только после initialize
// handleResponse() зовёт onAction лишь для action-кнопок
```

Плагин (`flutter_local_notifications` и др.) инициализируй рано (до показа), с отдельно зарегистрированными callback для background.

## 5. Permissions

Android 13+ — `POST_NOTIFICATIONS`. iOS — alert / badge / sound. Запрашивай **перед** первым полезным уведомлением, с rationale.

```dart
List<String> requiredNotificationPermissions() =>
    ['alert', 'badge', 'sound'];
```

Foreground: на iOS/Android поведение отличается — иногда нужно явно разрешить показ баннера, когда приложение открыто.

## 6. Зачем это знать

- Local ≠ push; каналы Android обязательны.
- payload связывает уведомление с навигацией/данными.
- Tap и action — разные ветки обработчика.
- Без permission и initialize показа не будет.

Дальше по маршруту: `notifications_task.dart` → `interview_questions.md`.
