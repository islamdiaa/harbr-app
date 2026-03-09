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
    return HarbrExpandableListTile(
      title: widget.queueRecord.title!,
      collapsedSubtitles: [
        if (widget.type == SonarrQueueTileType.ALL) _subtitle1(),
        if (widget.type == SonarrQueueTileType.ALL) _subtitle2(),
        _subtitle3(),
        _subtitle4(),
      ],
      expandedTableContent: _expandedTableContent(),
      expandedHighlightedNodes: _expandedHighlightedNodes(),
      expandedTableButtons: _tableButtons(),
      collapsedTrailing: _collapsedTrailing(),
      onLongPress: _onLongPress,
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

  Widget _collapsedTrailing() {
    Tuple3<String, IconData, Color> _status =
        widget.queueRecord.harbrStatusParameters();
    return HarbrIconButton(
      icon: _status.item2,
      color: _status.item3,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      text: widget.queueRecord.series!.title ?? HarbrUI.TEXT_EMDASH,
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(
            text: widget.queueRecord.episode?.harbrsonEpisode() ??
                HarbrUI.TEXT_EMDASH),
        const TextSpan(text: ': '),
        TextSpan(
            text: widget.queueRecord.episode!.title ?? HarbrUI.TEXT_EMDASH,
            style: const TextStyle(fontStyle: FontStyle.italic)),
      ],
    );
  }

  TextSpan _subtitle3() {
    return TextSpan(
      children: [
        TextSpan(
          text: widget.queueRecord.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
        ),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        if (widget.queueRecord.language != null)
          TextSpan(
            text: widget.queueRecord.language?.name ?? HarbrUI.TEXT_EMDASH,
          ),
        if (widget.queueRecord.language != null)
          TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(
          text: widget.queueRecord.harbrTimeLeft(),
        ),
      ],
    );
  }

  TextSpan _subtitle4() {
    Tuple3<String, IconData, Color> _params =
        widget.queueRecord.harbrStatusParameters(canBeWhite: false);
    return TextSpan(
      style: TextStyle(
        color: _params.item3,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
      children: [
        TextSpan(text: widget.queueRecord.harbrPercentage()),
        TextSpan(text: HarbrUI.TEXT_EMDASH.pad()),
        TextSpan(text: _params.item1),
      ],
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
      // if (widget.queueRecord.status == SonarrQueueStatus.COMPLETED &&
      //     widget.queueRecord?.trackedDownloadStatus ==
      //         SonarrTrackedDownloadStatus.WARNING)
      //   HarbrButton.text(
      //     icon: Icons.download_done_rounded,
      //     text: 'sonarr.Import'.tr(),
      //     onTap: () async {},
      //   ),
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
