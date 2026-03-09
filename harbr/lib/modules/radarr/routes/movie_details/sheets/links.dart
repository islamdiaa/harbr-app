import 'package:flutter/material.dart';
import 'package:harbr/api/radarr/models.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/utils/links.dart';
import 'package:harbr/widgets/ui.dart';

class LinksSheet extends HarbrBottomModalSheet {
  RadarrMovie movie;

  LinksSheet({
    required this.movie,
  });

  @override
  Widget builder(BuildContext context) {
    final imdb = HarbrLinkedContent.imdb(movie.imdbId);
    final tmdb =
        HarbrLinkedContent.theMovieDB(movie.tmdbId, LinkedContentType.MOVIE);
    final letterboxd = HarbrLinkedContent.letterboxd(movie.tmdbId);
    final trakt =
        HarbrLinkedContent.trakt(movie.tmdbId, LinkedContentType.MOVIE);
    final youtube = HarbrLinkedContent.youtube(movie.youTubeTrailerId);

    return HarbrListViewModal(
      children: [
        if (imdb != null)
          HarbrBlock(
            title: 'IMDb',
            leading: const HarbrIconButton(icon: HarbrIcons.IMDB),
            onTap: imdb.openLink,
          ),
        if (letterboxd != null)
          HarbrBlock(
            title: 'Letterboxd',
            leading: const HarbrIconButton(icon: HarbrIcons.LETTERBOXD),
            onTap: letterboxd.openLink,
          ),
        if (tmdb != null)
          HarbrBlock(
            title: 'The Movie Database',
            leading: const HarbrIconButton(icon: HarbrIcons.THEMOVIEDATABASE),
            onTap: tmdb.openLink,
          ),
        if (trakt != null)
          HarbrBlock(
            title: 'Trakt',
            leading: const HarbrIconButton(icon: HarbrIcons.TRAKT),
            onTap: trakt.openLink,
          ),
        if (youtube != null)
          HarbrBlock(
            title: 'YouTube',
            leading: const HarbrIconButton(icon: HarbrIcons.YOUTUBE),
            onTap: youtube.openLink,
          ),
      ],
    );
  }
}
