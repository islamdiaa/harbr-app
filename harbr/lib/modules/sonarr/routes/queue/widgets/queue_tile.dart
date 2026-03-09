import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

enum SonarrQueueTileType {
  ALL,
  EPISODE,
}

class SonarrQueueTile extends StatefulWidget {
  final SonarrQueueRecord queueRecord;
  final SonarrQueueTileType type;

  const SonarrQueueTile({
    Key? key,
    required this.queueRecord,
    required this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SonarrQueueTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrMediaRow(
      poster: HarbrPoster(
        url: widget.queueRecord.series?.remotePoster,
        headers: context.read<SonarrState>().headers,
        placeholderIcon: HarbrIcons.VIDEO_CAM,
        size: PosterSize.lg,
      ),
      title: widget.queueRecord.title ?? HarbrUI.TEXT_EMDASH,
      subtitle: _buildSubtitle(),
      status: _statusSection(),
      metadata: _metaChips(),
      trailing: _collapsedTrailing(),
      onTap: () => _onTap(),
      onLongPress: _onLongPress,
    );
  }

  String _buildSubtitle() {
    if (widget.type == SonarrQueueTileType.ALL) {
      final seriesTitle =
          widget.queueRecord.series?.title ?? HarbrUI.TEXT_EMDASH;
      final episode =
          widget.queueRecord.episode?.harbrsonEpisode() ?? HarbrUI.TEXT_EMDASH;
      final episodeTitle =
          widget.queueRecord.episode?.title ?? HarbrUI.TEXT_EMDASH;
      return '$seriesTitle \u2022 $episode: $episodeTitle';
    }
    return widget.queueRecord.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH;
  }

  StatusType _mapStatusType() {
    Tuple3<String, IconData, Color> params =
        widget.queueRecord.harbrStatusParameters(canBeWhite: false);
    Color color = params.item3;

    if (color == HarbrColours.red) return StatusType.error;
    if (color == HarbrColours.orange) return StatusType.error;
    if (color == HarbrColours.purple) return StatusType.importing;

    switch (widget.queueRecord.status) {
      case SonarrQueueStatus.QUEUED:
      case SonarrQueueStatus.DOWNLOADING:
      case SonarrQueueStatus.PAUSED:
      case SonarrQueueStatus.DELAY:
        return StatusType.queued;
      case SonarrQueueStatus.COMPLETED:
        return StatusType.downloaded;
      case SonarrQueueStatus.FAILED:
      case SonarrQueueStatus.WARNING:
      case SonarrQueueStatus.DOWNLOAD_CLIENT_UNAVAILABLE:
        return StatusType.error;
      default:
        return StatusType.queued;
    }
  }

  Widget _statusSection() {
    Tuple3<String, IconData, Color> params =
        widget.queueRecord.harbrStatusParameters(canBeWhite: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HarbrStatusBadge(
              type: _mapStatusType(),
              label: params.item1,
            ),
            const SizedBox(width: HarbrTokens.xs),
            HarbrMetaChip(
              label: widget.queueRecord.harbrPercentage(),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        HarbrProgressBar(
          progress: _progressValue(),
          height: 3.0,
        ),
      ],
    );
  }

  double _progressValue() {
    if (widget.queueRecord.sizeleft == null ||
        widget.queueRecord.size == null ||
        widget.queueRecord.size == 0) return 0.0;
    double sizeFetched =
        widget.queueRecord.size! - widget.queueRecord.sizeleft!;
    return (sizeFetched / widget.queueRecord.size!).clamp(0.0, 1.0);
  }

  List<Widget> _metaChips() {
    return [
      HarbrMetaChip(
        icon: Icons.storage_rounded,
        label: widget.queueRecord.size?.floor().asBytes() ?? HarbrUI.TEXT_EMDASH,
      ),
      if ((widget.queueRecord.downloadClient ?? '').isNotEmpty)
        HarbrMetaChip(
          icon: Icons.download_rounded,
          label: widget.queueRecord.downloadClient!,
        ),
      HarbrMetaChip(
        icon: Icons.schedule_rounded,
        label: widget.queueRecord.harbrTimeLeft(),
      ),
    ];
  }

  Widget _collapsedTrailing() {
    Tuple3<String, IconData, Color> _status =
        widget.queueRecord.harbrStatusParameters();
    return HarbrIconButton(
      icon: _status.item2,
      color: _status.item3,
    );
  }

  Future<void> _onLongPress() async {
    switch (widget.type) {
      case SonarrQueueTileType.ALL:
        SonarrRoutes.SERIES.go(params: {
          'series': widget.queueRecord.seriesId!.toString(),
        });
        break;
      case SonarrQueueTileType.EPISODE:
        SonarrRoutes.QUEUE.go();
        break;
    }
  }

  void _onTap() {
    HarbrBottomModalSheet().show(
      builder: (_) => HarbrListViewModal(
        children: [
          HarbrHeader(text: widget.queueRecord.title ?? HarbrUI.TEXT_EMDASH),
          // Highlighted nodes
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HarbrUI.DEFAULT_MARGIN_SIZE,
              vertical: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
            ),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
              runSpacing: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
              children: _expandedHighlightedNodes(),
            ),
          ),
          // Table content
          ..._expandedTableContent().map((item) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: HarbrUI.DEFAULT_MARGIN_SIZE,
                ),
                child: item,
              )),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
            ),
            child: Wrap(
              children: List.generate(
                _tableButtons().length,
                (index) {
                  final buttons = _tableButtons();
                  int bCount = buttons.length;
                  double widthFactor = 0.5;
                  if (index == (bCount - 1) && bCount.isOdd) {
                    widthFactor = 1;
                  }
                  return FractionallySizedBox(
                    widthFactor: widthFactor,
                    child: buttons[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<HarbrHighlightedNode> _expandedHighlightedNodes() {
    Tuple3<String, IconData, Color> _status =
        widget.queueRecord.harbrStatusParameters(canBeWhite: false);
    return [
      HarbrHighlightedNode(
        text: widget.queueRecord.protocol!.harbrReadable(),
        backgroundColor: widget.queueRecord.protocol!.harbrProtocolColor(),
      ),
      HarbrHighlightedNode(
        text: widget.queueRecord.harbrPercentage(),
        backgroundColor: _status.item3,
      ),
      HarbrHighlightedNode(
        text: widget.queueRecord.status!.harbrStatus(),
        backgroundColor: _status.item3,
      ),
    ];
  }

  List<HarbrTableContent> _expandedTableContent() {
    return [
      if (widget.type == SonarrQueueTileType.ALL)
        HarbrTableContent(
          title: 'sonarr.Series'.tr(),
          body: widget.queueRecord.series?.title ?? HarbrUI.TEXT_EMDASH,
        ),
      if (widget.type == SonarrQueueTileType.ALL)
        HarbrTableContent(
          title: 'sonarr.Episode'.tr(),
          body: widget.queueRecord.episode?.harbrsonEpisode() ??
              HarbrUI.TEXT_EMDASH,
        ),
      if (widget.type == SonarrQueueTileType.ALL)
        HarbrTableContent(
          title: 'sonarr.Title'.tr(),
          body: widget.queueRecord.episode?.title ?? HarbrUI.TEXT_EMDASH,
        ),
      if (widget.type == SonarrQueueTileType.ALL)
        HarbrTableContent(title: '', body: ''),
      HarbrTableContent(
        title: 'sonarr.Quality'.tr(),
        body: widget.queueRecord.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
      ),
      if (widget.queueRecord.language != null)
        HarbrTableContent(
          title: 'sonarr.Language'.tr(),
          body: widget.queueRecord.language?.name ?? HarbrUI.TEXT_EMDASH,
        ),
      HarbrTableContent(
        title: 'sonarr.Client'.tr(),
        body: widget.queueRecord.downloadClient ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'sonarr.Size'.tr(),
        body: widget.queueRecord.size?.floor().asBytes() ?? HarbrUI.TEXT_EMDASH,
      ),
      HarbrTableContent(
        title: 'sonarr.TimeLeft'.tr(),
        body: widget.queueRecord.harbrTimeLeft(),
      ),
    ];
  }

  List<HarbrButton> _tableButtons() {
    return [
      if ((widget.queueRecord.statusMessages ?? []).isNotEmpty)
        HarbrButton.text(
          icon: Icons.messenger_outline_rounded,
          color: HarbrColours.orange,
          text: 'sonarr.Messages'.tr(),
          onTap: () async {
            SonarrDialogs().showQueueStatusMessages(
              context,
              widget.queueRecord.statusMessages!,
            );
          },
        ),
      HarbrButton.text(
        icon: Icons.delete_rounded,
        color: HarbrColours.red,
        text: 'harbr.Remove'.tr(),
        onTap: () async {
          bool result = await SonarrDialogs().removeFromQueue(context);
          if (result) {
            SonarrAPIController()
                .removeFromQueue(
              context: context,
              queueRecord: widget.queueRecord,
            )
                .then((_) {
              switch (widget.type) {
                case SonarrQueueTileType.ALL:
                  context.read<SonarrQueueState>().fetchQueue(
                        context,
                        hardCheck: true,
                      );
                  break;
                case SonarrQueueTileType.EPISODE:
                  context.read<SonarrSeasonDetailsState>().fetchState(
                        context,
                        shouldFetchEpisodes: false,
                        shouldFetchFiles: false,
                      );
                  break;
              }
            });
          }
        },
      ),
    ];
  }
}
