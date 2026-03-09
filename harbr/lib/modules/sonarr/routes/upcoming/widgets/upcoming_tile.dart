import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

class SonarrUpcomingTile extends StatefulWidget {
  final SonarrCalendar record;
  final SonarrSeries? series;

  const SonarrUpcomingTile({
    Key? key,
    required this.record,
    this.series,
  }) : super(key: key);

  @override
  State<SonarrUpcomingTile> createState() => _State();
}

class _State extends State<SonarrUpcomingTile> {
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

  Widget _trailing() => HarbrIconButton(
        text: widget.record.harbrAirTime,
        onPressed: _trailingOnPressed,
        onLongPress: _trailingOnLongPress,
      );

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
      style: const TextStyle(fontStyle: FontStyle.italic),
      children: [
        TextSpan(text: widget.record.title ?? 'Unknown Title'),
      ],
    );
  }

  TextSpan _subtitle3() {
    Color color = widget.record.hasFile!
        ? HarbrColours.accent
        : widget.record.harbrHasAired
            ? HarbrColours.red
            : HarbrColours.blue;
    return TextSpan(
      style: TextStyle(
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        color: color,
      ),
      children: [
        if (!widget.record.hasFile!)
          TextSpan(text: widget.record.harbrHasAired ? 'Missing' : 'Unaired'),
        if (widget.record.hasFile!)
          TextSpan(
            text:
                'Downloaded (${widget.record.episodeFile?.quality?.quality?.name ?? 'Unknown'})',
          ),
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

  Future<void> _trailingOnPressed() async {
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
    SonarrRoutes.RELEASES.go(queryParams: {
      'episode': widget.record.id.toString(),
    });
  }
}
