import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harbr/system/platform.dart';
import 'package:window_manager/window_manager.dart';

// ignore: always_use_package_imports
import '../window_manager.dart';

bool isPlatformSupported() => HarbrPlatform.isDesktop;
HarbrWindowManager getWindowManager() {
  switch (HarbrPlatform.current) {
    case HarbrPlatform.LINUX:
    case HarbrPlatform.MACOS:
    case HarbrPlatform.WINDOWS:
      return IO();
    default:
      throw UnsupportedError('HarbrWindowManager unsupported');
  }
}

class IO implements HarbrWindowManager {
  @override
  Future<void> initialize() async {
    if (kDebugMode) return;

    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await setWindowSize();
      await setWindowTitle('Harbr');
      windowManager.show();
    });
  }

  @override
  Future<void> setWindowTitle(String title) async {
    return windowManager
        .waitUntilReadyToShow()
        .then((_) async => await windowManager.setTitle(title));
  }

  Future<void> setWindowSize() async {
    const min = HarbrWindowManager.MINIMUM_WINDOW_SIZE;
    const init = HarbrWindowManager.INITIAL_WINDOW_SIZE;
    const minSize = Size(min, min);
    const initSize = Size(init, init);

    await windowManager.setSize(initSize);
    // Currently broken on Linux
    if (!HarbrPlatform.isLinux) {
      await windowManager.setMinimumSize(minSize);
    }
  }
}
