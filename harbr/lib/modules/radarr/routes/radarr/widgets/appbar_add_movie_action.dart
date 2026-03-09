import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrAppBarAddMoviesAction extends StatelessWidget {
  const RadarrAppBarAddMoviesAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrIconButton(
      icon: Icons.add_rounded,
      iconSize: HarbrUI.ICON_SIZE,
      onPressed: RadarrRoutes.ADD_MOVIE.go,
    );
  }
}
