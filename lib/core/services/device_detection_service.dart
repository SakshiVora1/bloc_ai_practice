import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

enum DeviceType { iPhone, iPad, androidMobile, androidTablet, unknown }

class DeviceDetectionService {
  DeviceDetectionService._();

  static final DeviceDetectionService instance = DeviceDetectionService._();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceType _deviceType = DeviceType.unknown;
  bool _isInitialized = false;

  DeviceType get deviceType => _deviceType;

  bool get isPhone =>
      _deviceType == DeviceType.iPhone ||
      _deviceType == DeviceType.androidMobile;
  bool get isTablet =>
      _deviceType == DeviceType.iPad || _deviceType == DeviceType.androidTablet;
  bool get isIOS =>
      _deviceType == DeviceType.iPhone || _deviceType == DeviceType.iPad;
  bool get isAndroid =>
      _deviceType == DeviceType.androidMobile ||
      _deviceType == DeviceType.androidTablet;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        _deviceType = _detectIOSDeviceType(iosInfo);
      } else if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo =
            await _deviceInfoPlugin.androidInfo;
        _deviceType = _detectAndroidDeviceType(androidInfo);
      } else {
        _deviceType = DeviceType.unknown;
      }
    } catch (_) {
      _deviceType = DeviceType.unknown;
    } finally {
      _isInitialized = true;
    }
  }

  DeviceType _detectIOSDeviceType(IosDeviceInfo iosInfo) {
    final String machine = iosInfo.utsname.machine.toLowerCase();
    final String model = iosInfo.model.toLowerCase();
    final String name = iosInfo.name.toLowerCase();

    if (machine.startsWith('ipad') ||
        model.contains('ipad') ||
        name.contains('ipad')) {
      return DeviceType.iPad;
    }

    return DeviceType.iPhone;
  }

  DeviceType _detectAndroidDeviceType(AndroidDeviceInfo androidInfo) {
    final String model = androidInfo.model.toLowerCase();
    final String device = androidInfo.device.toLowerCase();
    final String product = androidInfo.product.toLowerCase();
    final List<String> features = androidInfo.systemFeatures
        .map((e) => e.toLowerCase())
        .toList();

    final bool hasTelephony = features.contains('android.hardware.telephony');
    final bool tabletLikeName =
        model.contains('tablet') ||
        model.contains('pad') ||
        device.contains('tablet') ||
        product.contains('tablet');

    if (!hasTelephony || tabletLikeName) {
      return DeviceType.androidTablet;
    }

    return DeviceType.androidMobile;
  }
}
