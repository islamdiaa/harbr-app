import 'package:harbr/database/models/external_module.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/database/models/log.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/types/indexer_icon.dart';
import 'package:harbr/types/list_view_option.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/database/table.dart';
import 'package:harbr/types/log_type.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

enum HarbrDatabase<T> with HarbrTableMixin<T> {
  ANDROID_BACK_OPENS_DRAWER<bool>(true),
  DRAWER_AUTOMATIC_MANAGE<bool>(true),
  DRAWER_MANUAL_ORDER<List>([]),
  ENABLED_PROFILE<String>(HarbrProfile.DEFAULT_PROFILE),
  NETWORKING_TLS_VALIDATION<bool>(false),
  THEME_AMOLED<bool>(false),
  THEME_AMOLED_BORDER<bool>(false),
  THEME_IMAGE_BACKGROUND_OPACITY<int>(20),
  QUICK_ACTIONS_LIDARR<bool>(false),
  QUICK_ACTIONS_RADARR<bool>(false),
  QUICK_ACTIONS_SONARR<bool>(false),
  QUICK_ACTIONS_NZBGET<bool>(false),
  QUICK_ACTIONS_SABNZBD<bool>(false),
  QUICK_ACTIONS_OVERSEERR<bool>(false),
  QUICK_ACTIONS_TAUTULLI<bool>(false),
  QUICK_ACTIONS_SEARCH<bool>(false),
  USE_24_HOUR_TIME<bool>(false),
  ENABLE_IN_APP_NOTIFICATIONS<bool>(true),
  CHANGELOG_LAST_BUILD_VERSION<int>(0);

  @override
  HarbrTable get table => HarbrTable.harbr;

  @override
  final T fallback;

  const HarbrDatabase(this.fallback);

  @override
  void register() {
    Hive.registerAdapter(HarbrExternalModuleAdapter());
    Hive.registerAdapter(HarbrIndexerAdapter());
    Hive.registerAdapter(HarbrProfileAdapter());
    Hive.registerAdapter(HarbrLogAdapter());
    Hive.registerAdapter(HarbrIndexerIconAdapter());
    Hive.registerAdapter(HarbrLogTypeAdapter());
    Hive.registerAdapter(HarbrModuleAdapter());
    Hive.registerAdapter(HarbrListViewOptionAdapter());
  }

  @override
  dynamic export() {
    HarbrDatabase db = this;
    switch (db) {
      case HarbrDatabase.DRAWER_MANUAL_ORDER:
        return HarbrDrawer.moduleOrderedList()
            .map<String>((module) => module.key)
            .toList();
      default:
        return super.export();
    }
  }

  @override
  void import(dynamic value) {
    HarbrDatabase db = this;
    dynamic result;

    switch (db) {
      case HarbrDatabase.DRAWER_MANUAL_ORDER:
        List<HarbrModule> item = [];
        (value as List).cast<String>().forEach((val) {
          HarbrModule? module = HarbrModule.fromKey(val);
          if (module != null) item.add(module);
        });
        result = item;
        break;
      default:
        result = value;
        break;
    }

    return super.import(result);
  }
}
