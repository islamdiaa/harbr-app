import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrSeriesSeasonExtension on SonarrSeriesSeason {
  String get harbrTitle {
    if (this.seasonNumber == 0) return 'sonarr.Specials'.tr();
    return 'sonarr.SeasonNumber'.tr(args: [
      this.seasonNumber?.toString() ?? 'harbr.Unknown'.tr(),
    ]);
  }

  int get harbrPercentageComplete {
    int _total = this.statistics?.episodeCount ?? 0;
    int _available = this.statistics?.episodeFileCount ?? 0;
    return _total == 0 ? 0 : ((_available / _total) * 100).round();
  }

  String get harbrEpisodesAvailable {
    return '${this.statistics?.episodeFileCount ?? 0}/${this.statistics?.episodeCount ?? 0}';
  }
}
