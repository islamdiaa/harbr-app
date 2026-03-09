import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/double/time.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrEventTypeHarbrExtension on SonarrEventType {
  Color harbrColour() {
    switch (this) {
      case SonarrEventType.EPISODE_FILE_RENAMED:
        return HarbrColours.blue;
      case SonarrEventType.EPISODE_FILE_DELETED:
        return HarbrColours.red;
      case SonarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return HarbrColours.accent;
      case SonarrEventType.DOWNLOAD_FAILED:
        return HarbrColours.red;
      case SonarrEventType.DOWNLOAD_IGNORED:
        return HarbrColours.purple;
      case SonarrEventType.GRABBED:
        return HarbrColours.orange;
      case SonarrEventType.SERIES_FOLDER_IMPORTED:
        return HarbrColours.accent;
    }
  }

  IconData harbrIcon() {
    switch (this) {
      case SonarrEventType.EPISODE_FILE_RENAMED:
        return Icons.drive_file_rename_outline_rounded;
      case SonarrEventType.EPISODE_FILE_DELETED:
        return Icons.delete_rounded;
      case SonarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return Icons.download_rounded;
      case SonarrEventType.DOWNLOAD_FAILED:
        return Icons.cloud_download_rounded;
      case SonarrEventType.DOWNLOAD_IGNORED:
        return Icons.cancel_rounded;
      case SonarrEventType.GRABBED:
        return Icons.cloud_download_rounded;
      case SonarrEventType.SERIES_FOLDER_IMPORTED:
        return Icons.download_rounded;
    }
  }

  Color harbrIconColour() {
    switch (this) {
      case SonarrEventType.EPISODE_FILE_RENAMED:
        return Colors.white;
      case SonarrEventType.EPISODE_FILE_DELETED:
        return Colors.white;
      case SonarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return Colors.white;
      case SonarrEventType.DOWNLOAD_FAILED:
        return HarbrColours.red;
      case SonarrEventType.DOWNLOAD_IGNORED:
        return Colors.white;
      case SonarrEventType.GRABBED:
        return Colors.white;
      case SonarrEventType.SERIES_FOLDER_IMPORTED:
        return Colors.white;
    }
  }

  String? harbrReadable(SonarrHistoryRecord record) {
    switch (this) {
      case SonarrEventType.EPISODE_FILE_RENAMED:
        return 'sonarr.EpisodeFileRenamed'.tr();
      case SonarrEventType.EPISODE_FILE_DELETED:
        return 'sonarr.EpisodeFileDeleted'.tr();
      case SonarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return 'sonarr.EpisodeImported'.tr(
          args: [record.quality?.quality?.name ?? 'harbr.Unknown'.tr()],
        );
      case SonarrEventType.DOWNLOAD_FAILED:
        return 'sonarr.DownloadFailed'.tr();
      case SonarrEventType.GRABBED:
        return 'sonarr.GrabbedFrom'.tr(
          args: [record.data!['indexer'] ?? 'harbr.Unknown'.tr()],
        );
      case SonarrEventType.DOWNLOAD_IGNORED:
        return 'sonarr.DownloadIgnored'.tr();
      case SonarrEventType.SERIES_FOLDER_IMPORTED:
        return 'sonarr.SeriesFolderImported'.tr();
    }
  }

  List<HarbrTableContent> harbrTableContent({
    required SonarrHistoryRecord history,
    required bool showSourceTitle,
  }) {
    switch (this) {
      case SonarrEventType.DOWNLOAD_FAILED:
        return _downloadFailedTableContent(history, showSourceTitle);
      case SonarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return _downloadFolderImportedTableContent(history, showSourceTitle);
      case SonarrEventType.DOWNLOAD_IGNORED:
        return _downloadIgnoredTableContent(history, showSourceTitle);
      case SonarrEventType.EPISODE_FILE_DELETED:
        return _episodeFileDeletedTableContent(history, showSourceTitle);
      case SonarrEventType.EPISODE_FILE_RENAMED:
        return _episodeFileRenamedTableContent(history);
      case SonarrEventType.GRABBED:
        return _grabbedTableContent(history, showSourceTitle);
      case SonarrEventType.SERIES_FOLDER_IMPORTED:
      default:
        return _defaultTableContent(history, showSourceTitle);
    }
  }

  List<HarbrTableContent> _downloadFailedTableContent(
    SonarrHistoryRecord history,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'sonarr.SourceTitle'.tr(),
          body: history.sourceTitle,
        ),
      HarbrTableContent(
        title: 'sonarr.Message'.tr(),
        body: history.data!['message'],
      ),
    ];
  }

  List<HarbrTableContent> _downloadFolderImportedTableContent(
    SonarrHistoryRecord history,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'sonarr.SourceTitle'.tr(),
          body: history.sourceTitle,
        ),
      HarbrTableContent(
        title: 'sonarr.Quality'.tr(),
        body: history.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
      ),
      if (history.language != null)
        HarbrTableContent(
          title: 'sonarr.Languages'.tr(),
          body: history.language?.name ?? HarbrUI.TEXT_EMDASH,
        ),
      HarbrTableContent(
        title: 'sonarr.Client'.tr(),
        body: history.data!['downloadClient'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'sonarr.Source'.tr(),
        body: history.data!['droppedPath'],
      ),
      HarbrTableContent(
        title: 'sonarr.ImportedTo'.tr(),
        body: history.data!['importedPath'],
      ),
    ];
  }

  List<HarbrTableContent> _downloadIgnoredTableContent(
    SonarrHistoryRecord history,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'sonarr.Name'.tr(),
          body: history.sourceTitle,
        ),
      HarbrTableContent(
        title: 'sonarr.Message'.tr(),
        body: history.data!['message'],
      ),
    ];
  }

  List<HarbrTableContent> _episodeFileDeletedTableContent(
    SonarrHistoryRecord history,
    bool showSourceTitle,
  ) {
    String _reasonMapping(String? reason) {
      switch (reason) {
        case 'Upgrade':
          return 'sonarr.DeleteReasonUpgrade'.tr();
        case 'MissingFromDisk':
          return 'sonarr.DeleteReasonMissingFromDisk'.tr();
        case 'Manual':
          return 'sonarr.DeleteReasonManual'.tr();
        default:
          return 'harbr.Unknown'.tr();
      }
    }

    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'sonarr.SourceTitle'.tr(),
          body: history.sourceTitle,
        ),
      HarbrTableContent(
        title: 'sonarr.Reason'.tr(),
        body: _reasonMapping(history.data!['reason']),
      ),
    ];
  }

  List<HarbrTableContent> _episodeFileRenamedTableContent(
    SonarrHistoryRecord history,
  ) {
    return [
      HarbrTableContent(
        title: 'sonarr.Source'.tr(),
        body: history.data!['sourcePath'],
      ),
      HarbrTableContent(
        title: 'sonarr.SourceRelative'.tr(),
        body: history.data!['sourceRelativePath'],
      ),
      HarbrTableContent(
        title: 'sonarr.Destination'.tr(),
        body: history.data!['path'],
      ),
      HarbrTableContent(
        title: 'sonarr.DestinationRelative'.tr(),
        body: history.data!['relativePath'],
      ),
    ];
  }

  List<HarbrTableContent> _grabbedTableContent(
    SonarrHistoryRecord history,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'sonarr.SourceTitle'.tr(),
          body: history.sourceTitle,
        ),
      HarbrTableContent(
        title: 'sonarr.Quality'.tr(),
        body: history.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
      ),
      if (history.language != null)
        HarbrTableContent(
          title: 'sonarr.Languages'.tr(),
          body: history.language?.name ?? HarbrUI.TEXT_EMDASH,
        ),
      HarbrTableContent(
        title: 'sonarr.Indexer'.tr(),
        body: history.data!['indexer'],
      ),
      HarbrTableContent(
        title: 'sonarr.ReleaseGroup'.tr(),
        body: history.data!['releaseGroup'],
      ),
      HarbrTableContent(
        title: 'sonarr.InfoURL'.tr(),
        body: history.data!['nzbInfoUrl'],
        bodyIsUrl: history.data!['nzbInfoUrl'] != null,
      ),
      HarbrTableContent(
        title: 'sonarr.Client'.tr(),
        body: history.data!['downloadClientName'],
      ),
      HarbrTableContent(
        title: 'sonarr.DownloadID'.tr(),
        body: history.data!['downloadId'],
      ),
      HarbrTableContent(
        title: 'sonarr.Age'.tr(),
        body: double.tryParse(history.data!['ageHours'])?.asTimeAgo(),
      ),
      HarbrTableContent(
          title: 'sonarr.PublishedDate'.tr(),
          body: DateTime.tryParse(history.data!['publishedDate'])
              ?.asDateTime(delimiter: '\n')),
    ];
  }

  List<HarbrTableContent> _defaultTableContent(
    SonarrHistoryRecord history,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'sonarr.Name'.tr(),
          body: history.sourceTitle,
        ),
    ];
  }
}
