import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliCheckForUpdatesTautulliTile extends StatelessWidget {
  final TautulliUpdateCheck update;

  const TautulliCheckForUpdatesTautulliTile({
    Key? key,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'Tautulli',
      body: _subtitle(),
      trailing: _trailing(),
    );
  }

  Widget _trailing() {
    return Column(
      children: [
        HarbrIconButton(
          icon: HarbrIcons.TAUTULLI,
          color: HarbrColours().byListIndex(1),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  List<TextSpan> _subtitle() {
    return [
      if (!(update.update ?? false))
        const TextSpan(
          text: 'No Updates Available',
          style: TextStyle(
            color: HarbrColours.accent,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      if (update.update ?? false)
        const TextSpan(
          text: 'Update Available',
          style: TextStyle(
            color: HarbrColours.orange,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      if (update.update ?? false)
        TextSpan(
          children: [
            const TextSpan(text: 'Current Version: '),
            TextSpan(
              text: update.currentRelease ??
                  update.currentVersion?.substring(
                    0,
                    min(7, update.currentVersion!.length),
                  ) ??
                  'harbr.Unknown'.tr(),
            ),
          ],
        ),
      if (update.update ?? false)
        TextSpan(
          children: [
            const TextSpan(text: 'Latest Version: '),
            TextSpan(
              text: update.latestRelease ??
                  update.latestVersion?.substring(
                    0,
                    min(7, update.latestVersion!.length),
                  ) ??
                  'harbr.Unknown'.tr(),
            ),
          ],
        ),
      TextSpan(
          text: 'Install Type: ${update.installType ?? HarbrUI.TEXT_EMDASH}'),
    ];
  }
}
