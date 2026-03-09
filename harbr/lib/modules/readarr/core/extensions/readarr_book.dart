import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

extension ReadarrBookExtension on ReadarrBook {
  String get harbrTitle {
    if (this.title?.isNotEmpty ?? false) return this.title!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrAuthorTitle {
    if (this.author?.authorName?.isNotEmpty ?? false) {
      return this.author!.authorName!;
    }
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrOverview {
    if (this.overview == null || this.overview!.isEmpty) {
      return 'readarr.NoSummaryAvailable'.tr();
    }
    return this.overview;
  }

  String get harbrGenres {
    if (this.genres?.isNotEmpty ?? false) return this.genres!.join('\n');
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrPageCount {
    if (this.pageCount != null && this.pageCount! > 0) {
      return '${this.pageCount} Pages';
    }
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrReleaseDate {
    if (this.releaseDate == null) {
      return 'harbr.Unknown'.tr();
    }
    return DateFormat('MMMM dd, y').format(this.releaseDate!.toLocal());
  }

  String get harbrDateAdded {
    if (this.added == null) {
      return 'harbr.Unknown'.tr();
    }
    return DateFormat('MMMM dd, y').format(this.added!.toLocal());
  }

  String get harbrEditionCount {
    return (this.editions?.length ?? 0).toString();
  }

  bool get harbrIsGrabbed {
    return this.grabbed ?? false;
  }

  bool get harbrIsMonitored {
    return this.monitored ?? false;
  }

  bool get harbrHasFile {
    return (this.statistics?.bookFileCount ?? 0) > 0;
  }

  String get harbrFileStatus {
    int fileCount = this.statistics?.bookFileCount ?? 0;
    if (fileCount > 0) return 'readarr.Downloaded'.tr();
    if (this.grabbed ?? false) return 'readarr.Grabbed'.tr();
    return 'readarr.Missing'.tr();
  }

  String get harbrSizeOnDisk {
    int size = this.statistics?.sizeOnDisk ?? 0;
    if (size == 0) return HarbrUI.TEXT_EMDASH;
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Creates a clone of the [ReadarrBook] object (deep copy).
  ReadarrBook clone() => ReadarrBook.fromJson(this.toJson());
}
