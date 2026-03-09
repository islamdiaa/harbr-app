import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

class SonarrEpisodeDetailsSheet extends HarbrBottomModalSheet {
  BuildContext context;
  SonarrEpisode? episode;
  SonarrEpisodeFile? episodeFile;
  List<SonarrQueueRecord>? queueRecords;

  SonarrEpisodeDetailsSheet({
    required this.context,
    required this.episode,
    required this.episodeFile,
    required this.queueRecords,
  }) {
    _intializeSheet();
  }

  Future<void> _intializeSheet() async {
    SonarrSeasonDetailsState _state = context.read<SonarrSeasonDetailsState>();
    _state.currentEpisodeId = episode!.id;
    _state.episodeSearchState = HarbrLoadingState.INACTIVE;
    _state.fetchState(
      context,
      shouldFetchEpisodes: false,
      shouldFetchFiles: false,
      shouldFetchHistory: false,
    );
  }

  Widget _highlightedNodes(BuildContext context) {
    List<HarbrHighlightedNode> _nodes = [
      if (!episode!.monitored!)
        HarbrHighlightedNode(
          text: 'sonarr.Unmonitored'.tr(),
          backgroundColor: HarbrColours.red,
        ),
      if (episode!.hasFile! && episodeFile != null)
        HarbrHighlightedNode(
          backgroundColor: episodeFile!.qualityCutoffNotMet!
              ? HarbrColours.orange
              : HarbrColours.accent,
          text: episodeFile!.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH,
        ),
      if (episode!.hasFile! &&
          episodeFile != null &&
          episodeFile!.languageCutoffNotMet != null)
        HarbrHighlightedNode(
          backgroundColor: episodeFile!.languageCutoffNotMet!
              ? HarbrColours.orange
              : HarbrColours.accent,
          text: episodeFile!.language?.name ?? HarbrUI.TEXT_EMDASH,
        ),
      if (episode!.hasFile! && episodeFile != null)
        HarbrHighlightedNode(
          backgroundColor: HarbrColours.blueGrey,
          text: episodeFile!.size?.asBytes() ?? HarbrUI.TEXT_EMDASH,
        ),
      if (!episode!.hasFile! &&
          (episode?.airDateUtc?.toLocal().isAfter(DateTime.now()) ?? true))
        HarbrHighlightedNode(
          backgroundColor: HarbrColours.blue,
          text: 'sonarr.Unaired'.tr(),
        ),
      if (!episode!.hasFile! &&
          (episode?.airDateUtc?.toLocal().isBefore(DateTime.now()) ?? false))
        HarbrHighlightedNode(
          backgroundColor: HarbrColours.red,
          text: 'sonarr.Missing'.tr(),
        ),
    ];
    if (_nodes.isEmpty) return const SizedBox(height: 0, width: 0);
    return Padding(
      child: Wrap(
        direction: Axis.horizontal,
        spacing: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
        runSpacing: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
        children: _nodes,
      ),
      padding: HarbrUI.MARGIN_H_DEFAULT_V_HALF.copyWith(top: 0),
    );
  }

  List<Widget> _episodeDetails(BuildContext context) {
    return [
      HarbrHeader(
        text: episode!.title,
        subtitle: [
          episode!.airDateUtc != null
              ? DateFormat.yMMMMd().format(episode!.airDateUtc!.toLocal())
              : 'harbr.UnknownDate'.tr(),
          '\n',
          'sonarr.SeasonNumber'.tr(
            args: [episode?.seasonNumber?.toString() ?? HarbrUI.TEXT_EMDASH],
          ),
          HarbrUI.TEXT_BULLET.pad(),
          'sonarr.EpisodeNumber'.tr(
            args: [episode?.episodeNumber?.toString() ?? HarbrUI.TEXT_EMDASH],
          ),
          if (episode?.absoluteEpisodeNumber != null)
            ' (${episode!.absoluteEpisodeNumber})',
        ].join(),
      ),
      _highlightedNodes(context),
      Padding(
        padding: HarbrUI.MARGIN_DEFAULT_HORIZONTAL,
        child: HarbrText.subtitle(
          text: episode!.overview ?? 'sonarr.NoSummaryAvailable'.tr(),
          maxLines: 0,
          softWrap: true,
        ),
      ),
    ];
  }

  List<Widget> _files(BuildContext context) {
    if (!episode!.hasFile! || episodeFile == null) return [];
    return [
      HarbrTableCard(
        content: [
          HarbrTableContent(
            title: 'sonarr.RelativePath'.tr(),
            body: episodeFile!.relativePath ?? HarbrUI.TEXT_EMDASH,
          ),
          HarbrTableContent(
            title: 'sonarr.Video'.tr(),
            body: episodeFile?.mediaInfo?.videoCodec,
          ),
          HarbrTableContent(
            title: 'sonarr.Audio'.tr(),
            body: [
              episodeFile?.mediaInfo?.audioCodec ?? HarbrUI.TEXT_EMDASH,
              if (episodeFile?.mediaInfo?.audioChannels != null)
                episodeFile?.mediaInfo?.audioChannels?.toString(),
            ].join(HarbrUI.TEXT_BULLET.pad()),
          ),
          HarbrTableContent(
            title: 'sonarr.Size'.tr(),
            body: episodeFile!.size?.asBytes() ?? HarbrUI.TEXT_EMDASH,
          ),
          HarbrTableContent(
            title: 'sonarr.AddedOn'.tr(),
            body: episodeFile?.dateAdded?.asDateTime(delimiter: '\n'),
          ),
        ],
        buttons: [
          if (episodeFile?.mediaInfo != null)
            HarbrButton.text(
              text: 'sonarr.MediaInfo'.tr(),
              icon: Icons.info_outline_rounded,
              onTap: () async =>
                  SonarrMediaInfoSheet(mediaInfo: episodeFile!.mediaInfo)
                      .show(),
            ),
          HarbrButton(
            type: HarbrButtonType.TEXT,
            text: 'harbr.Delete'.tr(),
            icon: Icons.delete_rounded,
            onTap: () async {
              bool result = await SonarrDialogs().deleteEpisode(context);
              if (result) {
                SonarrAPIController()
                    .deleteEpisode(
                        context: context,
                        episode: episode!,
                        episodeFile: episodeFile!)
                    .then((_) {
                  episode!.hasFile = false;
                  context
                      .read<SonarrSeasonDetailsState>()
                      .fetchHistory(context);
                  context
                      .read<SonarrSeasonDetailsState>()
                      .fetchEpisodeHistory(context, episode!.id);
                });
              }
            },
            color: HarbrColours.red,
          ),
        ],
      ),
    ];
  }

  List<Widget> _queue(BuildContext context) {
    if (queueRecords?.isNotEmpty ?? false) {
      return queueRecords!
          .map((r) => SonarrQueueTile(
                queueRecord: r,
                type: SonarrQueueTileType.EPISODE,
              ))
          .toList();
    }
    return [];
  }

  List<Widget> _history(BuildContext context) {
    return [
      FutureBuilder(
        future: context
            .select<SonarrSeasonDetailsState, Future<SonarrHistoryPage?>>(
          (s) => s.getEpisodeHistory(episode!.id!),
        ),
        builder:
            (BuildContext context, AsyncSnapshot<SonarrHistoryPage?> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              HarbrLogger().error(
                'Unable to fetch Sonarr episode history ${episode!.id}',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
          }
          if (snapshot.hasData) {
            if (snapshot.data!.records!.isEmpty)
              return Padding(
                child: HarbrMessage.inList(
                  text: 'sonarr.NoHistoryFound'.tr(),
                ),
                padding: const EdgeInsets.only(
                    bottom: HarbrUI.DEFAULT_MARGIN_SIZE / 2),
              );
            return Padding(
              child: Column(
                children: List.generate(
                  snapshot.data!.records!.length,
                  (index) => SonarrHistoryTile(
                    history: snapshot.data!.records![index],
                    episode: episode,
                    type: SonarrHistoryTileType.EPISODE,
                  ),
                ),
              ),
              padding:
                  const EdgeInsets.only(bottom: HarbrUI.DEFAULT_MARGIN_SIZE / 2),
            );
          }
          return const Padding(
            child: HarbrLoader(
              useSafeArea: false,
              size: 16.0,
            ),
            padding: EdgeInsets.only(
              bottom: HarbrUI.DEFAULT_MARGIN_SIZE * 1.5,
              top: HarbrUI.DEFAULT_MARGIN_SIZE,
            ),
          );
        },
      ),
    ];
  }

  Widget _actionBar(BuildContext context) {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton(
          loadingState:
              context.select<SonarrSeasonDetailsState, HarbrLoadingState>(
                  (s) => s.episodeSearchState),
          type: HarbrButtonType.TEXT,
          text: 'sonarr.Automatic'.tr(),
          icon: Icons.search_rounded,
          onTap: () async {
            context.read<SonarrSeasonDetailsState>().episodeSearchState =
                HarbrLoadingState.ACTIVE;
            SonarrAPIController()
                .episodeSearch(context: context, episode: episode!)
                .whenComplete(() => context
                    .read<SonarrSeasonDetailsState>()
                    .episodeSearchState = HarbrLoadingState.INACTIVE);
          },
        ),
        HarbrButton.text(
          text: 'sonarr.Interactive'.tr(),
          icon: Icons.person_rounded,
          onTap: () {
            SonarrRoutes.RELEASES.go(queryParams: {
              'episode': episode!.id!.toString(),
            });
            context.read<SonarrSeasonDetailsState>().fetchState(
                  context,
                  shouldFetchEpisodes: false,
                  shouldFetchFiles: false,
                );
          },
        ),
      ],
    );
  }

  @override
  Widget builder(BuildContext context) {
    return ChangeNotifierProvider<SonarrSeasonDetailsState>.value(
      value: this.context.watch<SonarrSeasonDetailsState>(),
      builder: (context, _) => Consumer<SonarrSeasonDetailsState>(
        builder: (context, state, _) => FutureBuilder(
          future: Future.wait([
            state.episodes!,
            state.files!,
            state.queue,
            state.getEpisodeHistory(episode!.id!),
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              SonarrEpisode? _e =
                  (snapshot.data[0] as Map<int, SonarrEpisode>)[episode!.id!];
              episode = _e;
              SonarrEpisodeFile? _ef = (snapshot.data[1]
                  as Map<int, SonarrEpisodeFile>)[episode!.episodeFileId!];
              episodeFile = _ef;
              List<SonarrQueueRecord> _qr =
                  (snapshot.data[2] as List<SonarrQueueRecord>)
                      .where((q) => q.episodeId == episode!.id)
                      .toList();
              queueRecords = _qr;
            }
            return HarbrListViewModal(
              children: [
                ..._episodeDetails(context),
                ..._queue(context),
                ..._files(context),
                ..._history(context),
              ],
              actionBar: _actionBar(context) as HarbrBottomActionBar?,
            );
          },
        ),
      ),
    );
  }
}
