import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/duration/timestamp.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliMediaDetailsMetadataMetadata extends StatelessWidget {
  final TautulliMetadata? metadata;

  const TautulliMediaDetailsMetadataMetadata({
    Key? key,
    required this.metadata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        if (metadata!.originallyAvailableAt != null &&
            metadata!.originallyAvailableAt!.isNotEmpty)
          HarbrTableContent(
            title: 'released',
            body: metadata!.originallyAvailableAt,
          ),
        if (metadata!.addedAt != null)
          HarbrTableContent(
            title: 'added',
            body: metadata!.addedAt!.asPoleDate(),
          ),
        if (metadata!.duration != null)
          HarbrTableContent(
            title: 'duration',
            body: metadata!.duration!.asNumberTimestamp(),
          ),
        if (metadata?.mediaInfo?.isNotEmpty ?? false)
          HarbrTableContent(
            title: 'bitrate',
            body:
                '${metadata!.mediaInfo![0].bitrate ?? HarbrUI.TEXT_EMDASH} kbps',
          ),
        if (metadata!.rating != null)
          HarbrTableContent(
              title: 'rating',
              body: '${(((metadata?.rating ?? 0) * 10).truncate())}%'),
        if (metadata!.studio != null && metadata!.studio!.isNotEmpty)
          HarbrTableContent(
            title: 'studio',
            body: metadata!.studio,
          ),
        if (metadata?.genres?.isNotEmpty ?? false)
          HarbrTableContent(
            title: 'genres',
            body: metadata!.genres!.take(5).join('\n'),
          ),
        if (metadata?.directors?.isNotEmpty ?? false)
          HarbrTableContent(
            title: 'directors',
            body: metadata!.directors!.take(5).join('\n'),
          ),
        if (metadata?.writers?.isNotEmpty ?? false)
          HarbrTableContent(
            title: 'writers',
            body: metadata!.writers!.take(5).join('\n'),
          ),
        if (metadata?.actors?.isNotEmpty ?? false)
          HarbrTableContent(
            title: 'actors',
            body: metadata!.actors!.take(5).join('\n'),
          ),
      ],
    );
  }
}
