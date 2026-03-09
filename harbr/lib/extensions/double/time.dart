import 'package:harbr/core.dart';

extension DoubleAsTimeExtension on double? {
  String asTimeAgo() {
    if (this == null || this! < 0) return HarbrUI.TEXT_EMDASH;

    double hours = this!;
    double minutes = (this! * 60);
    double days = (this! / 24);

    if (minutes <= 2) {
      return 'harbr.JustNow'.tr();
    }

    if (minutes <= 120) {
      return 'harbr.MinutesAgo'.tr(args: [minutes.round().toString()]);
    }

    if (hours <= 48) {
      return 'harbr.HoursAgo'.tr(args: [hours.toStringAsFixed(1)]);
    }

    return 'harbr.DaysAgo'.tr(args: [days.round().toString()]);
  }
}
