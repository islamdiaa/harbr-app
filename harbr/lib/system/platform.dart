import 'package:flutter/foundation.dart';

enum HarbrPlatform {
  ANDROID,
  IOS,
  LINUX,
  MACOS,
  WEB,
  WINDOWS;

  static bool get isAndroid {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  static bool get isIOS {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool get isLinux {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;
  }

  static bool get isMacOS {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  }

  static bool get isWeb {
    return kIsWeb;
  }

  static bool get isWindows {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  }

  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktop => isLinux || isMacOS || isWindows;

  static HarbrPlatform get current {
    if (isWeb) return HarbrPlatform.WEB;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return HarbrPlatform.ANDROID;
      case TargetPlatform.iOS:
        return HarbrPlatform.IOS;
      case TargetPlatform.linux:
        return HarbrPlatform.LINUX;
      case TargetPlatform.macOS:
        return HarbrPlatform.MACOS;
      case TargetPlatform.windows:
        return HarbrPlatform.WINDOWS;
      default:
        throw UnsupportedError('Platform is not supported');
    }
  }

  String get name {
    switch (this) {
      case HarbrPlatform.ANDROID:
        return 'Android';
      case HarbrPlatform.IOS:
        return 'iOS';
      case HarbrPlatform.LINUX:
        return 'Linux';
      case HarbrPlatform.MACOS:
        return 'macOS';
      case HarbrPlatform.WEB:
        return 'Web';
      case HarbrPlatform.WINDOWS:
        return 'Windows';
    }
  }
}
