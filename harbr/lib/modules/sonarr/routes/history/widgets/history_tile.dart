import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

enum SonarrHistoryTileType {
  ALL,
  SERIES,
  SEASON,
  EPISODE,
}

class SonarrHistoryTile extends StatelessWidget {
  final SonarrHistoryRecord history;
  final SonarrHistoryTileType type;
  final SonarrSeries? series;
  final SonarrEpisode? episode;

  const SonarrHistoryTile({
    Key? key,
    required this.history,
    required this.type,
    this.series,
    this.episode,
  }) : super(key: key);

  bool _hasEpisodeInfo() {
    if (history.episode != null || episode != null) return true;
    return false;
  }

  bool _hasLongPressAction() {
    switch (type) {
      case SonarrHistoryTileType.ALL:
        return true;
      case SonarrHistoryTileType.SERIES:
        return _hasEpisodeInfo();
      case SonarrHistoryTileType.SEASON:
      case SonarrHistoryTileType.EPISODE:
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isThreeLine =
        _hasEpisodeInfo() && type != SonarrHistoryTileType.EPISODE;
    return HarbrExpandableListTile(
      title: type != SonarrHistoryTileType.ALL
          ? history.sourceTitle!
          : series?.title ?? HarbrUI.TEXT_EMDASH,
      collapsedSubtitles: [
        if (_isThreeLine) _subtitle1(),
        _subtitle2(),
        _subtitle3(),
      ],
      expandedHighlightedNodes: [
        HarbrHighlightedNode(
          text: history.eventType?.readable ?? HarbrUI.TEXT_EMDASH,
          backgroundColor: history.eventType!.harbrColour(),
        ),
        if (history.harbrHasPreferredWordScore())
          HarbrHighlightedNode(
            text: history.harbrPreferredWordScore(),
            backgroundColor: HarbrColours.purple,
          ),
        if (history.episode?.seasonNumber != null)
          HarbrHighlightedNode(
            text: 'sonarr.SeasonNumber'.tr(
              args: [history.episode!.seasonNumber.toString()],
            ),
            backgroundColor: HarbrColours.blueGrey,
          ),
        if (episode?.seasonNumber != null)
          HarbrHighlightedNode(
            text: 'sonarr.SeasonNumber'.tr(
              args: [episode?.seasonNumber?.toString() ?? HarbrUI.TEXT_EMDASH],
            ),
            backgroundColor: HarbrColours.blueGrey,
          ),
        if (history.episode?.episodeNumber != null)
          HarbrHighlightedNode(
            text: 'sonarr.EpisodeNumber'.tr(
              args: [history.episode!.episodeNumber.toString()],
            ),
            backgroundColor: HarbrColours.blueGrey,
          ),
        if (episode?.episodeNumber != null)
          HarbrHighlightedNode(
            text: 'sonarr.EpisodeNumber'.tr(
              args: [episode?.episodeNumber?.toString() ?? HarbrUI.TEXT_EMDASH],
            ),
            backgroundColor: HarbrColours.blueGrey,
          ),
      ],
      expandedTableContent: history.eventType?.harbrTableContent(
            history: history,
            showSourceTitle: type != SonarrHistoryTileType.ALL,
          ) ??
          [],
      onLongPress:
          _hasLongPressAction() ? () async => _onLongPress(context) : null,
    );
  }

  Future<void> _onLongPress(BuildContext context) async {
    switch (type) {
      case SonarrHistoryTileType.ALL:
        final id = history.series?.id ?? series?.id ?? -1;
        return SonarrRoutes.SERIES.go(params: {
          'series': id.toString(),
        });
      case SonarrHistoryTileType.SERIES:
        if (_hasEpisodeInfo()) {
          final seriesId =
              history.seriesId ?? history.series?.id ?? series!.id ?? -1;
          final seasonNum =
              history.episode?.seasonNumber ?? episode?.seasonNumber ?? -1;
          return SonarrRoutes.SERIES_SEASON.go(params: {
            'series': seriesId.toString(),
            'season': seasonNum.toString(),
          });
        }
        break;
      default:
        break;
    }
  }

  TextSpan _subtitle1() {
    return TextSpan(children: [
      TextSpan(
        text: history.harbrsonEpisode() ??
            episode?.harbrsonEpisode() ??
            HarbrUI.TEXT_EMDASH,
      ),
      const TextSpan(text: ': '),
      TextSpan(
        text: history.episode?.title ?? episode?.title ?? HarbrUI.TEXT_EMDASH,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
    ]);
  }

  TextSpan _subtitle2() {
    return TextSpan(
      text: [
        history.date?.asAge() ?? HarbrUI.TEXT_EMDASH,
        history.date?.asDateTime() ?? HarbrUI.TEXT_EMDASH,
      ].join(HarbrUI.TEXT_BULLET.pad()),
    );
  }

  TextSpan _subtitle3() {
    return TextSpan(
      text: history.eventType?.harbrReadable(history) ?? HarbrUI.TEXT_EMDASH,
      style: TextStyle(
        color: history.eventType?.harbrColour() ?? HarbrColours.blueGrey,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
    );
  }
}
