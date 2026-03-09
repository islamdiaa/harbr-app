import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliActivityDetailsPlayerBlock extends StatelessWidget {
  final TautulliSession session;

  const TautulliActivityDetailsPlayerBlock({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
            title: 'tautulli.Location'.tr(), body: session.harbrIPAddress),
        HarbrTableContent(
            title: 'tautulli.Platform'.tr(), body: session.harbrPlatform),
        HarbrTableContent(
            title: 'tautulli.Product'.tr(), body: session.harbrProduct),
        HarbrTableContent(
            title: 'tautulli.Player'.tr(), body: session.harbrPlayer),
        HarbrTableContent(
            title: 'tautulli.Quality'.tr(), body: session.harbrQuality),
      ],
    );
  }
}
