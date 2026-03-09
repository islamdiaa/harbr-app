import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrAppBarGlobalSettingsAction extends StatelessWidget {
  const SonarrAppBarGlobalSettingsAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async {
        Tuple2<bool, SonarrGlobalSettingsType?> values =
            await SonarrDialogs().globalSettings(context);
        if (values.item1) values.item2!.execute(context);
      },
    );
  }
}
