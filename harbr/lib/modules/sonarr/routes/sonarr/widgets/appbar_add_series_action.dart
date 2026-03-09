import 'package:flutter/material.dart';
import 'package:harbr/router/routes/sonarr.dart';
import 'package:harbr/widgets/ui.dart';

class SonarrAppBarAddSeriesAction extends StatelessWidget {
  const SonarrAppBarAddSeriesAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrIconButton(
      icon: Icons.add_rounded,
      onPressed: SonarrRoutes.ADD_SERIES.go,
    );
  }
}
