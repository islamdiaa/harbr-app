import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMovieDetailsFilesFileBlock extends StatefulWidget {
  final RadarrMovieFile file;

  const RadarrMovieDetailsFilesFileBlock({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrMovieDetailsFilesFileBlock> {
  HarbrLoadingState _deleteFileState = HarbrLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
          title: 'relative path',
          body: widget.file.harbrRelativePath,
        ),
        HarbrTableContent(
          title: 'video',
          body: widget.file.mediaInfo?.harbrVideoCodec,
        ),
        HarbrTableContent(
          title: 'audio',
          body: [
            widget.file.mediaInfo?.harbrAudioCodec,
            if (widget.file.mediaInfo?.audioChannels != null)
              widget.file.mediaInfo?.audioChannels.toString(),
          ].join(HarbrUI.TEXT_BULLET.pad()),
        ),
        HarbrTableContent(
          title: 'size',
          body: widget.file.harbrSize,
        ),
        HarbrTableContent(
          title: 'languages',
          body: widget.file.harbrLanguage,
        ),
        HarbrTableContent(
          title: 'quality',
          body: widget.file.harbrQuality,
        ),
        HarbrTableContent(
          title: 'formats',
          body: widget.file.harbrCustomFormats,
        ),
        HarbrTableContent(
          title: 'added on',
          body: widget.file.harbrDateAdded,
        ),
      ],
      buttons: [
        if (widget.file.mediaInfo != null)
          HarbrButton.text(
            text: 'Media Info',
            icon: Icons.info_outline_rounded,
            onTap: () async => _viewMediaInfo(),
          ),
        HarbrButton(
          type: HarbrButtonType.TEXT,
          text: 'Delete',
          icon: Icons.delete_rounded,
          onTap: () async => _deleteFile(),
          color: HarbrColours.red,
          loadingState: _deleteFileState,
        ),
      ],
    );
  }

  Future<void> _deleteFile() async {
    setState(() => _deleteFileState = HarbrLoadingState.ACTIVE);
    bool result = await RadarrDialogs().deleteMovieFile(context);
    if (result) {
      bool execute = await RadarrAPIHelper()
          .deleteMovieFile(context: context, movieFile: widget.file);
      if (execute) context.read<RadarrMovieDetailsState>().fetchFiles(context);
    }
    setState(() => _deleteFileState = HarbrLoadingState.INACTIVE);
  }

  Future<void> _viewMediaInfo() async {
    HarbrBottomModalSheet().show(
      builder: (context) => HarbrListViewModal(
        children: [
          HarbrHeader(text: 'radarr.Video'.tr()),
          HarbrTableCard(
            content: [
              HarbrTableContent(
                title: 'radarr.BitDepth'.tr(),
                body: widget.file.mediaInfo?.harbrVideoBitDepth,
              ),
              HarbrTableContent(
                title: 'radarr.Codec'.tr(),
                body: widget.file.mediaInfo?.harbrVideoCodec,
              ),
              HarbrTableContent(
                title: 'radarr.DynamicRange'.tr(),
                body: widget.file.mediaInfo?.harbrVideoDynamicRange,
              ),
              HarbrTableContent(
                title: 'radarr.FPS'.tr(),
                body: widget.file.mediaInfo?.harbrVideoFps,
              ),
              HarbrTableContent(
                title: 'radarr.Resolution'.tr(),
                body: widget.file.mediaInfo?.harbrVideoResolution,
              ),
            ],
          ),
          HarbrHeader(text: 'radarr.Audio'.tr()),
          HarbrTableCard(
            content: [
              HarbrTableContent(
                title: 'radarr.Channels'.tr(),
                body: widget.file.mediaInfo?.harbrAudioChannels,
              ),
              HarbrTableContent(
                title: 'radarr.Codec'.tr(),
                body: widget.file.mediaInfo?.harbrAudioCodec,
              ),
              HarbrTableContent(
                title: 'radarr.Languages'.tr(),
                body: widget.file.mediaInfo?.harbrAudioLanguages,
              ),
              HarbrTableContent(
                title: 'radarr.Streams'.tr(),
                body: widget.file.mediaInfo?.harbrAudioStreamCount,
              ),
            ],
          ),
          HarbrHeader(text: 'radarr.Other'.tr()),
          HarbrTableCard(
            content: [
              HarbrTableContent(
                title: 'radarr.Runtime'.tr(),
                body: widget.file.mediaInfo?.harbrRunTime,
              ),
              HarbrTableContent(
                title: 'radarr.ScanType'.tr(),
                body: widget.file.mediaInfo?.harbrScanType,
              ),
              HarbrTableContent(
                title: 'radarr.Subtitles'.tr(),
                body: widget.file.mediaInfo?.harbrSubtitles,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
