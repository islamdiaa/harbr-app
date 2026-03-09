import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

enum _RadarrCatalogueTileType {
  TILE,
  GRID,
}

class RadarrCatalogueTile extends StatefulWidget {
  static final itemExtent = HarbrBlock.calculateItemExtent(2, hasBottom: true);

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
            return _buildMediaRow();
          case _RadarrCatalogueTileType.GRID:
            return _buildGridTile();
          default:
            throw Exception('Invalid _RadarrCatalogueTileType');
        }
      },
    );
  }

  Widget _buildMediaRow() {
    return HarbrMediaRow(
      key: ObjectKey(widget.movie),
      poster: HarbrPoster(
        url: context.read<RadarrState>().getPosterURL(widget.movie.id),
        headers: context.read<RadarrState>().headers,
        placeholderIcon: HarbrIcons.VIDEO_CAM,
        size: PosterSize.lg,
      ),
      title: widget.movie.title ?? '',
      subtitle: _buildSubtitleText(),
      status: _buildStatusBadge(),
      metadata: _buildMetaChips(),
      disabled: !widget.movie.monitored!,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  String _buildSubtitleText() {
    final parts = <String>[];
    final profile = widget.profile?.name;
    if (profile != null) parts.add(profile);
    parts.add(widget.movie.harbrMinimumAvailability);

    final sorting = context.read<RadarrState>().moviesSortType;
    if (sorting == RadarrMoviesSorting.PHYSICAL_RELEASE) {
      parts.add(widget.movie.harbrPhysicalReleaseDate());
    } else if (sorting == RadarrMoviesSorting.DIGITAL_RELEASE) {
      parts.add(widget.movie.harbrDigitalReleaseDate());
    } else if (sorting == RadarrMoviesSorting.IN_CINEMAS) {
      parts.add(widget.movie.harbrInCinemasOn());
    } else {
      parts.add(widget.movie.harbrDateAdded());
    }

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
