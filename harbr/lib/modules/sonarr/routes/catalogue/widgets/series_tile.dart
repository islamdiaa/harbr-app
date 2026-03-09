import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

enum _SonarrSeriesTileType {
  TILE,
  GRID,
}

class SonarrSeriesTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(3);

  final SonarrSeries series;
  final SonarrQualityProfile? profile;
  final _SonarrSeriesTileType type;

  const SonarrSeriesTile({
    Key? key,
    required this.series,
    required this.profile,
    this.type = _SonarrSeriesTileType.TILE,
  }) : super(key: key);

  const SonarrSeriesTile.grid({
    Key? key,
    required this.series,
    required this.profile,
    this.type = _SonarrSeriesTileType.GRID,
  }) : super(key: key);

  @override
  State<SonarrSeriesTile> createState() => _State();
}

class _State extends State<SonarrSeriesTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<SonarrState, Future<Map<int?, SonarrSeries>>?>(
      selector: (_, state) => state.series,
      builder: (context, series, _) {
        switch (widget.type) {
          case _SonarrSeriesTileType.TILE:
            return _buildMediaRow();
          case _SonarrSeriesTileType.GRID:
            return _buildGridTile();
          default:
            throw Exception('Invalid _SonarrSeriesTileType');
        }
      },
    );
  }

  Widget _buildMediaRow() {
    return HarbrMediaRow(
      key: ObjectKey(widget.series),
      poster: HarbrPoster(
        url: context.read<SonarrState>().getPosterURL(widget.series.id),
        headers: context.read<SonarrState>().headers,
        placeholderIcon: HarbrIcons.VIDEO_CAM,
        size: PosterSize.lg,
      ),
      title: widget.series.title ?? '',
      subtitle: _buildSubtitleText(),
      status: _buildStatusBadge(),
      metadata: _buildMetaChips(),
      disabled: !widget.series.monitored!,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  String _buildSubtitleText() {
    final parts = <String>[];
    parts.add(widget.series.harbrSeriesType);

    final profile = widget.profile?.name;
    if (profile != null) {
      parts.add(profile);
    } else {
      parts.add(HarbrUI.TEXT_EMDASH);
    }

    final sorting = context.read<SonarrState>().seriesSortType;
    if (sorting == SonarrSeriesSorting.DATE_ADDED) {
      parts.add(widget.series.harbrDateAdded);
    } else if (sorting == SonarrSeriesSorting.PREVIOUS_AIRING) {
      parts.add(widget.series.harbrPreviousAiring());
    } else {
      parts.add(widget.series.harbrNextAiring());
    }

    return parts.join(' ${HarbrUI.TEXT_BULLET} ');
  }

  Widget _buildStatusBadge() {
    final percentage = widget.series.harbrPercentageComplete;
    if (percentage >= 100) {
      return HarbrStatusBadge(
        type: StatusType.downloaded,
        label: widget.series.harbrEpisodeCount,
      );
    }
    if (percentage > 0) {
      return HarbrStatusBadge(
        type: StatusType.queued,
        label: widget.series.harbrEpisodeCount,
      );
    }
    return HarbrStatusBadge(
      type: StatusType.missing,
      label: widget.series.harbrEpisodeCount,
    );
  }

  List<Widget> _buildMetaChips() {
    return [
      HarbrMetaChip(
        icon: Icons.tv,
        label: widget.series.harbrNetwork,
      ),
      HarbrMetaChip(
        icon: Icons.calendar_today,
        label: widget.series.harbrYear,
      ),
      HarbrMetaChip(
        icon: Icons.folder,
        label: widget.series.harbrsonCount,
      ),
      HarbrMetaChip(
        icon: Icons.storage,
        label: widget.series.harbrSizeOnDisk,
      ),
    ];
  }

  Widget _buildGridTile() {
    SonarrSeriesSorting _sorting = context.read<SonarrState>().seriesSortType;
    return HarbrGridBlock(
      key: ObjectKey(widget.series),
      backgroundUrl: context.read<SonarrState>().getFanartURL(widget.series.id),
      posterUrl: context.read<SonarrState>().getPosterURL(widget.series.id),
      posterHeaders: context.read<SonarrState>().headers,
      backgroundHeaders: context.read<SonarrState>().headers,
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      title: widget.series.title,
      subtitle: TextSpan(text: _sorting.value(widget.series, widget.profile)),
      disabled: !widget.series.monitored!,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  Future<void> _onTap() async {
    SonarrRoutes.SERIES.go(params: {
      'series': widget.series.id!.toString(),
    });
  }

  Future<void> _onLongPress() async {
    Tuple2<bool, SonarrSeriesSettingsType?> values =
        await SonarrDialogs().seriesSettings(
      context,
      widget.series,
    );
    if (values.item1) values.item2!.execute(context, widget.series);
  }
}
