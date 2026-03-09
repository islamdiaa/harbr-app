import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/readarr.dart';

extension ReadarrHistoryRecordExtension on ReadarrHistoryRecord {
  String get harbrTitle {
    if (this.sourceTitle?.isNotEmpty ?? false) return this.sourceTitle!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrDate {
    if (this.date == null) return 'harbr.Unknown'.tr();
    return this.date!.asDateTime(
      showSeconds: false,
      delimiter: '@'.pad(),
    );
  }

  String get harbrEventType {
    if (this.eventType?.isNotEmpty ?? false) return this.eventType!.toTitleCase();
    return HarbrUI.TEXT_EMDASH;
  }
}
