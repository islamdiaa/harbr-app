import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

class SonarrMissingTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(3);

  final SonarrMissingRecord record;
  final SonarrSeries? series;

  const SonarrMissingTile({
    Key? key,
    required this.record,
    this.series,
  }) : super(key: key);

  @override
  State<SonarrMissingTile> createState() => _State();
}

class _State extends State<SonarrMissingTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      backgroundUrl:
          context.read<SonarrState>().getFanartURL(widget.record.seriesId),
      posterUrl:
          context.read<SonarrState>().getPosterURL(widget.record.seriesId),
      posterHeaders: context.read<SonarrState>().headers,
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      title: widget.record.series?.title ??
          widget.series?.title ??
          HarbrUI.TEXT_EMDASH,
      body: [
        _subtitle1(),
        _subtitle2(),
        _subtitle3(),
      ],
      disabled: !widget.record.monitored!,
      onTap: _onTap,
      onLongPress: _onLongPress,
      trailing: _trailing(),
    );
  }

  Widget _trailing() {
    return HarbrIconButton(
      icon: Icons.search_rounded,
      onPressed: _trailingOnTap,
      onLongPress: _trailingOnLongPress,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(
            text: widget.record.seasonNumber == 0
                ? 'Specials'
                : 'Season ${widget.record.seasonNumber}'),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: 'Episode ${widget.record.episodeNumber}'),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      style: const TextStyle(
        fontStyle: FontStyle.italic,
      ),
      text: widget.record.title ?? 'harbr.Unknown'.tr(),
    );
  }

  TextSpan _subtitle3() {
    return TextSpan(
      style: const TextStyle(
        fontSize: HarbrUI.FONT_SIZE_H3,
        color: HarbrColours.red,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
      children: [
        TextSpan(
            text: widget.record.airDateUtc == null
                ? 'Aired'
                : 'Aired ${widget.record.airDateUtc!.toLocal().asAge()}'),
      ],
    );
  }

  Future<void> _onTap() async {
    SonarrRoutes.SERIES_SEASON.go(params: {
      'series': (widget.record.seriesId ?? -1).toString(),
      'season': (widget.record.seasonNumber ?? -1).toString(),
    });
  }

  Future<void> _onLongPress() async {
    SonarrRoutes.SERIES.go(params: {
      'series': widget.record.seriesId!.toString(),
    });
  }

  Future<void> _trailingOnTap() async {
    Provider.of<SonarrState>(context, listen: false)
        .api!
        .command
        .episodeSearch(episodeIds: [widget.record.id!])
        .then((_) => showHarbrSuccessSnackBar(
              title: 'Searching for Episode...',
              message: widget.record.title,
            ))
        .catchError((error, stack) {
          HarbrLogger().error(
              'Failed to search for episode: ${widget.record.id}',
              error,
              stack);
          showHarbrErrorSnackBar(
            title: 'Failed to Search',
            error: error,
          );
        });
  }

  Future<void> _trailingOnLongPress() async {
    return SonarrRoutes.RELEASES.go(queryParams: {
      'episode': widget.record.id!.toString(),
    });
  }
}
