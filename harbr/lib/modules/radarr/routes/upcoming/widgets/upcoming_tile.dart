import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrUpcomingTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(3);

  final RadarrMovie movie;
  final RadarrQualityProfile? profile;

  const RadarrUpcomingTile({
    Key? key,
    required this.movie,
    required this.profile,
  }) : super(key: key);

  @override
  State<RadarrUpcomingTile> createState() => _State();
}

class _State extends State<RadarrUpcomingTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<RadarrState, Future<List<RadarrMovie>>?>(
      selector: (_, state) => state.missing,
      builder: (context, missing, _) {
        return HarbrBlock(
          title: widget.movie.title,
          body: [
            _subtitle1(),
            _subtitle2(),
            _subtitle3(),
          ],
          trailing: _trailing(),
          backgroundUrl:
              context.read<RadarrState>().getFanartURL(widget.movie.id),
          posterHeaders: context.read<RadarrState>().headers,
          posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
          posterIsSquare: false,
          posterUrl: context.read<RadarrState>().getPosterURL(widget.movie.id),
          onTap: _onTap,
          disabled: !widget.movie.monitored!,
        );
      },
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

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(text: widget.profile!.harbrName),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.movie.harbrMinimumAvailability),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.movie.harbrReleaseDate),
      ],
    );
  }

  TextSpan _subtitle3() {
    Color color;
    String? _days;
    String type;
    if (widget.movie.harbrIsInCinemas && !widget.movie.harbrIsReleased) {
      color = HarbrColours.blue;
      _days = widget.movie.harbrEarlierReleaseDate?.asDaysDifference();
      type = 'release';
    } else if (!widget.movie.harbrIsInCinemas && !widget.movie.harbrIsReleased) {
      color = HarbrColours.orange;
      _days = widget.movie.inCinemas?.asDaysDifference();
      type = 'cinema';
    } else {
      color = HarbrColours.grey;
      _days = HarbrUI.TEXT_EMDASH;
      type = 'unknown';
    }
    return TextSpan(
      style: TextStyle(
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        color: color,
      ),
      children: [
        if (type == 'release')
          TextSpan(
            text: _days == null
                ? 'radarr.AvailabilityUnknown'.tr()
                : _days == 'Today'
                    ? 'radarr.AvailableToday'.tr()
                    : 'radarr.AvailableIn'.tr(args: [_days]),
          ),
        if (type == 'cinema')
          TextSpan(
            text: _days == null
                ? 'radarr.CinemaDateUnknown'.tr()
                : _days == 'Today'
                    ? 'radarr.InCinemasToday'.tr()
                    : 'radarr.InCinemasIn'.tr(args: [_days]),
          ),
        if (type == 'unknown') TextSpan(text: _days),
      ],
    );
  }

  HarbrIconButton _trailing() {
    return HarbrIconButton(
      icon: Icons.search_rounded,
      onPressed: () async => RadarrAPIHelper().automaticSearch(
        context: context,
        movieId: widget.movie.id!,
        title: widget.movie.title!,
      ),
      onLongPress: () => RadarrRoutes.MOVIE_RELEASES.go(params: {
        'movie': widget.movie.id!.toString(),
      }),
    );
  }

  Future<void> _onTap() async {
    RadarrRoutes.MOVIE.go(params: {
      'movie': widget.movie.id!.toString(),
    });
  }
}
