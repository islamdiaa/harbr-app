import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/readarr.dart';

extension ReadarrReleaseExtension on ReadarrRelease {
  String get harbrTitle {
    if (this.title?.isNotEmpty ?? false) return this.title!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrAge {
    if (this.age == null) return HarbrUI.TEXT_EMDASH;
    if (this.age == 0) return '<1d';
    return '${this.age}d';
  }

  String get harbrSize {
    if (this.size == null) return '0.0 B';
    return this.size.asBytes(decimals: 1);
  }

  String get harbrIndexer {
    if (this.indexer?.isNotEmpty ?? false) return this.indexer!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrSeeders {
    if (this.protocol == 'torrent') {
      return (this.seeders ?? 0).toString();
    }
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrLeechers {
    if (this.protocol == 'torrent') {
      return (this.leechers ?? 0).toString();
    }
    return HarbrUI.TEXT_EMDASH;
  }
}
