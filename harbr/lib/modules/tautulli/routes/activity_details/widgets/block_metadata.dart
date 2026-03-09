import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliActivityDetailsMetadataBlock extends StatelessWidget {
  final TautulliSession session;

  const TautulliActivityDetailsMetadataBlock({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
            title: 'tautulli.Title'.tr(), body: session.harbrFullTitle),
        if (session.year != null)
          HarbrTableContent(title: 'tautulli.Year'.tr(), body: session.harbrYear),
        HarbrTableContent(
            title: 'tautulli.Duration'.tr(), body: session.harbrDuration),
        HarbrTableContent(title: 'tautulli.ETA'.tr(), body: session.harbrETA),
        HarbrTableContent(
            title: 'tautulli.Library'.tr(), body: session.harbrLibraryName),
        HarbrTableContent(
            title: 'tautulli.User'.tr(), body: session.harbrFriendlyName),
      ],
    );
  }
}
