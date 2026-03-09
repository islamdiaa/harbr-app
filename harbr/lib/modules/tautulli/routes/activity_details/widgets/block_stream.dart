import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliActivityDetailsStreamBlock extends StatelessWidget {
  final TautulliSession session;

  const TautulliActivityDetailsStreamBlock({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
          title: 'tautulli.Bandwidth'.tr(),
          body: session.harbrBandwidth,
        ),
        HarbrTableContent(
          title: 'tautulli.Stream'.tr(),
          body: session.formattedStream(),
        ),
        HarbrTableContent(
          title: 'tautulli.Container'.tr(),
          body: session.formattedContainer(),
        ),
        if (session.hasVideo())
          HarbrTableContent(
            title: 'tautulli.Video'.tr(),
            body: session.formattedVideo(),
          ),
        if (session.hasAudio())
          HarbrTableContent(
            title: 'tautulli.Audio'.tr(),
            body: session.formattedAudio(),
          ),
        if (session.hasSubtitles())
          HarbrTableContent(
            title: 'tautulli.Subtitle'.tr(),
            body: session.formattedSubtitles(),
          ),
      ],
    );
  }
}
