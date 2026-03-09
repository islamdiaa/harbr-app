import 'package:flutter/material.dart';

import 'package:quick_actions/quick_actions.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes.dart';
import 'package:harbr/router/routes/settings.dart';
import 'package:harbr/modules/search.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/modules/sabnzbd.dart';
import 'package:harbr/modules/nzbget.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/modules/dashboard/core/state.dart';
import 'package:harbr/api/wake_on_lan/wake_on_lan.dart';

part 'modules.g.dart';

const MODULE_DASHBOARD_KEY = 'dashboard';
const MODULE_EXTERNAL_MODULES_KEY = 'external_modules';
const MODULE_LIDARR_KEY = 'lidarr';
const MODULE_NZBGET_KEY = 'nzbget';
const MODULE_OVERSEERR_KEY = 'overseerr';
const MODULE_RADARR_KEY = 'radarr';
const MODULE_SABNZBD_KEY = 'sabnzbd';
const MODULE_SEARCH_KEY = 'search';
const MODULE_SETTINGS_KEY = 'settings';
const MODULE_SONARR_KEY = 'sonarr';
const MODULE_TAUTULLI_KEY = 'tautulli';
const MODULE_READARR_KEY = 'readarr';
const MODULE_WAKE_ON_LAN_KEY = 'wake_on_lan';

@HiveType(typeId: 25, adapterName: 'HarbrModuleAdapter')
enum HarbrModule {
  @HiveField(0)
  DASHBOARD(MODULE_DASHBOARD_KEY),
  @HiveField(11)
  EXTERNAL_MODULES(MODULE_EXTERNAL_MODULES_KEY),
  @HiveField(1)
  LIDARR(MODULE_LIDARR_KEY),
  @HiveField(2)
  NZBGET(MODULE_NZBGET_KEY),
  @HiveField(3)
  OVERSEERR(MODULE_OVERSEERR_KEY),
  @HiveField(4)
  RADARR(MODULE_RADARR_KEY),
  @HiveField(5)
  SABNZBD(MODULE_SABNZBD_KEY),
  @HiveField(6)
  SEARCH(MODULE_SEARCH_KEY),
  @HiveField(7)
  SETTINGS(MODULE_SETTINGS_KEY),
  @HiveField(8)
  SONARR(MODULE_SONARR_KEY),
  @HiveField(9)
  TAUTULLI(MODULE_TAUTULLI_KEY),
  @HiveField(10)
  WAKE_ON_LAN(MODULE_WAKE_ON_LAN_KEY),
  @HiveField(12)
  READARR(MODULE_READARR_KEY);

  final String key;
  const HarbrModule(this.key);

  static HarbrModule? fromKey(String? key) {
    switch (key) {
      case MODULE_DASHBOARD_KEY:
        return HarbrModule.DASHBOARD;
      case MODULE_LIDARR_KEY:
        return HarbrModule.LIDARR;
      case MODULE_NZBGET_KEY:
        return HarbrModule.NZBGET;
      case MODULE_RADARR_KEY:
        return HarbrModule.RADARR;
      case MODULE_SABNZBD_KEY:
        return HarbrModule.SABNZBD;
      case MODULE_SEARCH_KEY:
        return HarbrModule.SEARCH;
      case MODULE_SETTINGS_KEY:
        return HarbrModule.SETTINGS;
      case MODULE_SONARR_KEY:
        return HarbrModule.SONARR;
      case MODULE_OVERSEERR_KEY:
        return HarbrModule.OVERSEERR;
      case MODULE_TAUTULLI_KEY:
        return HarbrModule.TAUTULLI;
      case MODULE_WAKE_ON_LAN_KEY:
        return HarbrModule.WAKE_ON_LAN;
      case MODULE_EXTERNAL_MODULES_KEY:
        return HarbrModule.EXTERNAL_MODULES;
      case MODULE_READARR_KEY:
        return HarbrModule.READARR;
    }
    return null;
  }

  static List<HarbrModule> get active {
    return HarbrModule.values.filter((m) {
      if (m == HarbrModule.DASHBOARD) return false;
      if (m == HarbrModule.SETTINGS) return false;
      return m.featureFlag;
    }).toList();
  }
}

extension HarbrModuleEnablementExtension on HarbrModule {
  bool get featureFlag {
    switch (this) {
      case HarbrModule.OVERSEERR:
        return false;
      case HarbrModule.WAKE_ON_LAN:
        return HarbrWakeOnLAN.isSupported;
      default:
        return true;
    }
  }

  bool get isEnabled {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return true;
      case HarbrModule.SETTINGS:
        return true;
      case HarbrModule.LIDARR:
        return HarbrProfile.current.lidarrEnabled;
      case HarbrModule.NZBGET:
        return HarbrProfile.current.nzbgetEnabled;
      case HarbrModule.OVERSEERR:
        return HarbrProfile.current.overseerrEnabled;
      case HarbrModule.RADARR:
        return HarbrProfile.current.radarrEnabled;
      case HarbrModule.SABNZBD:
        return HarbrProfile.current.sabnzbdEnabled;
      case HarbrModule.SEARCH:
        return !HarbrBox.indexers.isEmpty;
      case HarbrModule.SONARR:
        return HarbrProfile.current.sonarrEnabled;
      case HarbrModule.TAUTULLI:
        return HarbrProfile.current.tautulliEnabled;
      case HarbrModule.WAKE_ON_LAN:
        return HarbrProfile.current.wakeOnLANEnabled;
      case HarbrModule.EXTERNAL_MODULES:
        return !HarbrBox.externalModules.isEmpty;
      case HarbrModule.READARR:
        return HarbrProfile.current.readarrEnabled;
    }
  }
}

extension HarbrModuleMetadataExtension on HarbrModule {
  String get title {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return 'harbr.Dashboard'.tr();
      case HarbrModule.LIDARR:
        return 'Lidarr';
      case HarbrModule.NZBGET:
        return 'NZBGet';
      case HarbrModule.RADARR:
        return 'Radarr';
      case HarbrModule.SABNZBD:
        return 'SABnzbd';
      case HarbrModule.SEARCH:
        return 'search.Search'.tr();
      case HarbrModule.SETTINGS:
        return 'harbr.Settings'.tr();
      case HarbrModule.SONARR:
        return 'Sonarr';
      case HarbrModule.TAUTULLI:
        return 'Tautulli';
      case HarbrModule.OVERSEERR:
        return 'Overseerr';
      case HarbrModule.WAKE_ON_LAN:
        return 'Wake on LAN';
      case HarbrModule.EXTERNAL_MODULES:
        return 'harbr.ExternalModules'.tr();
      case HarbrModule.READARR:
        return 'Readarr';
    }
  }

  IconData get icon {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return Icons.home_rounded;
      case HarbrModule.LIDARR:
        return HarbrIcons.LIDARR;
      case HarbrModule.NZBGET:
        return HarbrIcons.NZBGET;
      case HarbrModule.RADARR:
        return HarbrIcons.RADARR;
      case HarbrModule.SABNZBD:
        return HarbrIcons.SABNZBD;
      case HarbrModule.SEARCH:
        return Icons.search_rounded;
      case HarbrModule.SETTINGS:
        return Icons.settings_rounded;
      case HarbrModule.SONARR:
        return HarbrIcons.SONARR;
      case HarbrModule.TAUTULLI:
        return HarbrIcons.TAUTULLI;
      case HarbrModule.OVERSEERR:
        return HarbrIcons.OVERSEERR;
      case HarbrModule.WAKE_ON_LAN:
        return Icons.settings_remote_rounded;
      case HarbrModule.EXTERNAL_MODULES:
        return Icons.settings_ethernet_rounded;
      case HarbrModule.READARR:
        return Icons.book_rounded;
    }
  }

  Color get color {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return HarbrColours.accent;
      case HarbrModule.LIDARR:
        return const Color(0xFF159552);
      case HarbrModule.NZBGET:
        return const Color(0xFF42D535);
      case HarbrModule.RADARR:
        return const Color(0xFFFEC333);
      case HarbrModule.SABNZBD:
        return const Color(0xFFFECC2B);
      case HarbrModule.SEARCH:
        return HarbrColours.accent;
      case HarbrModule.SETTINGS:
        return HarbrColours.accent;
      case HarbrModule.SONARR:
        return const Color(0xFF3FC6F4);
      case HarbrModule.TAUTULLI:
        return const Color(0xFFDBA23A);
      case HarbrModule.OVERSEERR:
        return const Color(0xFF6366F1);
      case HarbrModule.WAKE_ON_LAN:
        return HarbrColours.accent;
      case HarbrModule.EXTERNAL_MODULES:
        return HarbrColours.accent;
      case HarbrModule.READARR:
        return const Color(0xFF7B68EE);
    }
  }

  String? get website {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return null;
      case HarbrModule.LIDARR:
        return 'https://lidarr.audio';
      case HarbrModule.NZBGET:
        return 'https://nzbget.net';
      case HarbrModule.RADARR:
        return 'https://radarr.video';
      case HarbrModule.SABNZBD:
        return 'https://sabnzbd.org';
      case HarbrModule.SEARCH:
        return null;
      case HarbrModule.SETTINGS:
        return null;
      case HarbrModule.SONARR:
        return 'https://sonarr.tv';
      case HarbrModule.TAUTULLI:
        return 'https://tautulli.com';
      case HarbrModule.OVERSEERR:
        return 'https://overseerr.dev';
      case HarbrModule.WAKE_ON_LAN:
        return null;
      case HarbrModule.EXTERNAL_MODULES:
        return null;
      case HarbrModule.READARR:
        return 'https://readarr.com';
    }
  }

  String? get github {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return null;
      case HarbrModule.LIDARR:
        return 'https://github.com/Lidarr/Lidarr';
      case HarbrModule.NZBGET:
        return 'https://github.com/nzbget/nzbget';
      case HarbrModule.RADARR:
        return 'https://github.com/Radarr/Radarr';
      case HarbrModule.SABNZBD:
        return 'https://github.com/sabnzbd/sabnzbd';
      case HarbrModule.SEARCH:
        return 'https://github.com/theotherp/nzbhydra2';
      case HarbrModule.SETTINGS:
        return null;
      case HarbrModule.SONARR:
        return 'https://github.com/Sonarr/Sonarr';
      case HarbrModule.TAUTULLI:
        return 'https://github.com/Tautulli/Tautulli';
      case HarbrModule.OVERSEERR:
        return 'https://github.com/sct/overseerr';
      case HarbrModule.WAKE_ON_LAN:
        return null;
      case HarbrModule.EXTERNAL_MODULES:
        return null;
      case HarbrModule.READARR:
        return 'https://github.com/Readarr/Readarr';
    }
  }

  String get description {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return 'harbr.Dashboard'.tr();
      case HarbrModule.LIDARR:
        return 'Manage Music';
      case HarbrModule.NZBGET:
        return 'Manage Usenet Downloads';
      case HarbrModule.RADARR:
        return 'Manage Movies';
      case HarbrModule.SABNZBD:
        return 'Manage Usenet Downloads';
      case HarbrModule.SEARCH:
        return 'Search Newznab Indexers';
      case HarbrModule.SETTINGS:
        return 'Configure Harbr';
      case HarbrModule.SONARR:
        return 'Manage Television Series';
      case HarbrModule.TAUTULLI:
        return 'View Plex Activity';
      case HarbrModule.OVERSEERR:
        return 'Manage Requests for New Content';
      case HarbrModule.WAKE_ON_LAN:
        return 'Wake Your Machine';
      case HarbrModule.EXTERNAL_MODULES:
        return 'Access External Modules';
      case HarbrModule.READARR:
        return 'Manage your book collection';
    }
  }

  String? get information {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return null;
      case HarbrModule.LIDARR:
        return 'Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.';
      case HarbrModule.NZBGET:
        return 'NZBGet is a binary downloader, which downloads files from Usenet based on information given in nzb-files.';
      case HarbrModule.RADARR:
        return 'Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.';
      case HarbrModule.SABNZBD:
        return 'SABnzbd is a multi-platform binary newsgroup downloader. The program works in the background and simplifies the downloading verifying and extracting of files from Usenet.';
      case HarbrModule.SEARCH:
        return 'Harbr currently supports all indexers that support the newznab protocol, including NZBHydra2.';
      case HarbrModule.SETTINGS:
        return null;
      case HarbrModule.SONARR:
        return 'Sonarr is a PVR for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.';
      case HarbrModule.TAUTULLI:
        return 'Tautulli is an application that you can run alongside your Plex Media Server to monitor activity and track various statistics. Most importantly, these statistics include what has been watched, who watched it, when and where they watched it, and how it was watched.';
      case HarbrModule.OVERSEERR:
        return 'Overseerr is a free and open source software application for managing requests for your media library. It integrates with your existing services, such as Sonarr, Radarr, and Plex!';
      case HarbrModule.WAKE_ON_LAN:
        return 'Wake on LAN is an industry standard protocol for waking computers up from a very low power mode remotely by sending a specially constructed packet to the machine.';
      case HarbrModule.EXTERNAL_MODULES:
        return 'Harbr allows you to add links to additional modules that are not currently supported allowing you to open the module\'s web GUI without having to leave Harbr!';
      case HarbrModule.READARR:
        return 'Readarr is a book collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new books and will interface with clients and indexers to grab, sort, and rename them.';
    }
  }
}

extension HarbrModuleRoutingExtension on HarbrModule {
  String? get homeRoute {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return HarbrRoutes.dashboard.root.path;
      case HarbrModule.LIDARR:
        return HarbrRoutes.lidarr.root.path;
      case HarbrModule.NZBGET:
        return HarbrRoutes.nzbget.root.path;
      case HarbrModule.RADARR:
        return HarbrRoutes.radarr.root.path;
      case HarbrModule.SABNZBD:
        return HarbrRoutes.sabnzbd.root.path;
      case HarbrModule.SEARCH:
        return HarbrRoutes.search.root.path;
      case HarbrModule.SETTINGS:
        return HarbrRoutes.settings.root.path;
      case HarbrModule.SONARR:
        return HarbrRoutes.sonarr.root.path;
      case HarbrModule.TAUTULLI:
        return HarbrRoutes.tautulli.root.path;
      case HarbrModule.OVERSEERR:
        return null;
      case HarbrModule.WAKE_ON_LAN:
        return null;
      case HarbrModule.EXTERNAL_MODULES:
        return HarbrRoutes.externalModules.root.path;
      case HarbrModule.READARR:
        return HarbrRoutes.readarr.root.path;
    }
  }

  SettingsRoutes? get settingsRoute {
    switch (this) {
      case HarbrModule.DASHBOARD:
        return SettingsRoutes.CONFIGURATION_DASHBOARD;
      case HarbrModule.LIDARR:
        return SettingsRoutes.CONFIGURATION_LIDARR;
      case HarbrModule.NZBGET:
        return SettingsRoutes.CONFIGURATION_NZBGET;
      case HarbrModule.OVERSEERR:
        return null;
      case HarbrModule.RADARR:
        return SettingsRoutes.CONFIGURATION_RADARR;
      case HarbrModule.SABNZBD:
        return SettingsRoutes.CONFIGURATION_SABNZBD;
      case HarbrModule.SEARCH:
        return SettingsRoutes.CONFIGURATION_SEARCH;
      case HarbrModule.SETTINGS:
        return null;
      case HarbrModule.SONARR:
        return SettingsRoutes.CONFIGURATION_SONARR;
      case HarbrModule.TAUTULLI:
        return SettingsRoutes.CONFIGURATION_TAUTULLI;
      case HarbrModule.WAKE_ON_LAN:
        return SettingsRoutes.CONFIGURATION_WAKE_ON_LAN;
      case HarbrModule.EXTERNAL_MODULES:
        return SettingsRoutes.CONFIGURATION_EXTERNAL_MODULES;
      case HarbrModule.READARR:
        return SettingsRoutes.CONFIGURATION_READARR;
    }
  }

  Future<void> launch() async {
    if (homeRoute != null) {
      HarbrRouter.router.pushReplacement(homeRoute!);
    }
  }
}

extension HarbrModuleWebhookExtension on HarbrModule {
  bool get hasWebhooks {
    switch (this) {
      case HarbrModule.LIDARR:
        return true;
      case HarbrModule.RADARR:
        return true;
      case HarbrModule.SONARR:
        return true;
      case HarbrModule.OVERSEERR:
        return true;
      case HarbrModule.TAUTULLI:
        return true;
      case HarbrModule.READARR:
        return true;
      default:
        return false;
    }
  }

  String? get webhookDocs {
    switch (this) {
      case HarbrModule.LIDARR:
        return 'https://docs.harbr.app/harbr/notifications/lidarr';
      case HarbrModule.RADARR:
        return 'https://docs.harbr.app/harbr/notifications/radarr';
      case HarbrModule.SONARR:
        return 'https://docs.harbr.app/harbr/notifications/sonarr';
      case HarbrModule.OVERSEERR:
        return 'https://docs.harbr.app/harbr/notifications/overseerr';
      case HarbrModule.TAUTULLI:
        return 'https://docs.harbr.app/harbr/notifications/tautulli';
      case HarbrModule.READARR:
        return 'https://docs.harbr.app/harbr/notifications/readarr';
      default:
        return null;
    }
  }

  Future<void> handleWebhook(Map<String, dynamic> data) async {
    switch (this) {
      case HarbrModule.LIDARR:
        return LidarrWebhooks().handle(data);
      case HarbrModule.RADARR:
        return RadarrWebhooks().handle(data);
      case HarbrModule.SONARR:
        return SonarrWebhooks().handle(data);
      case HarbrModule.TAUTULLI:
        return TautulliWebhooks().handle(data);
      default:
        return;
    }
  }
}

extension HarbrModuleExtension on HarbrModule {
  ShortcutItem get shortcutItem {
    if (this == HarbrModule.WAKE_ON_LAN) {
      throw Exception('WAKE_ON_LAN does not have a shortcut item');
    }
    return ShortcutItem(type: key, localizedTitle: title);
  }

  HarbrModuleState? state(BuildContext context) {
    switch (this) {
      case HarbrModule.WAKE_ON_LAN:
        return null;
      case HarbrModule.DASHBOARD:
        return context.read<DashboardState>();
      case HarbrModule.SETTINGS:
        return context.read<SettingsState>();
      case HarbrModule.SEARCH:
        return context.read<SearchState>();
      case HarbrModule.LIDARR:
        return context.read<LidarrState>();
      case HarbrModule.RADARR:
        return context.read<RadarrState>();
      case HarbrModule.SONARR:
        return context.read<SonarrState>();
      case HarbrModule.NZBGET:
        return context.read<NZBGetState>();
      case HarbrModule.SABNZBD:
        return context.read<SABnzbdState>();
      case HarbrModule.OVERSEERR:
        return null;
      case HarbrModule.TAUTULLI:
        return context.read<TautulliState>();
      case HarbrModule.EXTERNAL_MODULES:
        return null;
      case HarbrModule.READARR:
        return context.read<ReadarrState>();
    }
  }

  Widget informationBanner() {
    String key = 'HARBR_MODULE_INFORMATION_${this.key}';
    void markSeen() => HarbrBox.alerts.update(key, false);

    return HarbrBox.alerts.listenableBuilder(
      selectKeys: [key],
      builder: (context, _) {
        if (HarbrBox.alerts.read(key, fallback: true)) {
          return HarbrBanner(
            dismissCallback: markSeen,
            headerText: this.title,
            bodyText: this.information,
            icon: this.icon,
            iconColor: this.color,
            buttons: [
              if (this.github != null)
                HarbrButton.text(
                  text: 'GitHub',
                  icon: HarbrIcons.GITHUB,
                  onTap: this.github!.openLink,
                ),
              if (this.website != null)
                HarbrButton.text(
                  text: 'harbr.Website'.tr(),
                  icon: Icons.home_rounded,
                  onTap: this.website!.openLink,
                ),
            ],
          );
        }
        return const SizedBox(height: 0.0, width: double.infinity);
      },
    );
  }
}
