import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMovieDetailsOverviewDescriptionTile extends StatelessWidget {
  final RadarrMovie? movie;

  const RadarrMovieDetailsOverviewDescriptionTile({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      backgroundUrl: context.read<RadarrState>().getFanartURL(movie!.id),
      posterUrl: context.read<RadarrState>().getPosterURL(movie!.id),
      posterHeaders: context.read<RadarrState>().headers,
      title: movie!.title,
      body: [
        HarbrTextSpan.extended(
          text: movie!.overview == null || movie!.overview!.isEmpty
              ? 'sonarr.NoSummaryAvailable'.tr()
              : movie!.overview,
        ),
      ],
      customBodyMaxLines: 3,
      onTap: () async =>
          HarbrDialogs().textPreview(context, movie!.title, movie!.overview!),
    );
  }
}
