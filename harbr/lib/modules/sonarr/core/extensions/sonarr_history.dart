import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrHistoryRecordHarbrExtension on SonarrHistoryRecord {
  String harbrSeriesTitle() {
    return this.series?.title ?? HarbrUI.TEXT_EMDASH;
  }

  String? harbrsonEpisode() {
    if (this.episode == null) return null;
    String season = this.episode?.seasonNumber != null
        ? 'sonarr.SeasonNumber'.tr(
            args: [this.episode!.seasonNumber.toString()],
          )
        : 'harbr.Unknown'.tr();
    String episode = this.episode?.episodeNumber != null
        ? 'sonarr.EpisodeNumber'.tr(
            args: [this.episode!.episodeNumber.toString()],
          )
        : 'harbr.Unknown'.tr();
    return '$season ${HarbrUI.TEXT_BULLET} $episode';
  }

  bool harbrHasPreferredWordScore() {
    return (this.data!['preferredWordScore'] ?? '0') != '0';
  }

  String harbrPreferredWordScore() {
    if (harbrHasPreferredWordScore()) {
      int? _preferredScore = int.tryParse(this.data!['preferredWordScore']);
      if (_preferredScore != null) {
        String _prefix = _preferredScore > 0 ? '+' : '';
        return '$_prefix${this.data!['preferredWordScore']}';
      }
    }
    return HarbrUI.TEXT_EMDASH;
  }
}
