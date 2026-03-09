import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrManualImportBottomActionBar extends StatelessWidget {
  const RadarrManualImportBottomActionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'radarr.Quick'.tr(),
          icon: Icons.search_rounded,
          onTap: () async => RadarrAPIHelper().quickImport(
            context: context,
            path: context.read<RadarrManualImportState>().currentPath,
          ),
        ),
        HarbrButton.text(
          text: 'radarr.Interactive'.tr(),
          icon: Icons.person_rounded,
          onTap: () => RadarrRoutes.MANUAL_IMPORT_DETAILS.go(queryParams: {
            'path': context.read<RadarrManualImportState>().currentPath,
          }),
        ),
      ],
    );
  }
}
