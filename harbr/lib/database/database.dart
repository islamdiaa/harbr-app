import 'package:harbr/database/box.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/database/table.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/system/filesystem/filesystem.dart';
import 'package:harbr/system/platform.dart';
import 'package:harbr/vendor.dart';

class HarbrDB {
  static const String _DATABASE_LEGACY_PATH = 'database';
  static const String _DATABASE_PATH = 'Harbr/database';

  String get path {
    if (HarbrPlatform.isWindows || HarbrPlatform.isLinux) return _DATABASE_PATH;
    return _DATABASE_LEGACY_PATH;
  }

  Future<void> initialize() async {
    await Hive.initFlutter(path);
    HarbrTable.register();
    await open();
  }

  Future<void> open() async {
    await HarbrBox.open();
    if (HarbrBox.profiles.isEmpty) await bootstrap();
  }

  Future<void> nuke() async {
    await Hive.close();

    for (final box in HarbrBox.values) {
      await Hive.deleteBoxFromDisk(box.key, path: path);
    }

    if (HarbrFileSystem.isSupported) {
      await HarbrFileSystem().nuke();
    }
  }

  Future<void> bootstrap() async {
    const defaultProfile = HarbrProfile.DEFAULT_PROFILE;
    await clear();

    HarbrBox.profiles.update(defaultProfile, HarbrProfile());
    HarbrDatabase.ENABLED_PROFILE.update(defaultProfile);
  }

  Future<void> clear() async {
    for (final box in HarbrBox.values) await box.clear();
  }

  Future<void> deinitialize() async {
    await Hive.close();
  }
}
