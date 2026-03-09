import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrMediaInfoSheet extends HarbrBottomModalSheet {
  final SonarrEpisodeFileMediaInfo? mediaInfo;

  SonarrMediaInfoSheet({
    required this.mediaInfo,
  });

  @override
  Widget builder(BuildContext context) {
    return HarbrListViewModal(
      children: [
        HarbrHeader(text: 'sonarr.Video'.tr()),
        HarbrTableCard(
          content: [
            HarbrTableContent(
              title: 'sonarr.BitDepth'.tr(),
              body: mediaInfo!.harbrVideoBitDepth,
            ),
            HarbrTableContent(
              title: 'sonarr.Bitrate'.tr(),
              body: mediaInfo!.harbrVideoBitrate,
            ),
            HarbrTableContent(
              title: 'sonarr.Codec'.tr(),
              body: mediaInfo!.harbrVideoCodec,
            ),
            HarbrTableContent(
              title: 'sonarr.FPS'.tr(),
              body: mediaInfo!.harbrVideoFps,
            ),
            HarbrTableContent(
              title: 'sonarr.Resolution'.tr(),
              body: mediaInfo!.harbrVideoResolution,
            ),
            HarbrTableContent(
              title: 'sonarr.ScanType'.tr(),
              body: mediaInfo!.harbrVideoScanType,
            ),
          ],
        ),
        HarbrHeader(text: 'sonarr.Audio'.tr()),
        HarbrTableCard(
          content: [
            HarbrTableContent(
              title: 'sonarr.Bitrate'.tr(),
              body: mediaInfo!.harbrAudioBitrate,
            ),
            HarbrTableContent(
              title: 'sonarr.Channels'.tr(),
              body: mediaInfo!.harbrAudioChannels,
            ),
            HarbrTableContent(
              title: 'sonarr.Codec'.tr(),
              body: mediaInfo!.harbrAudioCodec,
            ),
            HarbrTableContent(
              title: 'sonarr.Languages'.tr(),
              body: mediaInfo!.harbrAudioLanguages,
            ),
            HarbrTableContent(
              title: 'sonarr.Streams'.tr(),
              body: mediaInfo!.harbrAudioStreamCount,
            ),
          ],
        ),
        HarbrHeader(text: 'sonarr.Other'.tr()),
        HarbrTableCard(
          content: [
            HarbrTableContent(
              title: 'sonarr.Runtime'.tr(),
              body: mediaInfo!.harbrRunTime,
            ),
            HarbrTableContent(
              title: 'sonarr.Subtitles'.tr(),
              body: mediaInfo!.harbrSubtitles,
            ),
          ],
        ),
      ],
    );
  }
}
