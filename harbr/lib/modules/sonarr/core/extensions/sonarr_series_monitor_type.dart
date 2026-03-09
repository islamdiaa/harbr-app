import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

extension HarbrSonarrSeriesMonitorTypeExtension on SonarrSeriesMonitorType {
  String get harbrName {
    switch (this) {
      case SonarrSeriesMonitorType.ALL:
        return 'All Episodes';
      case SonarrSeriesMonitorType.FUTURE:
        return 'Future Episodes';
      case SonarrSeriesMonitorType.MISSING:
        return 'Missing Episodes';
      case SonarrSeriesMonitorType.EXISTING:
        return 'Existing Episodes';
      case SonarrSeriesMonitorType.PILOT:
        return 'Pilot Episode';
      case SonarrSeriesMonitorType.FIRST_SEASON:
        return 'Only First Season';
      case SonarrSeriesMonitorType.LATEST_SEASON:
        return 'Only Latest Season';
      case SonarrSeriesMonitorType.NONE:
        return 'None';
      default:
        return 'harbr.Unknown'.tr();
    }
  }
}
