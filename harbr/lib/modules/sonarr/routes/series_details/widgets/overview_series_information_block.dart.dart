import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesDetailsOverviewInformationBlock extends StatelessWidget {
  final SonarrSeries? series;
  final SonarrQualityProfile? qualityProfile;
  final SonarrLanguageProfile? languageProfile;
  final List<SonarrTag> tags;

  const SonarrSeriesDetailsOverviewInformationBlock({
    Key? key,
    required this.series,
    required this.qualityProfile,
    required this.languageProfile,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
          title: 'sonarr.Monitoring'.tr(),
          body: (series?.monitored ?? false) ? 'Yes' : 'No',
        ),
        HarbrTableContent(
          title: 'type',
          body: series?.harbrSeriesType,
        ),
        HarbrTableContent(
          title: 'path',
          body: series?.path,
        ),
        HarbrTableContent(
          title: 'quality',
          body: qualityProfile?.name,
        ),
        HarbrTableContent(
          title: 'language',
          body: languageProfile?.name,
        ),
        HarbrTableContent(
          title: 'tags',
          body: series?.harbrTags(tags),
        ),
        HarbrTableContent(title: '', body: ''),
        HarbrTableContent(
          title: 'status',
          body: series?.status?.toTitleCase(),
        ),
        HarbrTableContent(
          title: 'next airing',
          body: series?.harbrNextAiring(),
        ),
        HarbrTableContent(
          title: 'added on',
          body: series?.harbrDateAdded,
        ),
        HarbrTableContent(title: '', body: ''),
        HarbrTableContent(
          title: 'year',
          body: series?.harbrYear,
        ),
        HarbrTableContent(
          title: 'network',
          body: series?.harbrNetwork,
        ),
        HarbrTableContent(
          title: 'runtime',
          body: series?.harbrRuntime,
        ),
        HarbrTableContent(
          title: 'rating',
          body: series?.certification,
        ),
        HarbrTableContent(
          title: 'genres',
          body: series?.harbrGenres,
        ),
        HarbrTableContent(
          title: 'alternate titles',
          body: series?.harbrAlternateTitles,
        ),
      ],
    );
  }
}
