import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesAddDetailsMonitorTile extends StatelessWidget {
  const SonarrSeriesAddDetailsMonitorTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'sonarr.Monitor'.tr(),
      body: [
        TextSpan(
          text:
              context.watch<SonarrSeriesAddDetailsState>().monitorType.harbrName,
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    Tuple2<bool, SonarrSeriesMonitorType?> result =
        await SonarrDialogs().editMonitorType(context);
    if (result.item1) {
      context.read<SonarrSeriesAddDetailsState>().monitorType = result.item2!;
      SonarrDatabase.ADD_SERIES_DEFAULT_MONITOR_TYPE
          .update(result.item2!.value!);
    }
  }
}
