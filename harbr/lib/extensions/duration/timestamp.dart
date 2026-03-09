import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

extension DurationAsTimestampExtension on Duration? {
  String asNumberTimestamp() {
    if (this == null) return HarbrUI.TEXT_EMDASH;

    final hours = this!.inHours.toString().padLeft(2, '0');
    final minutes = (this!.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (this!.inSeconds % 60).toString().padLeft(2, '0');

    if (hours == '00') return '$minutes:$seconds';
    return '$hours:$minutes:$seconds';
  }

  String asWordsTimestamp({
    int multiplier = 1,
    int divisor = 1,
  }) {
    if (this == null) return 'harbr.Unknown'.tr();
    if (this!.inSeconds <= 5) return 'harbr.Minutes'.tr(args: ['0']);

    final List<String> words = [];

    final days = this!.inDays;
    if (days > 0) {
      if (days == 1) {
        words.add('harbr.OneDay'.tr());
      } else {
        words.add('harbr.Days'.tr(args: [days.toString()]));
      }
    }

    final hours = this!.inHours % 24;
    if (hours > 0) {
      if (hours == 1) {
        words.add('harbr.OneHour'.tr());
      } else {
        words.add('harbr.Hours'.tr(args: [hours.toString()]));
      }
    }

    final minutes = this!.inMinutes % 60;
    if (minutes > 0) {
      if (minutes == 1) {
        words.add('harbr.OneMinute'.tr());
      } else {
        words.add('harbr.Minutes'.tr(args: [minutes.toString()]));
      }
    }

    return words.isEmpty ? 'harbr.UnderAMinute'.tr() : words.join(' ');
  }
}
