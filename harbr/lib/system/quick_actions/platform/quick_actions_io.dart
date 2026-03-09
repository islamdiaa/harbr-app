import 'package:harbr/database/tables/harbr.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/system/platform.dart';

// ignore: always_use_package_imports
import '../quick_actions.dart';

bool isPlatformSupported() => HarbrPlatform.isMobile;
HarbrQuickActions getQuickActions() {
  if (isPlatformSupported()) return IO();
  throw UnsupportedError('HarbrQuickActions unsupported');
}

class IO implements HarbrQuickActions {
  final QuickActions _quickActions = const QuickActions();

  @override
  Future<void> initialize() async {
    _quickActions.initialize(actionHandler);
    setActionItems();
  }

  @override
  void actionHandler(String action) {
    HarbrModule.fromKey(action)?.launch();
  }

  @override
  void setActionItems() {
    _quickActions.setShortcutItems(<ShortcutItem>[
      if (HarbrDatabase.QUICK_ACTIONS_TAUTULLI.read())
        HarbrModule.TAUTULLI.shortcutItem,
      if (HarbrDatabase.QUICK_ACTIONS_SONARR.read())
        HarbrModule.SONARR.shortcutItem,
      if (HarbrDatabase.QUICK_ACTIONS_SEARCH.read())
        HarbrModule.SEARCH.shortcutItem,
      if (HarbrDatabase.QUICK_ACTIONS_SABNZBD.read())
        HarbrModule.SABNZBD.shortcutItem,
      if (HarbrDatabase.QUICK_ACTIONS_RADARR.read())
        HarbrModule.RADARR.shortcutItem,
      if (HarbrDatabase.QUICK_ACTIONS_OVERSEERR.read())
        HarbrModule.OVERSEERR.shortcutItem,
      if (HarbrDatabase.QUICK_ACTIONS_NZBGET.read())
        HarbrModule.NZBGET.shortcutItem,
      if (HarbrDatabase.QUICK_ACTIONS_LIDARR.read())
        HarbrModule.LIDARR.shortcutItem,
      HarbrModule.SETTINGS.shortcutItem,
    ]);
  }
}
