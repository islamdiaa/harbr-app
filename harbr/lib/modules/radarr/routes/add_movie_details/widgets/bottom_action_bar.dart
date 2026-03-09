import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrAddMovieDetailsActionBar extends StatelessWidget {
  const RadarrAddMovieDetailsActionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBottomActionBar(
      actions: [
        HarbrActionBarCard(
          title: 'harbr.Options'.tr(),
          subtitle: 'radarr.StartSearchFor'.tr(),
          onTap: () async => RadarrDialogs().addMovieOptions(context),
        ),
        HarbrButton(
          type: HarbrButtonType.TEXT,
          text: 'harbr.Add'.tr(),
          icon: Icons.add_rounded,
          onTap: () async => _onTap(context),
          loadingState: context.watch<RadarrAddMovieDetailsState>().state,
        ),
      ],
    );
  }

  Future<void> _onTap(BuildContext context) async {
    if (context.read<RadarrAddMovieDetailsState>().canExecuteAction) {
      context.read<RadarrAddMovieDetailsState>().state =
          HarbrLoadingState.ACTIVE;
      await RadarrAPIHelper()
          .addMovie(
        context: context,
        movie: context.read<RadarrAddMovieDetailsState>().movie,
        rootFolder: context.read<RadarrAddMovieDetailsState>().rootFolder,
        monitored: context.read<RadarrAddMovieDetailsState>().monitored,
        qualityProfile:
            context.read<RadarrAddMovieDetailsState>().qualityProfile,
        availability: context.read<RadarrAddMovieDetailsState>().availability,
        tags: context.read<RadarrAddMovieDetailsState>().tags,
        searchForMovie: RadarrDatabase.ADD_MOVIE_SEARCH_FOR_MISSING.read(),
      )
          .then((movie) async {
        context.read<RadarrState>().fetchMovies();
        context.read<RadarrAddMovieDetailsState>().movie.id = movie!.id;
        HarbrRouter.router.pop();
        RadarrRoutes.MOVIE.go(params: {
          'movie': movie.id!.toString(),
        });
      }).catchError((error, stack) {
        context.read<RadarrAddMovieDetailsState>().state =
            HarbrLoadingState.ERROR;
      });
      context.read<RadarrAddMovieDetailsState>().state =
          HarbrLoadingState.INACTIVE;
    }
  }
}
