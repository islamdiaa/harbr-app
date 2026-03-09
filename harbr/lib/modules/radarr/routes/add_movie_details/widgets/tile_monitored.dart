import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrAddMovieDetailsMonitoredTile extends StatelessWidget {
  const RadarrAddMovieDetailsMonitoredTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'radarr.Monitor'.tr(),
      trailing: Selector<RadarrAddMovieDetailsState, bool>(
        selector: (_, state) => state.monitored,
        builder: (context, monitored, _) => HarbrSwitch(
          value: monitored,
          onChanged: (value) =>
              context.read<RadarrAddMovieDetailsState>().monitored = value,
        ),
      ),
    );
  }
}
