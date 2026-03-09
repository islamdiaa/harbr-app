import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrQueueTile extends StatelessWidget {
  final RadarrQueueRecord record;
  final RadarrMovie? movie;

  const RadarrQueueTile({
    Key? key,
    required this.record,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<RadarrState>().movies,
      builder: (context, AsyncSnapshot<List<RadarrMovie>> snapshot) {
        RadarrMovie? movie;
        if (snapshot.hasData)
          movie = snapshot.data!.firstWhereOrNull(
            (element) => element.id == record.movieId,
          );
        return HarbrMediaRow(
          poster: HarbrPoster(
            url: movie?.remotePoster,
            headers: context.read<RadarrState>().headers,
            placeholderIcon: HarbrIcons.VIDEO_CAM,
            size: PosterSize.lg,
          ),
          title: record.title ?? HarbrUI.TEXT_EMDASH,
          subtitle: movie != null ? record.harbrMovieTitle(movie) : null,
          status: _statusSection(),
          metadata: _metaChips(),
          trailing: HarbrIconButton(
            icon: record.harbrStatusIcon,
            color: record.harbrStatusColor,
          ),
          onTap: () => _onTap(context, movie),
          onLongPress: () => RadarrRoutes.MOVIE.go(params: {
            'movie': record.movieId!.toString(),
          }),
        );
      },
    );
  }

  StatusType _mapStatusType() {
    if (record.trackedDownloadStatus == RadarrTrackedDownloadStatus.ERROR)
      return StatusType.error;
    if (record.trackedDownloadStatus == RadarrTrackedDownloadStatus.WARNING)
      return StatusType.error;
    switch (record.status) {
      case RadarrQueueRecordStatus.QUEUED:
      case RadarrQueueRecordStatus.DOWNLOADING:
      case RadarrQueueRecordStatus.PAUSED:
      case RadarrQueueRecordStatus.DELAY:
        return StatusType.queued;
      case RadarrQueueRecordStatus.COMPLETED:
        if (record.trackedDownloadState ==
                RadarrTrackedDownloadState.IMPORTING ||
            record.trackedDownloadState ==
                RadarrTrackedDownloadState.IMPORT_PENDING)
          return StatusType.importing;
        return StatusType.downloaded;
      case RadarrQueueRecordStatus.FAILED:
      case RadarrQueueRecordStatus.WARNING:
      case RadarrQueueRecordStatus.DOWNLOAD_CLIENT_UNAVAILABLE:
        return StatusType.error;
      default:
        return StatusType.queued;
    }
  }

  Widget _statusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HarbrStatusBadge(
              type: _mapStatusType(),
              label: record.status?.readable ?? HarbrUI.TEXT_EMDASH,
            ),
            const SizedBox(width: HarbrTokens.xs),
            HarbrMetaChip(
              label: '${record.harbrPercentageComplete}%',
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        HarbrProgressBar(
          progress: record.harbrPercentageComplete / 100.0,
          height: 3.0,
        ),
      ],
    );
  }

  List<Widget> _metaChips() {
    return [
      HarbrMetaChip(
        icon: Icons.storage_rounded,
        label: record.size != null
            ? record.size!.toInt().asBytes()
            : HarbrUI.TEXT_EMDASH,
      ),
      if ((record.downloadClient ?? '').isNotEmpty)
        HarbrMetaChip(
          icon: Icons.download_rounded,
          label: record.downloadClient!,
        ),
      HarbrMetaChip(
        icon: Icons.schedule_rounded,
        label: record.timeLeft ?? HarbrUI.TEXT_EMDASH,
      ),
    ];
  }

  void _onTap(BuildContext context, RadarrMovie? movie) {
    HarbrBottomModalSheet().show(
      builder: (_) => HarbrListViewModal(
        children: [
          HarbrHeader(text: record.title ?? HarbrUI.TEXT_EMDASH),
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
              children: _highlightedNodes(),
            ),
          ),
          // Table content
          ..._tableContent(movie).map((item) => Padding(
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
                _tableButtons(context).length,
                (index) {
                  final buttons = _tableButtons(context);
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

  List<HarbrHighlightedNode> _highlightedNodes() {
    return [
      HarbrHighlightedNode(
        text: record.protocol?.readable ?? HarbrUI.TEXT_EMDASH,
        backgroundColor: HarbrColours.blue,
      ),
      HarbrHighlightedNode(
        text: record.harbrQuality,
        backgroundColor: HarbrColours.accent,
      ),
      if ((record.customFormats?.length ?? 0) != 0)
        for (int i = 0; i < record.customFormats!.length; i++)
          HarbrHighlightedNode(
            text: record.customFormats![i].name!,
            backgroundColor: HarbrColours.orange,
          ),
      HarbrHighlightedNode(
        text: '${record.harbrPercentageComplete}%',
        backgroundColor: HarbrColours.blueGrey,
      ),
      HarbrHighlightedNode(
        text: record.status?.readable ?? HarbrUI.TEXT_EMDASH,
        backgroundColor: HarbrColours.blueGrey,
      ),
    ];
  }

  List<HarbrTableContent> _tableContent(RadarrMovie? movie) {
    if (movie == null) return [];
    return [
      HarbrTableContent(
          title: 'radarr.Movie'.tr(), body: record.harbrMovieTitle(movie)),
      HarbrTableContent(
          title: 'radarr.Languages'.tr(), body: record.harbrLanguage),
      HarbrTableContent(title: 'Client', body: record.harbrDownloadClient),
      HarbrTableContent(title: 'Indexer', body: record.harbrIndexer),
      HarbrTableContent(
          title: 'radarr.Size'.tr(), body: record.size!.toInt().asBytes()),
      HarbrTableContent(
          title: 'Time Left', body: record.timeLeft ?? HarbrUI.TEXT_EMDASH),
    ];
  }

  List<HarbrButton> _tableButtons(BuildContext context) {
    return [
      if ((record.statusMessages ?? []).isNotEmpty)
        HarbrButton.text(
          icon: Icons.messenger_outline_rounded,
          color: HarbrColours.orange,
          text: 'Messages',
          onTap: () async {
            HarbrDialogs().showMessages(
              context,
              record.statusMessages!
                  .map<String>((status) => status.messages!.join('\n'))
                  .toList(),
            );
          },
        ),
      if (record.status == RadarrQueueRecordStatus.COMPLETED &&
          record.trackedDownloadStatus == RadarrTrackedDownloadStatus.WARNING &&
          (record.outputPath ?? '').isNotEmpty)
        HarbrButton.text(
          icon: Icons.download_done_rounded,
          text: 'radarr.Import'.tr(),
          onTap: () => RadarrRoutes.MANUAL_IMPORT_DETAILS.go(queryParams: {
            'path': record.outputPath!,
          }),
        ),
      HarbrButton.text(
        icon: Icons.delete_rounded,
        color: HarbrColours.red,
        text: 'Remove',
        onTap: () async {
          if (context.read<RadarrState>().enabled) {
            bool result = await RadarrDialogs().confirmDeleteQueue(context);
            if (result) {
              await context
                  .read<RadarrState>()
                  .api!
                  .queue
                  .delete(
                    id: record.id!,
                    blacklist: RadarrDatabase.QUEUE_BLACKLIST.read(),
                    removeFromClient:
                        RadarrDatabase.QUEUE_REMOVE_FROM_CLIENT.read(),
                  )
                  .then((_) {
                showHarbrSuccessSnackBar(
                  title: 'Removed From Queue',
                  message: record.title,
                );
                context
                    .read<RadarrState>()
                    .api!
                    .command
                    .refreshMonitoredDownloads()
                    .then((_) => context.read<RadarrState>().fetchQueue());
              }).catchError((error, stack) {
                HarbrLogger().error(
                    'Failed to remove queue record: ${record.id}',
                    error,
                    stack);
                showHarbrErrorSnackBar(
                  title: 'Failed to Remove',
                  error: error,
                );
              });
            }
          }
        },
      ),
    ];
  }
}
