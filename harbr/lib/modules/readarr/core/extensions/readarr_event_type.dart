import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

extension ReadarrEventTypeExtension on ReadarrEventType {
  String get harbrReadable {
    switch (this) {
      case ReadarrEventType.GRABBED:
        return 'readarr.Grabbed'.tr();
      case ReadarrEventType.BOOK_FILE_IMPORTED:
        return 'readarr.BookFileImported'.tr();
      case ReadarrEventType.BOOK_FILE_UPGRADED:
        return 'readarr.BookFileUpgraded'.tr();
      case ReadarrEventType.BOOK_FILE_RENAMED:
        return 'readarr.BookFileRenamed'.tr();
      case ReadarrEventType.BOOK_FILE_DELETED:
        return 'readarr.BookFileDeleted'.tr();
      case ReadarrEventType.BOOK_FILE_RETAGGED:
        return 'readarr.BookFileRetagged'.tr();
      case ReadarrEventType.DOWNLOAD_FAILED:
        return 'readarr.DownloadFailed'.tr();
      case ReadarrEventType.DOWNLOAD_IMPORTED:
        return 'readarr.DownloadImported'.tr();
      case ReadarrEventType.BOOK_IMPORTED:
        return 'readarr.BookImported'.tr();
    }
  }
}
