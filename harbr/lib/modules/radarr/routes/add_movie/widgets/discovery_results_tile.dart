import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrAddMovieDiscoveryResultTile extends StatefulWidget {
  final RadarrMovie movie;
  final bool onTapShowOverview;

  const RadarrAddMovieDiscoveryResultTile({
    Key? key,
    required this.movie,
    this.onTapShowOverview = false,
  }) : super(key: key);

  @override
  State<RadarrAddMovieDiscoveryResultTile> createState() => _State();
}

class _State extends State<RadarrAddMovieDiscoveryResultTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      backgroundUrl: widget.movie.remotePoster,
      posterUrl: widget.movie.remotePoster,
      posterHeaders: context.watch<RadarrState>().headers,
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      title: widget.movie.title,
      body: [_subtitle1()],
      bottom: _subtitle2(),
      bottomHeight: HarbrBlock.SUBTITLE_HEIGHT * 2,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(text: widget.movie.harbrYear),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.movie.harbrRuntime),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.movie.harbrStudio),
      ],
    );
  }

  Widget _subtitle2() {
    String? summary;
    if (widget.movie.overview == null || widget.movie.overview!.isEmpty) {
      summary = 'radarr.NoSummaryIsAvailable'.tr();
    } else {
      summary = widget.movie.overview;
    }
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
            HarbrTextSpan.extended(text: summary),
          ],
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Future<void> _onTap() async {
    if (widget.onTapShowOverview) {
      HarbrDialogs().textPreview(context, widget.movie.title,
          widget.movie.overview ?? 'radarr.NoSummaryIsAvailable'.tr());
    } else {
      RadarrRoutes.ADD_MOVIE_DETAILS.go(extra: widget.movie, queryParams: {
        'isDiscovery': 'true',
      });
    }
  }

  Future<void>? _onLongPress() async =>
      widget.movie.tmdbId.toString().openTmdbMovie();
}
