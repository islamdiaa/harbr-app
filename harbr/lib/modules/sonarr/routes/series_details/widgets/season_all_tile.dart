import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

class SonarrSeriesDetailsSeasonAllTile extends StatelessWidget {
  final SonarrSeries? series;

  const SonarrSeriesDetailsSeasonAllTile({
    Key? key,
    required this.series,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'sonarr.AllSeasons'.tr(),
      disabled: !series!.monitored!,
      body: [
        _subtitle1(),
        _subtitle2(),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        SonarrRoutes.SERIES_SEASON.go(params: {
          'series': (series?.id ?? -1).toString(),
          'season': '-1',
        });
      },
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      text: series?.statistics?.sizeOnDisk?.asBytes(decimals: 1) ?? '0.0B',
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      style: TextStyle(
        color: series!.harbrPercentageComplete == 100
            ? HarbrColours.accent
            : HarbrColours.red,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
      text: [
        '${series!.harbrPercentageComplete}%',
        HarbrUI.TEXT_BULLET,
        '${series!.statistics?.episodeFileCount ?? 0}/${series!.statistics?.episodeCount ?? 0}',
        'Episodes Available',
      ].join(' '),
    );
  }
}
