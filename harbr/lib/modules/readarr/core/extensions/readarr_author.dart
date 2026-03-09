import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/readarr.dart';

extension ReadarrAuthorExtension on ReadarrAuthor {
  String get harbrTitle {
    if (this.authorName?.isNotEmpty ?? false) return this.authorName!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrSortTitle {
    if (this.sortName?.isNotEmpty ?? false) return this.sortName!;
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

  String get harbrDateAdded {
    if (this.added == null) {
      return 'harbr.Unknown'.tr();
    }
    return DateFormat('MMMM dd, y').format(this.added!.toLocal());
  }

  String get harbrSizeOnDisk {
    if (this.statistics?.sizeOnDisk == null) {
      return '0.0 B';
    }
    return this.statistics!.sizeOnDisk.asBytes(decimals: 1);
  }

  String get harbrBookFileCount {
    return (this.statistics?.bookFileCount ?? 0).toString();
  }

  String get harbrBookCount {
    return (this.statistics?.bookCount ?? 0).toString();
  }

  String get harbrTotalBookCount {
    return (this.statistics?.totalBookCount ?? 0).toString();
  }

  String get harbrPercentOfBooks {
    double percent = this.statistics?.percentOfBooks ?? 0;
    return '${percent.toStringAsFixed(0)}%';
  }

  String get harbrBookProgress {
    int bookFileCount = this.statistics?.bookFileCount ?? 0;
    int bookCount = this.statistics?.bookCount ?? 0;
    double percent = this.statistics?.percentOfBooks ?? 0;
    return '$bookFileCount/$bookCount (${percent.toStringAsFixed(0)}%)';
  }

  String harbrTags(List<ReadarrTag> tags) {
    if (tags.isNotEmpty) return tags.map<String>((t) => t.label!).join('\n');
    return HarbrUI.TEXT_EMDASH;
  }

  /// Creates a clone of the [ReadarrAuthor] object (deep copy).
  ReadarrAuthor clone() => ReadarrAuthor.fromJson(this.toJson());
}
