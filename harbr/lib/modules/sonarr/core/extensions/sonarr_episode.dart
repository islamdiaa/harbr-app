import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrEpisodeExtension on SonarrEpisode {
  bool _hasAired() {
    return this.airDateUtc?.toLocal().isAfter(DateTime.now()) ?? true;
  }

  /// Creates a clone of the [SonarrEpisode] object (deep copy).
  SonarrEpisode clone() => SonarrEpisode.fromJson(this.toJson());

  String harbrAirDate() {
    if (this.airDateUtc == null) return 'harbr.UnknownDate'.tr();
    return DateFormat.yMMMMd().format(this.airDateUtc!.toLocal());
  }

  String harbrDownloadedQuality(
    SonarrEpisodeFile? file,
    SonarrQueueRecord? queueRecord,
  ) {
    if (queueRecord != null) {
      return [
        queueRecord.harbrPercentage(),
        HarbrUI.TEXT_EMDASH,
        queueRecord.harbrStatusParameters().item1,
      ].join(' ');
    }

    if (!this.hasFile!) {
      if (_hasAired()) return 'sonarr.Unaired'.tr();
      return 'sonarr.Missing'.tr();
    }
    if (file == null) return 'harbr.Unknown'.tr();
    String quality = file.quality?.quality?.name ?? 'harbr.Unknown'.tr();
    String size = file.size?.asBytes() ?? '0.00 B';
    return '$quality ${HarbrUI.TEXT_EMDASH} $size';
  }

  Color harbrDownloadedQualityColor(
    SonarrEpisodeFile? file,
    SonarrQueueRecord? queueRecord,
  ) {
    if (queueRecord != null) {
      return queueRecord.harbrStatusParameters(canBeWhite: false).item3;
    }

    if (!this.hasFile!) {
      if (_hasAired()) return HarbrColours.blue;
      return HarbrColours.red;
    }
    if (file == null) return HarbrColours.blueGrey;
    if (file.qualityCutoffNotMet!) return HarbrColours.orange;
    return HarbrColours.accent;
  }

  String harbrsonEpisode() {
    String season = this.seasonNumber != null
        ? 'sonarr.SeasonNumber'.tr(
            args: [this.seasonNumber.toString()],
          )
        : 'harbr.Unknown'.tr();
    String episode = this.episodeNumber != null
        ? 'sonarr.EpisodeNumber'.tr(
            args: [this.episodeNumber.toString()],
          )
        : 'harbr.Unknown'.tr();
    return '$season ${HarbrUI.TEXT_BULLET} $episode';
  }
}
