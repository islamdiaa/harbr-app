import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrQueueRecord on RadarrQueueRecord {
  String get harbrQuality {
    return this.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH;
  }

  String get harbrLanguage {
    if ((this.languages?.length ?? 0) == 0) return HarbrUI.TEXT_EMDASH;
    if (this.languages!.length == 1)
      return this.languages![0].name ?? HarbrUI.TEXT_EMDASH;
    return 'Multi-Language';
  }

  String harbrMovieTitle(RadarrMovie movie) {
    String title = movie.title ?? HarbrUI.TEXT_EMDASH;
    String year = movie.harbrYear;
    return '$title ($year)';
  }

  String? get harbrDownloadClient {
    if ((this.downloadClient ?? '').isNotEmpty) return this.downloadClient;
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrIndexer {
    if ((this.indexer ?? '').isNotEmpty) return this.indexer;
    return HarbrUI.TEXT_EMDASH;
  }

  Color get harbrProtocolColor {
    if (this.protocol == RadarrProtocol.USENET) return HarbrColours.accent;
    return HarbrColours.blue;
  }

  int get harbrPercentageComplete {
    if (this.sizeLeft == null || this.size == null || this.size == 0) return 0;
    double sizeFetched = this.size! - this.sizeLeft!;
    return ((sizeFetched / this.size!) * 100).round();
  }

  IconData get harbrStatusIcon {
    switch (this.status) {
      case RadarrQueueRecordStatus.DELAY:
        return Icons.access_time_rounded;
      case RadarrQueueRecordStatus.DOWNLOAD_CLIENT_UNAVAILABLE:
        return Icons.access_time_rounded;
      case RadarrQueueRecordStatus.FAILED:
        return Icons.cloud_download_rounded;
      case RadarrQueueRecordStatus.PAUSED:
        return Icons.pause_rounded;
      case RadarrQueueRecordStatus.QUEUED:
        return Icons.cloud_rounded;
      case RadarrQueueRecordStatus.WARNING:
        return Icons.cloud_download_rounded;
      case RadarrQueueRecordStatus.COMPLETED:
        return Icons.download_done_rounded;
      case RadarrQueueRecordStatus.DOWNLOADING:
        return Icons.cloud_download_rounded;
      default:
        return Icons.cloud_download_rounded;
    }
  }

  Color get harbrStatusColor {
    Color color = Colors.white;
    if (this.status == RadarrQueueRecordStatus.COMPLETED)
      switch (this.trackedDownloadState) {
        case RadarrTrackedDownloadState.FAILED_PENDING:
          color = HarbrColours.red;
          break;
        case RadarrTrackedDownloadState.IMPORT_PENDING:
          color = HarbrColours.purple;
          break;
        case RadarrTrackedDownloadState.IMPORTING:
          color = HarbrColours.purple;
          break;
        default:
          break;
      }
    if (this.trackedDownloadStatus == RadarrTrackedDownloadStatus.WARNING)
      color = HarbrColours.orange;
    switch (this.status) {
      case RadarrQueueRecordStatus.DOWNLOAD_CLIENT_UNAVAILABLE:
        color = HarbrColours.orange;
        break;
      case RadarrQueueRecordStatus.FAILED:
        color = HarbrColours.red;
        break;
      case RadarrQueueRecordStatus.WARNING:
        color = HarbrColours.orange;
        break;
      default:
        break;
    }
    if (this.trackedDownloadStatus == RadarrTrackedDownloadStatus.ERROR)
      color = HarbrColours.red;
    return color;
  }
}
