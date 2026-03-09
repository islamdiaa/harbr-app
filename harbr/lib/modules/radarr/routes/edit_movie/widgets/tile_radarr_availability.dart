import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMoviesEditMinimumAvailabilityTile extends StatelessWidget {
  const RadarrMoviesEditMinimumAvailabilityTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrMoviesEditState, RadarrAvailability>(
      selector: (_, state) => state.availability,
      builder: (context, availability, _) => HarbrBlock(
        title: 'radarr.MinimumAvailability'.tr(),
        body: [TextSpan(text: availability.readable)],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, RadarrAvailability?> _values =
              await RadarrDialogs().editMinimumAvailability(context);
          if (_values.item1)
            context.read<RadarrMoviesEditState>().availability = _values.item2!;
        },
      ),
    );
  }
}
