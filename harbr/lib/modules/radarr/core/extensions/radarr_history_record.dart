import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrHistoryRecord on RadarrHistoryRecord {
  String get harbrFileDeletedReasonMessage {
    if (this.eventType != RadarrEventType.MOVIE_FILE_DELETED ||
        this.data!['reason'] == null) return HarbrUI.TEXT_EMDASH;
    switch (this.data!['reason']) {
      case 'Manual':
        return 'File was deleted manually';
      case 'MissingFromDisk':
        return 'Unable to find the file on disk';
      case 'Upgrade':
        return 'File was deleted to import an upgrade';
      default:
        return HarbrUI.TEXT_EMDASH;
    }
  }
}
