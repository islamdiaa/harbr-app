import 'package:flutter/material.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/utils/links.dart';
import 'package:harbr/widgets/ui.dart';

class LinksSheet extends HarbrBottomModalSheet {
  SonarrSeries series;

  LinksSheet({
    required this.series,
  });

  @override
  Widget builder(BuildContext context) {
    final imdb = HarbrLinkedContent.imdb(series.imdbId);
    final tvdb =
        HarbrLinkedContent.theTVDB(series.tvdbId, LinkedContentType.SERIES);
    final trakt =
        HarbrLinkedContent.trakt(series.tvdbId, LinkedContentType.SERIES);
    final tvMaze = HarbrLinkedContent.tvMaze(series.tvMazeId);

    return HarbrListViewModal(
      children: [
        if (imdb != null)
          HarbrBlock(
            title: 'IMDb',
            leading: const HarbrIconButton(icon: HarbrIcons.IMDB),
            onTap: imdb.openLink,
          ),
        if (tvdb != null)
          HarbrBlock(
            title: 'TheTVDB',
            leading: const HarbrIconButton(icon: HarbrIcons.THETVDB),
            onTap: tvdb.openLink,
          ),
        if (trakt != null)
          HarbrBlock(
            title: 'Trakt',
            leading: const HarbrIconButton(icon: HarbrIcons.TRAKT),
            onTap: trakt.openLink,
          ),
        if (tvMaze != null)
          HarbrBlock(
            title: 'TVmaze',
            leading: const HarbrIconButton(icon: HarbrIcons.TVMAZE),
            onTap: tvMaze.openLink,
          ),
      ],
    );
  }
}
