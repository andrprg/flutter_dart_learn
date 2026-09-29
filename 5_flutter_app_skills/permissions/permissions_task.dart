// ============================================================
// 12 ЗАДАЧ ПО PERMISSIONS
// ============================================================
// Цель: понять статусы разрешений, запрос, rationale и
// маппинг feature -> permission без привязки к permission_handler.

/// Статус разрешения.
enum PermissionStatus {
  /// Ещё не спрашивали / можно запросить.
  denied,

  /// Пользователь выдал разрешение.
  granted,

  /// Навсегда отклонено (нужно открыть настройки).
  permanentlyDenied,

  /// Ограничено системой (например, parental controls).
  restricted,

  /// Только частичный доступ (фото на iOS 14+ и т.п.).
  limited,
}

/// Тип разрешения приложения.
enum AppPermission {
  notifications,
  camera,
  photos,
  location,
  microphone,
}

/// Результат проверки «можно ли пользоваться фичей».
enum FeatureAccess {
  allowed,
  needsRequest,
  needsSettings,
  unavailable,
}

/// Контракт сервиса разрешений.
abstract class PermissionGateway {
  Future<PermissionStatus> status(AppPermission permission);
  Future<PermissionStatus> request(AppPermission permission);
  Future<bool> openAppSettings();
}

/// In-memory gateway для обучения и тестов.
class FakePermissionGateway implements PermissionGateway {
  FakePermissionGateway([Map<AppPermission, PermissionStatus>? initial])
      : _statuses = {
          for (final p in AppPermission.values)
            p: PermissionStatus.denied,
          ...?initial,
        };

  final Map<AppPermission, PermissionStatus> _statuses;
  bool settingsOpened = false;

  /// Что вернёт следующий [request] (по умолчанию granted).
  PermissionStatus nextRequestResult = PermissionStatus.granted;

  @override
  Future<PermissionStatus> status(AppPermission permission) async {
    return _statuses[permission]!;
  }

  @override
  Future<PermissionStatus> request(AppPermission permission) async {
    _statuses[permission] = nextRequestResult;
    return nextRequestResult;
  }

  @override
  Future<bool> openAppSettings() async {
    settingsOpened = true;
    return true;
  }

  void setStatus(AppPermission permission, PermissionStatus status) {
    _statuses[permission] = status;
  }
}

// ЗАДАЧА 1
// Разрешение считается «успешным» для обычного UX: granted или limited.
bool isPermissionUsable(PermissionStatus status) {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// Можно ли показать системный диалог запроса?
// Только для denied (не для permanentlyDenied / restricted).
bool canRequestAgain(PermissionStatus status) {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// Нужно ли вести пользователя в настройки приложения?
bool shouldOpenSettings(PermissionStatus status) {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Сообщение rationale по типу разрешения (на русском):
// notifications -> 'Нужны, чтобы сообщать о новых событиях'
// camera -> 'Нужна, чтобы сделать фото профиля'
// photos -> 'Нужен доступ к галерее'
// location -> 'Нужна, чтобы показать объекты рядом'
// microphone -> 'Нужен для голосовых сообщений'
String rationaleFor(AppPermission permission) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Маппинг фичи приложения на разрешение.
// 'chat_voice' -> microphone
// 'avatar_camera' -> camera
// 'avatar_gallery' -> photos
// 'nearby_map' -> location
// 'push_inbox' -> notifications
// Иначе — ArgumentError.
AppPermission permissionForFeature(String feature) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Преобразуй статус в FeatureAccess:
// usable -> allowed
// can request -> needsRequest
// permanentlyDenied -> needsSettings
// restricted -> unavailable
FeatureAccess accessFromStatus(PermissionStatus status) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// ensureAccess:
// - если уже usable — верни allowed (не вызывай request)
// - если canRequestAgain — вызови request и верни accessFromStatus(результата)
// - если permanentlyDenied — верни needsSettings
// - если restricted — верни unavailable
Future<FeatureAccess> ensureAccess(
  PermissionGateway gateway,
  AppPermission permission,
) async {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Если access == needsSettings — открой настройки и верни true.
// Иначе верни false, настройки не открывай.
Future<bool> openSettingsIfNeeded(
  PermissionGateway gateway,
  FeatureAccess access,
) async {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Все ли permissions в списке usable?
Future<bool> areAllGranted(
  PermissionGateway gateway,
  List<AppPermission> permissions,
) async {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Верни список permissions, которые НЕ usable.
Future<List<AppPermission>> missingPermissions(
  PermissionGateway gateway,
  List<AppPermission> permissions,
) async {
  throw UnimplementedError();
}

// ЗАДАЧА 11
// Android 13+ POST_NOTIFICATIONS: permission name 'android.permission.POST_NOTIFICATIONS'.
// Для прочих AppPermission верни null (упрощённо).
String? androidPermissionName(AppPermission permission) {
  throw UnimplementedError();
}

// ЗАДАЧА 12
// Краткий статус для UI: 'granted' | 'denied' | 'blocked' | 'limited' | 'restricted'
// permanentlyDenied -> 'blocked'
String statusLabel(PermissionStatus status) {
  throw UnimplementedError();
}
