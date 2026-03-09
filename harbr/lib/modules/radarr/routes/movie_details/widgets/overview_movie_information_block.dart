import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMovieDetailsOverviewInformationBlock extends StatelessWidget {
  final RadarrMovie? movie;
  final RadarrQualityProfile? qualityProfile;
  final List<RadarrTag> tags;

  const RadarrMovieDetailsOverviewInformationBlock({
    Key? key,
    required this.movie,
    required this.qualityProfile,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
          title: 'monitoring',
          body: (movie?.monitored ?? false) ? 'Yes' : 'No',
        ),
        HarbrTableContent(title: 'path', body: movie?.path),
        HarbrTableContent(title: 'quality', body: qualityProfile?.name),
        HarbrTableContent(
          title: 'availability',
          body: movie?.harbrMinimumAvailability,
        ),
        HarbrTableContent(title: 'tags', body: movie?.harbrTags(tags)),
        HarbrTableContent(title: '', body: ''),
        HarbrTableContent(title: 'status', body: movie?.status?.readable),
        HarbrTableContent(title: 'in cinemas', body: movie?.harbrInCinemasOn()),
        HarbrTableContent(
          title: 'digital',
          body: movie?.harbrDigitalReleaseDate(),
        ),
        HarbrTableContent(
          title: 'physical',
          body: movie?.harbrPhysicalReleaseDate(),
        ),
        HarbrTableContent(title: 'added on', body: movie?.harbrDateAdded()),
        HarbrTableContent(title: '', body: ''),
        HarbrTableContent(title: 'year', body: movie?.harbrYear),
        HarbrTableContent(title: 'studio', body: movie?.harbrStudio),
        HarbrTableContent(title: 'runtime', body: movie?.harbrRuntime),
        HarbrTableContent(title: 'rating', body: movie?.certification),
        HarbrTableContent(title: 'genres', body: movie?.harbrGenres),
        HarbrTableContent(
            title: 'alternate titles', body: movie?.harbrAlternateTitles),
      ],
    );
  }
}
