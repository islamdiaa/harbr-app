import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/readarr.dart';

extension ReadarrQueueRecordExtension on ReadarrQueueRecord {
  String get harbrTitle {
    if (this.title?.isNotEmpty ?? false) return this.title!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrStatus {
    if (this.status?.isNotEmpty ?? false) return this.status!.toTitleCase();
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrPercentDone {
    if (this.size == null || this.size == 0) return '0.0%';
    double _left = this.sizeleft ?? 0;
    double _percent = (1 - (_left / this.size!)) * 100;
    return '${_percent.toStringAsFixed(1)}%';
  }

  String get harbrSizeleft {
    if (this.sizeleft == null) return '0.0 B';
    return this.sizeleft!.toInt().asBytes(decimals: 1);
  }
}
