import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrCalendarExtension on SonarrCalendar {
  String get harbrAirTime {
    if (this.airDateUtc != null)
      return HarbrDatabase.USE_24_HOUR_TIME.read()
          ? DateFormat.Hm().format(this.airDateUtc!.toLocal())
          : DateFormat('hh:mm\na').format(this.airDateUtc!.toLocal());
    return HarbrUI.TEXT_EMDASH;
  }

  bool get harbrHasAired {
    if (this.airDateUtc != null)
      return DateTime.now().isAfter(this.airDateUtc!.toLocal());
    return false;
  }
}
