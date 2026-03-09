import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrMissingTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(3);

  final RadarrMovie movie;
  final RadarrQualityProfile? profile;

  const RadarrMissingTile({
    Key? key,
    required this.movie,
    required this.profile,
  }) : super(key: key);

  @override
  State<RadarrMissingTile> createState() => _State();
}

class _State extends State<RadarrMissingTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<RadarrState, Future<List<RadarrMovie>>?>(
      selector: (_, state) => state.missing,
      builder: (context, missing, _) => HarbrBlock(
        backgroundUrl:
            context.read<RadarrState>().getFanartURL(widget.movie.id),
        posterUrl: context.read<RadarrState>().getPosterURL(widget.movie.id),
        posterHeaders: context.read<RadarrState>().headers,
        posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
        disabled: !widget.movie.monitored!,
        title: widget.movie.title,
        body: [
          _subtitle1(),
          _subtitle2(),
          _subtitle3(),
        ],
        trailing: _trailing(),
        onTap: _onTap,
      ),
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
    String? _days = widget.movie.harbrEarlierReleaseDate?.asDaysDifference();
    return TextSpan(
        style: const TextStyle(
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          color: HarbrColours.red,
        ),
        text: _days == null
            ? 'radarr.Released'.tr()
            : _days == 'Today'
                ? 'radarr.ReleasedToday'.tr()
                : 'Released $_days Ago');
  }

  HarbrIconButton _trailing() {
    return HarbrIconButton(
      icon: Icons.search_rounded,
      onPressed: () async => RadarrAPIHelper().automaticSearch(
          context: context,
          movieId: widget.movie.id!,
          title: widget.movie.title!),
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
