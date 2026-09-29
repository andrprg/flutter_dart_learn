// ============================================================
// 12 ЗАДАЧ ПО ЛОКАЛЬНЫМ УВЕДОМЛЕНИЯМ
// ============================================================
// Цель: понять каналы Android, категории iOS, payload, action buttons,
// permissions и жизненный цикл NotificationService без привязки к плагину.
//
// Практика: см. также LOCAL_NOTIFICATIONS.dart в корне репозитория.

/// Важность канала (упрощённый аналог Importance у Android).
enum NotificationImportance {
  low,
  defaultImportance,
  high,
}

/// Тип взаимодействия пользователя с уведомлением.
enum NotificationInteractionType {
  /// Тап по телу уведомления (не по кнопке).
  tap,

  /// Нажатие на action-кнопку.
  action,
}

/// Описание Android notification channel.
class AndroidChannelConfig {
  const AndroidChannelConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.importance,
  });

  final String id;
  final String name;
  final String description;
  final NotificationImportance importance;
}

/// Описание action-кнопки (одинаковый id для Android и iOS).
class NotificationAction {
  const NotificationAction({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}

/// Ответ плагина на взаимодействие пользователя.
class NotificationResponse {
  const NotificationResponse({
    required this.type,
    this.actionId,
    this.payload,
  });

  final NotificationInteractionType type;
  final String? actionId;
  final String? payload;
}

/// Данные для показа уведомления.
class ShowNotificationRequest {
  const ShowNotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.actions = const [],
  });

  final int id;
  final String title;
  final String body;
  final String? payload;
  final List<NotificationAction> actions;
}

typedef NotificationActionHandler = Future<void> Function(
  String actionId,
  String? payload,
);

// ЗАДАЧА 1
// Создай конфиг Android-канала для websocket-событий:
// id = 'websocket_events', name = 'WebSocket events',
// description = 'Notifications received from WebSocket',
// importance = high.
AndroidChannelConfig createWebsocketChannel() {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Верни true, если канал достаточно важен для heads-up (high).
bool isHeadsUpChannel(AndroidChannelConfig channel) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Создай action «Подтвердить» с id = 'confirm'.
NotificationAction createConfirmAction() {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Определи тип взаимодействия:
// - actionId null или пустой -> tap
// - иначе -> action
NotificationInteractionType interactionTypeFrom(String? actionId) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Собери NotificationResponse из actionId и payload.
NotificationResponse buildResponse({
  String? actionId,
  String? payload,
}) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Нужно ли вызывать onAction?
// Только для типа action (не для обычного тапа по телу).
bool shouldHandleAction(NotificationResponse response) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Валидация запроса на показ:
// - title и body не пустые
// - id >= 0
// Иначе бросай ArgumentError.
void validateShowRequest(ShowNotificationRequest request) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Сформируй payload для события: 'event:<eventId>'.
String eventPayload(String eventId) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Извлеки eventId из payload вида 'event:<id>'.
// Если формат неверный — верни null.
String? parseEventId(String? payload) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Сервис-обёртка (логика без реального плагина).
// - initialize() ставит isInitialized = true
// - show() добавляет запрос в shown, только после initialize
// - handleResponse() вызывает onAction только для action-кнопок
class NotificationService {
  NotificationService({required this.onAction});

  final NotificationActionHandler onAction;

  bool isInitialized = false;
  final List<ShowNotificationRequest> shown = [];

  Future<void> initialize() async {
    throw UnimplementedError();
  }

  Future<void> show(ShowNotificationRequest request) async {
    throw UnimplementedError();
  }

  Future<void> handleResponse(NotificationResponse response) async {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Верни список permission-ключей, которые нужно запросить:
// Android 13+ и iOS: alert, badge, sound.
List<String> requiredNotificationPermissions() {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// iOS category id для websocket-событий: 'websocket_event'.
String iosWebsocketCategoryId() {
  throw UnimplementedError();
}
