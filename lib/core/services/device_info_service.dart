import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static Future<Map<String, String>> getDeviceInfoAsJson() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo android = await deviceInfoPlugin.androidInfo;
      return {
        'os_type': 'Android',
        'brand': android.brand,
        'model': android.model,
        'os_version': android.version.release,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
      final identifier = ios.utsname.machine;
      final model = getiOSModelName(identifier);

      return {
        'os_type': 'iOS',
        'brand': 'Apple',
        'model': model,
        'os_version': ios.systemVersion,
      };
    }

    return {
      'os_type': 'Unknown',
      'brand': 'Unknown',
      'model': 'Unknown',
      'os_version': 'Unknown',
    };
  }

  static String getiOSModelName(String identifier) {
    const modelMap = {
      // iPod
      'iPod5,1': 'iPod touch (5th generation)',
      'iPod7,1': 'iPod touch (6th generation)',
      'iPod9,1': 'iPod touch (7th generation)',

      // iPhone
      'iPhone3,1': 'iPhone 4',
      'iPhone3,2': 'iPhone 4',
      'iPhone3,3': 'iPhone 4',
      'iPhone4,1': 'iPhone 4s',
      'iPhone5,1': 'iPhone 5',
      'iPhone5,2': 'iPhone 5',
      'iPhone5,3': 'iPhone 5c',
      'iPhone5,4': 'iPhone 5c',
      'iPhone6,1': 'iPhone 5s',
      'iPhone6,2': 'iPhone 5s',
      'iPhone7,2': 'iPhone 6',
      'iPhone7,1': 'iPhone 6 Plus',
      'iPhone8,1': 'iPhone 6s',
      'iPhone8,2': 'iPhone 6s Plus',
      'iPhone9,1': 'iPhone 7',
      'iPhone9,3': 'iPhone 7',
      'iPhone9,2': 'iPhone 7 Plus',
      'iPhone9,4': 'iPhone 7 Plus',
      'iPhone10,1': 'iPhone 8',
      'iPhone10,4': 'iPhone 8',
      'iPhone10,2': 'iPhone 8 Plus',
      'iPhone10,5': 'iPhone 8 Plus',
      'iPhone10,3': 'iPhone X',
      'iPhone10,6': 'iPhone X',
      'iPhone11,2': 'iPhone XS',
      'iPhone11,4': 'iPhone XS Max',
      'iPhone11,6': 'iPhone XS Max',
      'iPhone11,8': 'iPhone XR',
      'iPhone12,1': 'iPhone 11',
      'iPhone12,3': 'iPhone 11 Pro',
      'iPhone12,5': 'iPhone 11 Pro Max',
      'iPhone13,1': 'iPhone 12 mini',
      'iPhone13,2': 'iPhone 12',
      'iPhone13,3': 'iPhone 12 Pro',
      'iPhone13,4': 'iPhone 12 Pro Max',
      'iPhone14,4': 'iPhone 13 mini',
      'iPhone14,5': 'iPhone 13',
      'iPhone14,2': 'iPhone 13 Pro',
      'iPhone14,3': 'iPhone 13 Pro Max',
      'iPhone14,7': 'iPhone 14',
      'iPhone14,8': 'iPhone 14 Plus',
      'iPhone15,2': 'iPhone 14 Pro',
      'iPhone15,3': 'iPhone 14 Pro Max',
      'iPhone15,4': 'iPhone 15',
      'iPhone15,5': 'iPhone 15 Plus',
      'iPhone16,1': 'iPhone 15 Pro',
      'iPhone16,2': 'iPhone 15 Pro Max',
      'iPhone17,1': 'iPhone 16 Pro',
      'iPhone17,2': 'iPhone 16 Pro Max',
      'iPhone17,3': 'iPhone 16',
      'iPhone17,4': 'iPhone 16 Plus',
      'iPhone17,5': 'iPhone 16e',
      'iPhone8,4': 'iPhone SE',
      'iPhone12,8': 'iPhone SE (2nd generation)',
      'iPhone14,6': 'iPhone SE (3rd generation)',

      // iPad
      'iPad2,1': 'iPad 2',
      'iPad3,1': 'iPad (3rd generation)',
      'iPad3,4': 'iPad (4th generation)',
      'iPad6,11': 'iPad (5th generation)',
      'iPad7,5': 'iPad (6th generation)',
      'iPad7,11': 'iPad (7th generation)',
      'iPad11,6': 'iPad (8th generation)',
      'iPad12,1': 'iPad (9th generation)',
      'iPad13,18': 'iPad (10th generation)',
      'iPad15,7': 'iPad (11th generation)',

      // iPad Air
      'iPad4,1': 'iPad Air',
      'iPad5,3': 'iPad Air 2',
      'iPad11,3': 'iPad Air (3rd generation)',
      'iPad13,1': 'iPad Air (4th generation)',
      'iPad13,16': 'iPad Air (5th generation)',
      'iPad14,8': 'iPad Air (11 inch) (M2)',
      'iPad14,10': 'iPad Air (13 inch) (M2)',
      'iPad15,3': 'iPad Air (11 inch) (M3)',
      'iPad15,5': 'iPad Air (13 inch) (M3)',

      // iPad mini
      'iPad2,5': 'iPad mini',
      'iPad4,4': 'iPad mini 2',
      'iPad4,7': 'iPad mini 3',
      'iPad5,1': 'iPad mini 4',
      'iPad11,1': 'iPad mini (5th generation)',
      'iPad14,1': 'iPad mini (6th generation)',
      'iPad16,1': 'iPad mini (A17 Pro)',

      // iPad Pro (11-inch)
      'iPad8,1': 'iPad Pro (11 inch) (1st generation)',
      'iPad8,9': 'iPad Pro (11 inch) (2nd generation)',
      'iPad13,4': 'iPad Pro (11 inch) (3rd generation)',
      'iPad14,3': 'iPad Pro (11 inch) (4th generation)',
      'iPad16,3': 'iPad Pro (11 inch) (M4)',

      // iPad Pro (12.9-inch)
      'iPad6,7': 'iPad Pro (12.9 inch) (1st generation)',
      'iPad7,1': 'iPad Pro (12.9 inch) (2nd generation)',
      'iPad8,5': 'iPad Pro (12.9 inch) (3rd generation)',
      'iPad8,11': 'iPad Pro (12.9 inch) (4th generation)',
      'iPad13,8': 'iPad Pro (12.9 inch) (5th generation)',
      'iPad14,5': 'iPad Pro (12.9 inch) (6th generation)',
      'iPad16,5': 'iPad Pro (13 inch) (M4)',

      // Simulator fallback
      'i386': 'iOS Simulator',
      'x86_64': 'iOS Simulator',
      'arm64': 'iOS Simulator',
    };

    return modelMap[identifier]?.replaceAll('‑', ' ') ?? identifier;
  }
}
