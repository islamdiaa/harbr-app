import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMoviesEditMonitoredTile extends StatelessWidget {
  const RadarrMoviesEditMonitoredTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'radarr.Monitored'.tr(),
      trailing: HarbrSwitch(
        value: context.watch<RadarrMoviesEditState>().monitored,
        onChanged: (value) =>
            context.read<RadarrMoviesEditState>().monitored = value,
      ),
    );
  }
}
