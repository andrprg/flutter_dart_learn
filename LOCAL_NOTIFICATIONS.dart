import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Колбэк при нажатии на кнопку действия в уведомлении.
///
/// [actionId] — идентификатор кнопки (например, [NotificationService.actionConfirm]).
/// [payload] — произвольная строка, которую передали при [NotificationService.show]
/// (здесь это `eventId` с сервера).
typedef NotificationActionHandler = Future<void> Function(
  String actionId,
  String? payload,
);

/// Обёртка над [FlutterLocalNotificationsPlugin].
///
/// Типичный жизненный цикл:
/// 1. Создать сервис и передать [onAction].
/// 2. Один раз вызвать [initialize] при старте приложения.
/// 3. Вызывать [show], когда пришло событие (например, по WebSocket).
/// 4. При нажатии «Подтвердить» плагин вызовет [_onNotificationResponse],
///    а тот — ваш [onAction].
class NotificationService {
  NotificationService({
    required this.onAction,
  });

  /// Что делать, когда пользователь нажал кнопку в уведомлении.
  final NotificationActionHandler onAction;

  /// Единственный экземпляр плагина на всё приложение.
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // --- Android: notification channel -----------------------------------------
  // С Android 8+ каждое уведомление обязано принадлежать каналу.
  // Пользователь может менять важность/звук канала в настройках системы.
  static const String channelId = 'websocket_events';
  static const String channelName = 'WebSocket events';
  static const String channelDescription =
      'Notifications received from WebSocket';

  // --- iOS: notification category --------------------------------------------
  // На iOS кнопки действий задаются через «категорию».
  // Уведомление ссылается на categoryId, и система показывает нужные кнопки.
  static const String categoryId = 'websocket_event';

  /// Id кнопки «Подтвердить» — одинаковый на Android и iOS,
  /// чтобы в [onAction] сравнивать одну и ту же строку.
  static const String actionConfirm = 'confirm';

  /// Настройка плагина: иконка, права, категории iOS, колбэк на тап/кнопку.
  ///
  /// Вызывать один раз (обычно в `main` после WidgetsFlutterBinding).
  Future<void> initialize() async {
    // Android: иконка в статус-баре.
    // '@mipmap/ic_launcher' — ресурс из android/app/src/main/res/mipmap-*/.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS/macOS: запрос разрешений + описание категорий с кнопками.
    const iosSettings = DarwinInitializationSettings(
      // Попросить разрешения уже при initialize (можно отключить и
      // запрашивать позже через _requestPermissions).
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          categoryId,
          actions: [
            // plain — обычная кнопка (не текстовый ввод).
            DarwinNotificationAction.plain(
              actionConfirm,
              'Подтвердить',
              options: {
                // foreground — открыть приложение при нажатии
                // (удобно, если onAction должен работать в UI-потоке).
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
        ),
      ],
      // Как показывать уведомление, когда приложение на переднем плане.
      defaultPresentAlert: true,
      defaultPresentSound: true,
      defaultPresentBadge: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
      // Вызывается при тапе по уведомлению или по кнопке действия,
      // пока приложение запущено (foreground / background, не terminated).
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Канал на Android нужно создать до первого show().
    await _createAndroidChannel();
    // На Android 13+ и iOS без разрешения уведомления не появятся.
    await _requestPermissions();
  }

  /// Создаёт канал уведомлений (только Android).
  ///
  /// На iOS каналов нет — метод просто выйдет, если реализация null.
  Future<void> _createAndroidChannel() async {
    // resolvePlatformSpecificImplementation даёт доступ к API конкретной ОС.
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) {
      return;
    }

    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      // high — звук + появление в status bar / heads-up.
      importance: Importance.high,
    );

    await android.createNotificationChannel(channel);
  }

  /// Запрос разрешений на показ уведомлений.
  Future<void> _requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Android 13+ (API 33): POST_NOTIFICATIONS. На старых версиях — no-op.
    await android?.requestNotificationsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Показать локальное уведомление.
  ///
  /// [id] — уникальный id: повторный show с тем же id обновит уведомление.
  /// [eventId] уходит в payload и вернётся в [onAction] при нажатии кнопки.
  Future<void> show({
    required int id,
    required String title,
    required String body,
    required String eventId,
  }) async {
    // Android: канал + кнопки действий задаются прямо в details.
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      // priority влияет на heads-up на старых Android (< 8).
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          actionConfirm,
          'Подтвердить',
        ),
      ],
    );

    // iOS: кнопки берутся из категории, зарегистрированной в initialize().
    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: categoryId,
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      presentBanner: true,
      presentList: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      // Произвольная строка ≤ ~1 KB; плагин вернёт её в NotificationResponse.
      payload: eventId,
    );
  }

  /// Реакция на взаимодействие с уведомлением.
  ///
  /// Срабатывает и при тапе по телу уведомления, и при нажатии кнопки.
  /// Здесь интересует только кнопка: если actionId пустой — это обычный тап,
  /// и колбэк не вызываем.
  Future<void> _onNotificationResponse(
    NotificationResponse response,
  ) async {
    final actionId = response.actionId;

    // Тап по самому уведомлению (не по кнопке) → actionId == null / ''.
    if (actionId == null || actionId.isEmpty) {
      return;
    }

    await onAction(
      actionId,
      response.payload,
    );
  }
}
