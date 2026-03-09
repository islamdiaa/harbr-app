import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrAddMovieDetailsTagsTile extends StatelessWidget {
  const RadarrAddMovieDetailsTagsTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'radarr.Tags'.tr(),
      body: [
        TextSpan(
          text: context.watch<RadarrAddMovieDetailsState>().tags.isEmpty
              ? HarbrUI.TEXT_EMDASH
              : context
                  .watch<RadarrAddMovieDetailsState>()
                  .tags
                  .map((e) => e.label)
                  .join(', '),
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async => await RadarrDialogs().setAddTags(context),
    );
  }
}
