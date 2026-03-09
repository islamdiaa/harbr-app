import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesDetailsOverviewDescriptionTile extends StatelessWidget {
  final SonarrSeries? series;

  const SonarrSeriesDetailsOverviewDescriptionTile({
    Key? key,
    required this.series,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      backgroundUrl: context.read<SonarrState>().getFanartURL(series!.id),
      posterUrl: context.read<SonarrState>().getPosterURL(series!.id),
      posterHeaders: context.read<SonarrState>().headers,
      title: series!.title,
      body: [
        HarbrTextSpan.extended(
          text: series!.overview == null || series!.overview!.isEmpty
              ? 'sonarr.NoSummaryAvailable'.tr()
              : series!.overview,
        ),
      ],
      customBodyMaxLines: 3,
      onTap: () async => HarbrDialogs().textPreview(
        context,
        series!.title,
        series!.overview!,
      ),
    );
  }
}
