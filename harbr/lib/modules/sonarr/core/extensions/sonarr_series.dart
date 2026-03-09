import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/int/duration.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrSeriesExtension on SonarrSeries {
  String get harbrRuntime {
    return this.runtime.asVideoDuration();
  }

  String get harbrAlternateTitles {
    if (this.alternateTitles?.isNotEmpty ?? false) {
      return this.alternateTitles!.map((title) => title.title).join('\n');
    }
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrGenres {
    if (this.genres?.isNotEmpty ?? false) return this.genres!.join('\n');
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrNetwork {
    if (this.network?.isNotEmpty ?? false) return this.network!;
    return HarbrUI.TEXT_EMDASH;
  }

  String harbrTags(List<SonarrTag> tags) {
    if (tags.isNotEmpty) return tags.map<String>((t) => t.label!).join('\n');
    return HarbrUI.TEXT_EMDASH;
  }

  int get harbrPercentageComplete {
    int _total = this.statistics?.episodeCount ?? 0;
    int _available = this.statistics?.episodeFileCount ?? 0;
    return _total == 0 ? 0 : ((_available / _total) * 100).round();
  }

  String harbrNextAiring([bool short = false]) {
    if (this.status == 'ended') return 'sonarr.SeriesEnded'.tr();
    if (this.nextAiring == null) return 'harbr.Unknown'.tr();
    return this.nextAiring!.asDateTime(
          showSeconds: false,
          delimiter: '@'.pad(),
          shortenMonth: short,
        );
  }

  String harbrPreviousAiring([bool short = false]) {
    if (this.previousAiring == null) return HarbrUI.TEXT_EMDASH;
    return this.previousAiring!.asDateTime(
          showSeconds: false,
          delimiter: '@'.pad(),
          shortenMonth: short,
        );
  }

  String get harbrDateAdded {
    if (this.added == null) {
      return 'harbr.Unknown'.tr();
    }
    return DateFormat('MMMM dd, y').format(this.added!.toLocal());
  }

  String get harbrDateAddedShort {
    if (this.added == null) {
      return 'harbr.Unknown'.tr();
    }
    return DateFormat('MMM dd, y').format(this.added!.toLocal());
  }

  String get harbrYear {
    if (this.year != null && this.year != 0) return this.year.toString();
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrAirTime {
    if (this.previousAiring != null) {
      return HarbrDatabase.USE_24_HOUR_TIME.read()
          ? DateFormat.Hm().format(this.previousAiring!.toLocal())
          : DateFormat('hh:mm a').format(this.previousAiring!.toLocal());
    }
    if (this.airTime == null) {
      return 'harbr.Unknown'.tr();
    }
    return this.airTime;
  }

  String get harbrSeriesType {
    if (this.seriesType == null) return 'harbr.Unknown'.tr();
    return this.seriesType!.value!.toTitleCase();
  }

  String get harbrsonCount {
    if (this.statistics?.seasonCount == null) {
      return 'harbr.Unknown'.tr();
    }
    return this.statistics!.seasonCount == 1
        ? 'sonarr.OneSeason'.tr()
        : 'sonarr.ManySeasons'.tr(
            args: [this.statistics!.seasonCount.toString()],
          );
  }

  String get harbrSizeOnDisk {
    if (this.statistics?.sizeOnDisk == null) {
      return '0.0 B';
    }
    return this.statistics!.sizeOnDisk.asBytes(decimals: 1);
  }

  String? get harbrOverview {
    if (this.overview == null || this.overview!.isEmpty) {
      return 'sonarr.NoSummaryAvailable'.tr();
    }
    return this.overview;
  }

  String get harbrAirsOn {
    if (this.status == 'ended') {
      return 'Aired on ${this.network ?? HarbrUI.TEXT_EMDASH}';
    }
    return '${this.harbrAirTime ?? 'Unknown Time'} on ${this.network ?? HarbrUI.TEXT_EMDASH}';
  }

  String get harbrEpisodeCount {
    int episodeFileCount = this.statistics?.episodeFileCount ?? 0;
    int episodeCount = this.statistics?.episodeCount ?? 0;
    int percentage = this.harbrPercentageComplete;
    return '$episodeFileCount/$episodeCount ($percentage%)';
  }

  /// Creates a clone of the [SonarrSeries] object (deep copy).
  SonarrSeries clone() => SonarrSeries.fromJson(this.toJson());

  /// Copies changes from a [SonarrSeriesEditState] state object back to the [SonarrSeries] object.
  SonarrSeries updateEdits(SonarrSeriesEditState edits) {
    SonarrSeries series = this.clone();
    series.monitored = edits.monitored;
    series.seasonFolder = edits.useSeasonFolders;
    series.path = edits.seriesPath;
    series.qualityProfileId = edits.qualityProfile?.id ?? this.qualityProfileId;
    series.seriesType = edits.seriesType ?? this.seriesType;
    series.tags = edits.tags?.map((t) => t.id!).toList() ?? [];
    if (edits.languageProfile != null) {
      series.languageProfileId =
          edits.languageProfile!.id ?? this.languageProfileId;
    }

    return series;
  }
}
