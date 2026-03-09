import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/system/flavor.dart';

part 'log_type.g.dart';

const TYPE_DEBUG = 'debug';
const TYPE_WARNING = 'warning';
const TYPE_ERROR = 'error';
const TYPE_CRITICAL = 'critical';

@HiveType(typeId: 24, adapterName: 'HarbrLogTypeAdapter')
enum HarbrLogType {
  @HiveField(0)
  WARNING(TYPE_WARNING),
  @HiveField(1)
  ERROR(TYPE_ERROR),
  @HiveField(2)
  CRITICAL(TYPE_CRITICAL),
  @HiveField(3)
  DEBUG(TYPE_DEBUG);

  final String key;
  const HarbrLogType(this.key);

  String get description => 'settings.ViewTypeLogs'.tr(args: [title]);

  bool get enabled {
    switch (this) {
      case HarbrLogType.DEBUG:
        return HarbrFlavor.BETA.isRunningFlavor();
      default:
        return true;
    }
  }

  String get title {
    switch (this) {
      case HarbrLogType.WARNING:
        return 'harbr.Warning'.tr();
      case HarbrLogType.ERROR:
        return 'harbr.Error'.tr();
      case HarbrLogType.CRITICAL:
        return 'harbr.Critical'.tr();
      case HarbrLogType.DEBUG:
        return 'harbr.Debug'.tr();
    }
  }

  IconData get icon {
    switch (this) {
      case HarbrLogType.WARNING:
        return HarbrIcons.WARNING;
      case HarbrLogType.ERROR:
        return HarbrIcons.ERROR;
      case HarbrLogType.CRITICAL:
        return HarbrIcons.CRITICAL;
      case HarbrLogType.DEBUG:
        return HarbrIcons.DEBUG;
    }
  }

  Color get color {
    switch (this) {
      case HarbrLogType.WARNING:
        return HarbrColours.orange;
      case HarbrLogType.ERROR:
        return HarbrColours.red;
      case HarbrLogType.CRITICAL:
        return HarbrColours.accent;
      case HarbrLogType.DEBUG:
        return HarbrColours.blueGrey;
    }
  }

  static HarbrLogType? fromKey(String key) {
    switch (key) {
      case TYPE_WARNING:
        return HarbrLogType.WARNING;
      case TYPE_ERROR:
        return HarbrLogType.ERROR;
      case TYPE_CRITICAL:
        return HarbrLogType.CRITICAL;
      case TYPE_DEBUG:
        return HarbrLogType.DEBUG;
    }
    return null;
  }
}
