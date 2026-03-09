import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrAddMovieSearchResultTile extends StatefulWidget {
  final RadarrMovie movie;
  final bool onTapShowOverview;
  final bool exists;
  final bool isExcluded;

  const RadarrAddMovieSearchResultTile({
    Key? key,
    required this.movie,
    required this.exists,
    required this.isExcluded,
    this.onTapShowOverview = false,
  }) : super(key: key);

  @override
  State<RadarrAddMovieSearchResultTile> createState() => _State();
}

class _State extends State<RadarrAddMovieSearchResultTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrMediaRow(
      poster: HarbrPoster(
        url: widget.movie.remotePoster,
        headers: context.watch<RadarrState>().headers,
        placeholderIcon: HarbrIcons.VIDEO_CAM,
        size: PosterSize.lg,
      ),
      title: widget.movie.title ?? HarbrUI.TEXT_EMDASH,
      subtitle: _buildSubtitle(),
      status: _statusBadge(),
      metadata: _metaChips(),
      disabled: widget.exists,
      onTap: _onTap,
      onLongPress: _onLongPress,
    );
  }

  String _buildSubtitle() {
    String? summary;
    if (widget.movie.overview == null || widget.movie.overview!.isEmpty) {
      summary = 'radarr.NoSummaryIsAvailable'.tr();
    } else {
      summary = widget.movie.overview;
    }
    return summary ?? '';
  }

  Widget? _statusBadge() {
    if (widget.exists) {
      return const HarbrStatusBadge(
        type: StatusType.monitored,
        label: 'In Library',
      );
    }
    if (widget.isExcluded) {
      return const HarbrStatusBadge(
        type: StatusType.error,
        label: 'Excluded',
      );
    }
    return null;
  }

  List<Widget> _metaChips() {
    return [
      HarbrMetaChip(
        icon: Icons.calendar_today_rounded,
        label: widget.movie.harbrYear,
      ),
      HarbrMetaChip(
        icon: Icons.schedule_rounded,
        label: widget.movie.harbrRuntime,
      ),
      HarbrMetaChip(
        icon: Icons.movie_rounded,
        label: widget.movie.harbrStudio,
      ),
      if (widget.movie.certification != null &&
          widget.movie.certification!.isNotEmpty)
        HarbrMetaChip(
          icon: Icons.verified_rounded,
          label: widget.movie.certification!,
        ),
    ];
  }

  Future<void> _onTap() async {
    if (widget.onTapShowOverview) {
      HarbrDialogs().textPreview(context, widget.movie.title,
          widget.movie.overview ?? 'radarr.NoSummaryIsAvailable'.tr());
    } else if (widget.exists) {
      RadarrRoutes.MOVIE.go(params: {
        'movie': widget.movie.id!.toString(),
      });
    } else {
      RadarrRoutes.ADD_MOVIE_DETAILS.go(extra: widget.movie, queryParams: {
        'isDiscovery': 'false',
      });
    }
  }

  Future<void>? _onLongPress() async =>
      widget.movie.tmdbId?.toString().openTmdbMovie();
}
