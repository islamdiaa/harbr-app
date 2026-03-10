import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

enum _RadarrCatalogueTileType {
  TILE,
  GRID,
}

class RadarrCatalogueTile extends StatefulWidget {
  static const double itemExtent = 160.0;

  final RadarrMovie movie;
  final RadarrQualityProfile? profile;
  final _RadarrCatalogueTileType type;

  const RadarrCatalogueTile({
    Key? key,
    required this.movie,
    required this.profile,
    this.type = _RadarrCatalogueTileType.TILE,
  }) : super(key: key);

  const RadarrCatalogueTile.grid({
    Key? key,
    required this.movie,
    required this.profile,
    this.type = _RadarrCatalogueTileType.GRID,
  }) : super(key: key);

  @override
  State<RadarrCatalogueTile> createState() => _State();
}

class _State extends State<RadarrCatalogueTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<RadarrState, Future<List<RadarrMovie>>?>(
      selector: (_, state) => state.movies,
      builder: (context, movies, _) {
        switch (widget.type) {
          case _RadarrCatalogueTileType.TILE:
            return _buildCard();
          case _RadarrCatalogueTileType.GRID:
            return _buildGridTile();
          default:
            throw Exception('Invalid _RadarrCatalogueTileType');
        }
      },
    );
  }

  Widget _buildCard() {
    Widget content = Opacity(
      opacity: widget.movie.monitored! ? 1.0 : HarbrTokens.opacityDisabled,
      child: Row(
        children: [
          HarbrPoster(
            url: context.read<RadarrState>().getPosterURL(widget.movie.id),
            headers: context.read<RadarrState>().headers,
            placeholderIcon: HarbrIcons.VIDEO_CAM,
            size: PosterSize.xl,
            overlayWidgets: [
              Positioned(
                bottom: 4,
                left: 4,
                child: _buildStatusBadge(),
              ),
            ],
          ),
          const SizedBox(width: HarbrTokens.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.harbr.onSurface,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _buildSubtitleText(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.harbr.onSurfaceDim,
                    fontSize: 13.0,
                  ),
                ),
                if (widget.movie.overview?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.movie.overview!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.harbr.onSurfaceDim,
                      fontSize: 12.0,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Wrap(
                  spacing: HarbrTokens.xs,
                  runSpacing: HarbrTokens.xs,
                  children: _buildMetaChips(),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return HarbrSurface(
      showBorder: true,
      borderRadius: HarbrTokens.borderRadiusXxl,
      margin: HarbrTokens.paddingCard,
      padding: HarbrTokens.paddingMd,
      onTap: _onTap,
      onLongPress: _onLongPress,
      child: content,
    );
  }

  String _buildSubtitleText() {
    final parts = <String>[];
    if (widget.movie.year != null && widget.movie.year != 0) {
      parts.add(widget.movie.year.toString());
    }
    parts.add(widget.movie.harbrRuntime);

    final profile = widget.profile?.name;
    if (profile != null) parts.add(profile);

    return parts.join(' ${HarbrUI.TEXT_BULLET} ');
  }

  Widget _buildStatusBadge() {
    if (widget.movie.hasFile!) {
      return HarbrStatusBadge(
        type: StatusType.downloaded,
        label: widget.movie.harbrFileSize,
      );
    }
    return const HarbrStatusBadge(type: StatusType.missing);
  }

  List<Widget> _buildMetaChips() {
    return [
      HarbrMetaChip(
        icon: Icons.calendar_today,
        label: widget.movie.harbrYear,
      ),
      HarbrMetaChip(
        icon: Icons.schedule,
        label: widget.movie.harbrRuntime,
      ),
      HarbrMetaChip(
        icon: Icons.business,
        label: widget.movie.harbrStudio,
      ),
    ];
  }

  Widget _buildGridTile() {
    RadarrMoviesSorting _sorting = context.read<RadarrState>().moviesSortType;
    return HarbrGridBlock(
      key: ObjectKey(widget.movie),
      backgroundUrl: context.read<RadarrState>().getFanartURL(widget.movie.id),
      posterUrl: context.read<RadarrState>().getPosterURL(widget.movie.id),
      posterHeaders: context.read<RadarrState>().headers,
      backgroundHeaders: context.read<RadarrState>().headers,
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      title: widget.movie.title,
      subtitle: TextSpan(text: _sorting.value(widget.movie, widget.profile)),
      disabled: !widget.movie.monitored!,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  Future<void> _onTap() async {
    RadarrRoutes.MOVIE.go(params: {
      'movie': widget.movie.id!.toString(),
    });
  }

  Future<void> _onLongPress() async {
    Tuple2<bool, RadarrMovieSettingsType?> values =
        await RadarrDialogs().movieSettings(context, widget.movie);
    if (values.item1) values.item2!.execute(context, widget.movie);
  }
}
