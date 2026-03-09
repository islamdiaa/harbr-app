import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliCheckForUpdatesPMSTile extends StatelessWidget {
  final TautulliPMSUpdate update;

  const TautulliCheckForUpdatesPMSTile({
    Key? key,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'Plex Media Server',
      body: _subtitle(),
      trailing: _trailing(),
    );
  }

  Widget _trailing() {
    return Column(
      children: [
        HarbrIconButton(
          icon: HarbrIcons.PLEX,
          iconSize: HarbrUI.ICON_SIZE - 2.0,
          color: HarbrColours().byListIndex(0),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  List<TextSpan> _subtitle() {
    return [
      if (!(update.updateAvailable ?? false))
        const TextSpan(
          text: 'No Updates Available',
          style: TextStyle(
            color: HarbrColours.accent,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      if (!(update.updateAvailable ?? false))
        TextSpan(
            text: 'Current Version: ${update.version ?? HarbrUI.TEXT_EMDASH}'),
      if (update.updateAvailable ?? false)
        const TextSpan(
          text: 'Update Available',
          style: TextStyle(
            color: HarbrColours.orange,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      if (update.updateAvailable ?? false)
        TextSpan(
            text: 'Latest Version: ${update.version ?? HarbrUI.TEXT_EMDASH}'),
    ];
  }
}
