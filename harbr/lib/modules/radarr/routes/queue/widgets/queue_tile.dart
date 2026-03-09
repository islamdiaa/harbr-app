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
        return HarbrExpandableListTile(
          title: record.title!,
          collapsedSubtitles: [
            _subtitle1(),
            _subtitle2(),
          ],
          expandedHighlightedNodes: _highlightedNodes(),
          expandedTableContent: _tableContent(movie),
          expandedTableButtons: _tableButtons(context),
          collapsedTrailing: HarbrIconButton(
            icon: record.harbrStatusIcon,
            color: record.harbrStatusColor,
          ),
          onLongPress: () => RadarrRoutes.MOVIE.go(params: {
            'movie': record.movieId!.toString(),
          }),
        );
      },
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(text: record.harbrMovieTitle(movie!));
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(
          text: record.harbrQuality,
          style: const TextStyle(
            color: HarbrColours.accent,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: record.timeLeft ?? HarbrUI.TEXT_EMDASH),
      ],
    );
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
