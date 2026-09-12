/// ЗАДАЧА 20 — Platform Channels и нативная интеграция
/// Уровень: Senior Flutter
/// Тема: MethodChannel, EventChannel, Platform-specific code
///
/// Реализуйте интеграцию Flutter с нативным кодом:
///
/// 1. MethodChannel: получить информацию об устройстве
///    - Версия ОС
///    - Модель устройства
///    - Уровень заряда батареи
///
/// 2. EventChannel: подписка на обновления заряда батареи в реальном времени
///
/// 3. Правильная обработка ошибок PlatformException
///
/// Файлы нативного кода (для справки):
///   Android: android/app/src/main/kotlin/MainActivity.kt
///   iOS:     ios/Runner/AppDelegate.swift
///
/// Вопрос: когда использовать Platform Channels vs FFI vs написать плагин?
///
/// ПРИМЕЧАНИЕ: Данный файл содержит Flutter-сторону интеграции.
/// Для запуска нужен реальный нативный код в соответствующих файлах.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Сервис Platform Channels ─────────────────────────────────────────────────

class DeviceInfoService {
  static const _methodChannel = MethodChannel('com.example.app/device_info');
  static const _eventChannel = EventChannel('com.example.app/battery_stream');

  /// Получить информацию об устройстве
  Future<DeviceInfo> getDeviceInfo() async {
    try {
      final result = await _methodChannel.invokeMapMethod<String, dynamic>('getDeviceInfo');
      if (result == null) throw PlatformException(code: 'NULL_RESULT');
      return DeviceInfo.fromMap(result);
    } on PlatformException catch (e) {
      throw DeviceInfoException('Ошибка получения данных: ${e.message}');
    }
  }

  /// Получить уровень заряда батареи (одиночный вызов)
  Future<int> getBatteryLevel() async {
    try {
      final level = await _methodChannel.invokeMethod<int>('getBatteryLevel');
      return level ?? -1;
    } on PlatformException catch (e) {
      if (e.code == 'UNAVAILABLE') return -1;
      rethrow;
    }
  }

  /// Подписка на изменения заряда батареи в реальном времени
  Stream<int> get batteryLevelStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => event as int)
        .handleError((error) {
      if (error is PlatformException) {
        throw DeviceInfoException(error.message ?? 'Неизвестная ошибка');
      }
      throw error;
    });
  }
}

// ─── Модели ──────────────────────────────────────────────────────────────────

class DeviceInfo {
  final String osVersion;
  final String model;
  final String manufacturer;
  final bool isPhysicalDevice;

  const DeviceInfo({
    required this.osVersion,
    required this.model,
    required this.manufacturer,
    required this.isPhysicalDevice,
  });

  factory DeviceInfo.fromMap(Map<String, dynamic> map) => DeviceInfo(
        osVersion: map['osVersion'] as String? ?? 'Unknown',
        model: map['model'] as String? ?? 'Unknown',
        manufacturer: map['manufacturer'] as String? ?? 'Unknown',
        isPhysicalDevice: map['isPhysicalDevice'] as bool? ?? false,
      );
}

class DeviceInfoException implements Exception {
  final String message;
  const DeviceInfoException(this.message);
  @override
  String toString() => 'DeviceInfoException: $message';
}

// ─── UI ──────────────────────────────────────────────────────────────────────

class PlatformChannelPage extends StatefulWidget {
  const PlatformChannelPage({super.key});

  @override
  State<PlatformChannelPage> createState() => _PlatformChannelPageState();
}

class _PlatformChannelPageState extends State<PlatformChannelPage> {
  final _service = DeviceInfoService();
  DeviceInfo? _deviceInfo;
  int _batteryLevel = -1;
  String? _error;
  StreamSubscription<int>? _batterySub;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
    _subscribeToBattery();
  }

  @override
  void dispose() {
    _batterySub?.cancel();
    super.dispose();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final info = await _service.getDeviceInfo();
      if (mounted) setState(() => _deviceInfo = info);
    } on DeviceInfoException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  void _subscribeToBattery() {
    _batterySub = _service.batteryLevelStream.listen(
      (level) {
        if (mounted) setState(() => _batteryLevel = level);
      },
      onError: (e) {
        if (mounted) setState(() => _error = e.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Platform Channels')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              ),
            _InfoTile(
              icon: Icons.phone_android,
              label: 'Модель',
              value: _deviceInfo?.model ?? '...',
            ),
            _InfoTile(
              icon: Icons.business,
              label: 'Производитель',
              value: _deviceInfo?.manufacturer ?? '...',
            ),
            _InfoTile(
              icon: Icons.system_update,
              label: 'Версия ОС',
              value: _deviceInfo?.osVersion ?? '...',
            ),
            _InfoTile(
              icon: Icons.devices,
              label: 'Физическое устройство',
              value: _deviceInfo == null ? '...' : (_deviceInfo!.isPhysicalDevice ? 'Да' : 'Нет (эмулятор)'),
            ),
            const Divider(height: 32),
            Row(
              children: [
                Icon(
                  _batteryLevel > 20 ? Icons.battery_full : Icons.battery_alert,
                  color: _batteryLevel > 20 ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _batteryLevel == -1 ? 'Заряд: ...' : 'Заряд: $_batteryLevel%',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════
/// НАТИВНЫЙ КОД (для справки, не запускается в Dart)
/// ═══════════════════════════════════════════════════════════════════
///
/// Android (MainActivity.kt):
/// ```kotlin
/// class MainActivity: FlutterActivity() {
///   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
///     super.configureFlutterEngine(flutterEngine)
///
///     MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
///         "com.example.app/device_info").setMethodCallHandler { call, result ->
///       when (call.method) {
///         "getDeviceInfo" -> result.success(mapOf(
///           "osVersion" to Build.VERSION.RELEASE,
///           "model" to Build.MODEL,
///           "manufacturer" to Build.MANUFACTURER,
///           "isPhysicalDevice" to !isEmulator()
///         ))
///         "getBatteryLevel" -> {
///           val bm = getSystemService(BATTERY_SERVICE) as BatteryManager
///           result.success(bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY))
///         }
///         else -> result.notImplemented()
///       }
///     }
///   }
/// }
/// ```
///
/// iOS (AppDelegate.swift):
/// ```swift
/// FlutterMethodChannel(name: "com.example.app/device_info",
///     binaryMessenger: controller.binaryMessenger)
///   .setMethodCallHandler { call, result in
///     if call.method == "getDeviceInfo" {
///       result(["osVersion": UIDevice.current.systemVersion,
///               "model": UIDevice.current.model,
///               "manufacturer": "Apple",
///               "isPhysicalDevice": !ProcessInfo.processInfo.environment.keys.contains("SIMULATOR_DEVICE_NAME")])
///     } else { result(FlutterMethodNotImplemented) }
///   }
/// ```

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PlatformChannelPage(),
  ));
}
