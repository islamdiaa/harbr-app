import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

class SonarrSeriesAddSearchResultTile extends StatefulWidget {
  static final double extent = HarbrBlock.calculateItemExtent(
    1,
    hasBottom: true,
    bottomHeight: HarbrBlock.SUBTITLE_HEIGHT * 2,
  );

  final SonarrSeries series;
  final bool onTapShowOverview;
  final bool exists;
  final bool isExcluded;

  const SonarrSeriesAddSearchResultTile({
    Key? key,
    required this.series,
    required this.exists,
    required this.isExcluded,
    this.onTapShowOverview = false,
  }) : super(key: key);

  @override
  State<SonarrSeriesAddSearchResultTile> createState() => _State();
}

class _State extends State<SonarrSeriesAddSearchResultTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      backgroundUrl: widget.series.remotePoster,
      posterUrl: widget.series.remotePoster,
      posterHeaders: context.watch<SonarrState>().headers,
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      title: widget.series.title,
      titleColor: widget.isExcluded ? HarbrColours.red : Colors.white,
      disabled: widget.exists,
      body: [_subtitle1()],
      bottom: _subtitle2(),
      bottomHeight: HarbrBlock.SUBTITLE_HEIGHT * 2,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(children: [
      TextSpan(text: widget.series.harbrsonCount),
      TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
      TextSpan(text: widget.series.harbrYear),
      TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
      TextSpan(text: widget.series.harbrNetwork),
    ]);
  }

  Widget _subtitle2() {
    return SizedBox(
      height: HarbrBlock.SUBTITLE_HEIGHT * 2,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: HarbrUI.FONT_SIZE_H3,
            color: HarbrColours.grey,
          ),
          children: [
            HarbrTextSpan.extended(text: widget.series.harbrOverview),
          ],
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Future<void> _onTap() async {
    if (widget.onTapShowOverview) {
      HarbrDialogs().textPreview(
        context,
        widget.series.title,
        widget.series.overview ?? 'sonarr.NoSummaryAvailable'.tr(),
      );
    } else if (widget.exists) {
      SonarrRoutes.SERIES.go(params: {'series': widget.series.id!.toString()});
    } else {
      SonarrRoutes.ADD_SERIES_DETAILS.go(extra: widget.series);
    }
  }

  Future<void>? _onLongPress() async =>
      widget.series.tvdbId?.toString().openTvdbSeries();
}
