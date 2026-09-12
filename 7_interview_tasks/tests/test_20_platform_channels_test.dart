import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Реализация (упрощённая версия из task_20_platform_channels.dart) ─────────

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

  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}

class DeviceInfoException implements Exception {
  final String message;
  const DeviceInfoException(this.message);
  @override
  String toString() => 'DeviceInfoException: $message';
}

class DeviceInfoService {
  static const _channel = MethodChannel('com.example.app/device_info');

  Future<DeviceInfo> getDeviceInfo() async {
    throw UnimplementedError();
  }

  Future<int> getBatteryLevel() async {
    throw UnimplementedError();
  }
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Задача 20 — Platform Channels', () {
    const channel = MethodChannel('com.example.app/device_info');
    late DeviceInfoService service;

    setUp(() {
      service = DeviceInfoService();
    });

    tearDown(() {
      // Очищаем mock handler после каждого теста
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    void _setMockHandler(Future<dynamic> Function(MethodCall) handler) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, handler);
    }

    group('getDeviceInfo()', () {
      test('Возвращает DeviceInfo при успешном ответе', () async {
        _setMockHandler((_) async => {
              'osVersion': '14.0',
              'model': 'iPhone 15',
              'manufacturer': 'Apple',
              'isPhysicalDevice': true,
            });

        final info = await service.getDeviceInfo();
        expect(info.osVersion, equals('14.0'));
        expect(info.model, equals('iPhone 15'));
        expect(info.manufacturer, equals('Apple'));
        expect(info.isPhysicalDevice, isTrue);
      });

      test('Использует "Unknown" для отсутствующих полей', () async {
        _setMockHandler((_) async => <String, dynamic>{});
        final info = await service.getDeviceInfo();
        expect(info.osVersion, equals('Unknown'));
        expect(info.model, equals('Unknown'));
        expect(info.manufacturer, equals('Unknown'));
      });

      test('Выбрасывает DeviceInfoException при PlatformException', () async {
        _setMockHandler((_) async => throw PlatformException(
              code: 'ERROR',
              message: 'Нативная ошибка',
            ));

        await expectLater(
          () => service.getDeviceInfo(),
          throwsA(isA<DeviceInfoException>()),
        );
      });

      test('DeviceInfoException содержит описание ошибки', () async {
        _setMockHandler((_) async => throw PlatformException(
              code: 'ERR',
              message: 'тест ошибки',
            ));

        try {
          await service.getDeviceInfo();
          fail('Должно было выброситься исключение');
        } on DeviceInfoException catch (e) {
          expect(e.message, contains('тест ошибки'));
        }
      });
    });

    group('getBatteryLevel()', () {
      test('Возвращает уровень заряда', () async {
        _setMockHandler((_) async => 85);
        expect(await service.getBatteryLevel(), equals(85));
      });

      test('Возвращает -1 при PlatformException UNAVAILABLE', () async {
        _setMockHandler((_) async => throw PlatformException(
              code: 'UNAVAILABLE',
              message: 'Нет данных',
            ));
        expect(await service.getBatteryLevel(), equals(-1));
      });

      test('Возвращает -1 при null ответе', () async {
        _setMockHandler((_) async => null);
        expect(await service.getBatteryLevel(), equals(-1));
      });

      test('Пробрасывает другие PlatformException', () async {
        _setMockHandler((_) async => throw PlatformException(
              code: 'FATAL',
              message: 'Критическая ошибка',
            ));
        await expectLater(
          () => service.getBatteryLevel(),
          throwsA(isA<PlatformException>()),
        );
      });
    });

    group('DeviceInfo.fromMap()', () {
      test('Парсит все поля корректно', () {
        final info = DeviceInfo.fromMap({
          'osVersion': 'Android 13',
          'model': 'Pixel 7',
          'manufacturer': 'Google',
          'isPhysicalDevice': true,
        });
        expect(info.osVersion, equals('Android 13'));
        expect(info.model, equals('Pixel 7'));
        expect(info.manufacturer, equals('Google'));
        expect(info.isPhysicalDevice, isTrue);
      });

      test('Эмулятор: isPhysicalDevice = false', () {
        final info = DeviceInfo.fromMap({
          'osVersion': '14',
          'model': 'Simulator',
          'manufacturer': 'Apple',
          'isPhysicalDevice': false,
        });
        expect(info.isPhysicalDevice, isFalse);
      });

      test('Пустая Map → все поля "Unknown" / false', () {
        final info = DeviceInfo.fromMap({});
        expect(info.osVersion, equals('Unknown'));
        expect(info.model, equals('Unknown'));
        expect(info.manufacturer, equals('Unknown'));
        expect(info.isPhysicalDevice, isFalse);
      });
    });

    group('DeviceInfoException', () {
      test('Реализует Exception', () {
        expect(
          const DeviceInfoException('test'),
          isA<Exception>(),
        );
      });

      test('toString содержит сообщение', () {
        expect(
          const DeviceInfoException('мой текст').toString(),
          contains('мой текст'),
        );
      });
    });
  });
}
