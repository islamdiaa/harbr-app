import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

extension DateTimeExtension on DateTime {
  String _formatted(String format) {
    return DateFormat(format, 'en').format(this.toLocal());
  }

  DateTime floor() {
    return DateTime(this.year, this.month, this.day);
  }

  String asTimeOnly() {
    if (HarbrDatabase.USE_24_HOUR_TIME.read()) return _formatted('Hm');
    return _formatted('jm');
  }

  String asDateOnly({
    shortenMonth = false,
  }) {
    final format = shortenMonth ? 'MMM dd, y' : 'MMMM dd, y';
    return _formatted(format);
  }

  String asDateTime({
    bool showSeconds = true,
    bool shortenMonth = false,
    String? delimiter,
  }) {
    final format = StringBuffer(shortenMonth ? 'MMM dd, y' : 'MMMM dd, y');
    format.write(delimiter ?? HarbrUI.TEXT_BULLET.pad());
    format.write(HarbrDatabase.USE_24_HOUR_TIME.read() ? 'HH:mm' : 'hh:mm');
    if (showSeconds) format.write(':ss');
    if (!HarbrDatabase.USE_24_HOUR_TIME.read()) format.write(' a');

    return _formatted(format.toString());
  }

  String asPoleDate() {
    final year = this.year.toString().padLeft(4, '0');
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String asAge() {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 15) return 'harbr.JustNow'.tr();

    final days = diff.inDays.abs();
    if (days >= 1) {
      final years = (days / 365).floor();
      if (years == 1) return 'harbr.OneYearAgo'.tr();
      if (years > 1) return 'harbr.YearsAgo'.tr(args: [years.toString()]);

      final months = (days / 30).floor();
      if (months == 1) return 'harbr.OneMonthAgo'.tr();
      if (months > 1) return 'harbr.MonthsAgo'.tr(args: [months.toString()]);

      if (days == 1) return 'harbr.OneDayAgo'.tr();
      if (days > 1) return 'harbr.DaysAgo'.tr(args: [days.toString()]);
    }

    final hours = diff.inHours.abs();
    if (hours == 1) return 'harbr.OneHourAgo'.tr();
    if (hours > 1) return 'harbr.HoursAgo'.tr(args: [hours.toString()]);

    final mins = diff.inMinutes.abs();
    if (mins == 1) return 'harbr.OneMinuteAgo'.tr();
    if (mins > 1) return 'harbr.MinutesAgo'.tr(args: [mins.toString()]);

    final secs = diff.inSeconds.abs();
    if (secs == 1) return 'harbr.OneSecondAgo'.tr();
    return 'harbr.SecondsAgo'.tr(args: [secs.toString()]);
  }

  String asDaysDifference() {
    final diff = DateTime.now().difference(this);
    final days = diff.inDays.abs();
    if (days == 0) return 'harbr.Today'.tr();

    final years = (days / 365).floor();
    if (years == 1) return 'harbr.OneYear'.tr();
    if (years > 1) return 'harbr.Years'.tr(args: [years.toString()]);

    final months = (days / 30).floor();
    if (months == 1) return 'harbr.OneMonth'.tr();
    if (months > 1) return 'harbr.Months'.tr(args: [months.toString()]);

    if (days == 1) return 'harbr.OneDay'.tr();
    return 'harbr.Days'.tr(args: [days.toString()]);
  }
}
