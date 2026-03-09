import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/double/time.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrEventType on RadarrEventType {
  // Get Harbr associated colour of the event type.
  Color get harbrColour {
    switch (this) {
      case RadarrEventType.GRABBED:
        return HarbrColours.orange;
      case RadarrEventType.DOWNLOAD_FAILED:
        return HarbrColours.red;
      case RadarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return HarbrColours.accent;
      case RadarrEventType.DOWNLOAD_IGNORED:
        return HarbrColours.purple;
      case RadarrEventType.MOVIE_FILE_DELETED:
        return HarbrColours.red;
      case RadarrEventType.MOVIE_FILE_RENAMED:
        return HarbrColours.blue;
      case RadarrEventType.MOVIE_FOLDER_IMPORTED:
        return HarbrColours.accent;
    }
  }

  IconData get harbrIcon {
    switch (this) {
      case RadarrEventType.GRABBED:
        return Icons.cloud_download_rounded;
      case RadarrEventType.DOWNLOAD_FAILED:
        return Icons.cloud_download_rounded;
      case RadarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return Icons.download_rounded;
      case RadarrEventType.MOVIE_FOLDER_IMPORTED:
        return Icons.download_rounded;
      case RadarrEventType.MOVIE_FILE_DELETED:
        return Icons.delete_rounded;
      case RadarrEventType.DOWNLOAD_IGNORED:
        return Icons.cancel_rounded;
      case RadarrEventType.MOVIE_FILE_RENAMED:
        return Icons.drive_file_rename_outline_rounded;
    }
  }

  Color get harbrIconColour {
    switch (this) {
      case RadarrEventType.GRABBED:
        return Colors.white;
      case RadarrEventType.DOWNLOAD_FAILED:
        return HarbrColours.red;
      case RadarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return Colors.white;
      case RadarrEventType.DOWNLOAD_IGNORED:
        return Colors.white;
      case RadarrEventType.MOVIE_FILE_DELETED:
        return Colors.white;
      case RadarrEventType.MOVIE_FILE_RENAMED:
        return Colors.white;
      case RadarrEventType.MOVIE_FOLDER_IMPORTED:
        return Colors.white;
    }
  }

  String? harbrReadable(RadarrHistoryRecord record) {
    switch (this) {
      case RadarrEventType.GRABBED:
        return 'radarr.GrabbedFrom'
            .tr(args: [(record.data ?? {})['indexer'] ?? HarbrUI.TEXT_EMDASH]);
      case RadarrEventType.DOWNLOAD_FAILED:
        return 'radarr.DownloadFailed'.tr();
      case RadarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return 'radarr.MovieImported'
            .tr(args: [record.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH]);
      case RadarrEventType.DOWNLOAD_IGNORED:
        return 'radarr.DownloadIgnored'.tr();
      case RadarrEventType.MOVIE_FILE_DELETED:
        return 'radarr.MovieFileDeleted'.tr();
      case RadarrEventType.MOVIE_FILE_RENAMED:
        return 'radarr.MovieFileRenamed'.tr();
      case RadarrEventType.MOVIE_FOLDER_IMPORTED:
        return 'radarr.MovieImported'
            .tr(args: [record.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH]);
    }
  }

  List<HarbrTableContent> harbrTableContent(
    RadarrHistoryRecord record, {
    bool movieHistory = false,
  }) {
    switch (this) {
      case RadarrEventType.GRABBED:
        return _grabbedTableContent(record, !movieHistory);
      case RadarrEventType.DOWNLOAD_FAILED:
        return _downloadFailedTableContent(record, !movieHistory);
      case RadarrEventType.DOWNLOAD_FOLDER_IMPORTED:
        return _downloadFolderImportedTableContent(record);
      case RadarrEventType.DOWNLOAD_IGNORED:
        return _downloadIgnoredTableContent(record, !movieHistory);
      case RadarrEventType.MOVIE_FILE_DELETED:
        return _movieFileDeletedTableContent(record, !movieHistory);
      case RadarrEventType.MOVIE_FILE_RENAMED:
        return _movieFileRenamedTableContent(record);
      case RadarrEventType.MOVIE_FOLDER_IMPORTED:
        return _movieFolderImportedTableContent(record);
      default:
        return [];
    }
  }

  List<HarbrTableContent> _grabbedTableContent(
    RadarrHistoryRecord record,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'source title',
          body: record.sourceTitle ?? HarbrUI.TEXT_EMDASH,
        ),
      HarbrTableContent(
        title: 'quality',
        body: record.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'languages',
        body: record.languages
            ?.map<String?>((language) => language.name)
            .join('\n'),
      ),
      HarbrTableContent(
        title: 'indexer',
        body: record.data!['indexer'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'group',
        body: record.data!['releaseGroup'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'client',
        body: record.data!['downloadClientName'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'age',
        body: record.data!['ageHours'] != null
            ? double.tryParse((record.data!['ageHours'] as String))
                    ?.asTimeAgo() ??
                HarbrUI.TEXT_EMDASH
            : HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'published date',
        body: DateTime.tryParse(record.data!['publishedDate']) != null
            ? DateTime.tryParse(record.data!['publishedDate'])
                    ?.asDateTime(delimiter: '\n') ??
                HarbrUI.TEXT_EMDASH
            : HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'info url',
        body: record.data!['nzbInfoUrl'] ?? HarbrUI.TEXT_EMDASH,
        bodyIsUrl: record.data!['nzbInfoUrl'] != null,
      ),
    ];
  }

  List<HarbrTableContent> _downloadFailedTableContent(
    RadarrHistoryRecord record,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'source title',
          body: record.sourceTitle ?? HarbrUI.TEXT_EMDASH,
        ),
      HarbrTableContent(
        title: 'client',
        body: record.data!['downloadClientName'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'message',
        body: record.data!['message'] ?? HarbrUI.TEXT_EMDASH,
      ),
    ];
  }

  List<HarbrTableContent> _downloadFolderImportedTableContent(
    RadarrHistoryRecord record,
  ) {
    return [
      HarbrTableContent(
        title: 'source title',
        body: record.sourceTitle ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'quality',
        body: record.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'languages',
        body: record.languages
                ?.map<String?>((language) => language.name)
                .join('\n') ??
            HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'client',
        body: record.data!['downloadClientName'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'source',
        body: record.data!['droppedPath'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'imported to',
        body: record.data!['importedPath'] ?? HarbrUI.TEXT_EMDASH,
      ),
    ];
  }

  List<HarbrTableContent> _downloadIgnoredTableContent(
    RadarrHistoryRecord record,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'source title',
          body: record.sourceTitle ?? HarbrUI.TEXT_EMDASH,
        ),
      HarbrTableContent(
        title: 'message',
        body: record.data!['message'] ?? HarbrUI.TEXT_EMDASH,
      ),
    ];
  }

  List<HarbrTableContent> _movieFileDeletedTableContent(
    RadarrHistoryRecord record,
    bool showSourceTitle,
  ) {
    return [
      if (showSourceTitle)
        HarbrTableContent(
          title: 'source title',
          body: record.sourceTitle ?? HarbrUI.TEXT_EMDASH,
        ),
      HarbrTableContent(
        title: 'reason',
        body: record.harbrFileDeletedReasonMessage,
      ),
    ];
  }

  List<HarbrTableContent> _movieFileRenamedTableContent(
    RadarrHistoryRecord record,
  ) {
    return [
      HarbrTableContent(
        title: 'source',
        body: record.data!['sourceRelativePath'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'destination',
        body: record.data!['relativePath'] ?? HarbrUI.TEXT_EMDASH,
      ),
    ];
  }

  List<HarbrTableContent> _movieFolderImportedTableContent(
    RadarrHistoryRecord record,
  ) {
    return [
      HarbrTableContent(
        title: 'source title',
        body: record.sourceTitle ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'quality',
        body: record.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'languages',
        body: ([RadarrLanguage(name: HarbrUI.TEXT_EMDASH)])
            .map<String?>((language) => language.name)
            .join('\n'),
      ),
      HarbrTableContent(
        title: 'client',
        body: record.data!['downloadClientName'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'source',
        body: record.data!['droppedPath'] ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'imported to',
        body: record.data!['importedPath'] ?? HarbrUI.TEXT_EMDASH,
      ),
    ];
  }
}
