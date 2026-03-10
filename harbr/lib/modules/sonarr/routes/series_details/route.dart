import 'dart:ui';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/modules/sonarr/routes/series_details/sheets/links.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes/sonarr.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

/// Figma-spec gradient colors for media detail pages.
const _kGradientColors = [
  Color(0xFF6B5D4F), // warm brown
  Color(0xFF4A3F35), // dark brown
  Color(0xFF2D2540), // purple base
];

class SeriesDetailsRoute extends StatefulWidget {
  final int seriesId;

  const SeriesDetailsRoute({
    Key? key,
    required this.seriesId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SeriesDetailsRoute> with HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  SonarrSeries? series;

  @override
  Future<void> loadCallback() async {
    if (widget.seriesId > 0) {
      SonarrSeries? result =
          (await context.read<SonarrState>().series)![widget.seriesId];
      setState(() => series = result);
      context.read<SonarrState>().fetchQualityProfiles();
      context.read<SonarrState>().fetchLanguageProfiles();
      context.read<SonarrState>().fetchTags();
      await context.read<SonarrState>().fetchSeries(widget.seriesId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<SonarrTag> _findTags(
    List<int>? tagIds,
    List<SonarrTag> tags,
  ) {
    return tags.where((tag) => tagIds!.contains(tag.id)).toList();
  }

  SonarrQualityProfile? _findQualityProfile(
    int? qualityProfileId,
    List<SonarrQualityProfile> profiles,
  ) {
    return profiles.firstWhereOrNull(
      (profile) => profile.id == qualityProfileId,
    );
  }

  SonarrLanguageProfile? _findLanguageProfile(
    int? languageProfileId,
    List<SonarrLanguageProfile> profiles,
  ) {
    return profiles.firstWhereOrNull(
      (profile) => profile.id == languageProfileId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.seriesId <= 0) {
      return InvalidRoutePage(
        title: 'sonarr.SeriesDetails'.tr(),
        message: 'sonarr.SeriesNotFound'.tr(),
      );
    }
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.SONARR,
      appBar: _appBar() as PreferredSizeWidget?,
      extendBodyBehindAppBar: true,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: '',
      backgroundColor: Colors.transparent,
      hideLeading: true,
    );
  }

  Widget _body() {
    return Consumer<SonarrState>(
      builder: (context, state, _) => FutureBuilder(
        future: Future.wait([
          state.qualityProfiles!,
          state.languageProfiles!,
          state.tags!,
          state.series!,
        ]),
        builder: (context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              HarbrLogger().error(
                'Unable to pull Sonarr series details',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
            return HarbrMessage.error(onTap: loadCallback);
          }
          if (snapshot.hasData) {
            series =
                (snapshot.data![3] as Map<int, SonarrSeries>)[widget.seriesId];
            if (series == null) {
              return HarbrMessage.goBack(
                text: 'sonarr.SeriesNotFound'.tr(),
                context: context,
              );
            }
            SonarrQualityProfile? quality = _findQualityProfile(
              series!.qualityProfileId,
              snapshot.data![0] as List<SonarrQualityProfile>,
            );
            SonarrLanguageProfile? language = _findLanguageProfile(
              series!.languageProfileId,
              snapshot.data![1] as List<SonarrLanguageProfile>,
            );
            List<SonarrTag> tags =
                _findTags(series!.tags, snapshot.data![2] as List<SonarrTag>);
            return _heroScrollView(
              qualityProfile: quality,
              languageProfile: language,
              tags: tags,
            );
          }
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _heroScrollView({
    required SonarrQualityProfile? qualityProfile,
    required SonarrLanguageProfile? languageProfile,
    required List<SonarrTag> tags,
  }) {
    return ChangeNotifierProvider(
      create: (context) => SonarrSeriesDetailsState(
        context: context,
        series: series!,
      ),
      builder: (context, _) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _kGradientColors,
          ),
        ),
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: HarbrTokens.space32,
          ),
          children: [
            _headerButtons(context),
            _heroSection(context),
            _overviewSection(),
            _detailsSection(qualityProfile, languageProfile, tags),
            _seasonsSection(),
            _historySection(context),
            _watchStatisticsSection(),
            _castCrewSection(),
            _recommendationsSection(),
          ],
        ),
      ),
    );
  }

  /// Back + overflow header buttons with frosted glass circles.
  Widget _headerButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HarbrTokens.space16,
        vertical: HarbrTokens.space8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _glassCircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => HarbrRouter().popSafely(),
          ),
          if (series != null)
            _glassCircleButton(
              icon: Icons.more_horiz_rounded,
              onTap: () => _showOverflowMenu(context),
            ),
        ],
      ),
    );
  }

  Widget _glassCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void _showOverflowMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.harbr.surface0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HarbrTokens.radiusXl),
        ),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(HarbrIcons.LINK),
              title: const Text('Links'),
              onTap: () {
                Navigator.pop(context);
                LinksSheet(series: series!).show();
              },
            ),
            ListTile(
              leading: const Icon(HarbrIcons.EDIT),
              title: Text('sonarr.EditSeries'.tr()),
              onTap: () {
                Navigator.pop(context);
                SonarrRoutes.SERIES_EDIT.go(
                  params: {'series': widget.seriesId.toString()},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroSection(BuildContext context) {
    final harbr = context.harbr;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HarbrTokens.space16,
      ),
      child: Column(
        children: [
          // Poster — w-48 h-72 rounded-2xl shadow-2xl
          Container(
            decoration: BoxDecoration(
              borderRadius: HarbrTokens.borderRadiusXl,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: HarbrPoster(
              size: PosterSize.hero,
              url: context.read<SonarrState>().getPosterURL(series!.id),
              headers: context.read<SonarrState>().headers,
              placeholderIcon: HarbrIcons.VIDEO_CAM,
              borderRadius: HarbrTokens.borderRadiusXl,
            ),
          ),
          const SizedBox(height: HarbrTokens.space16),
          // Title — text-3xl
          Text(
            series!.title ?? '',
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          // Subtitle — year + network
          if (series!.year != null && series!.year != 0) ...[
            const SizedBox(height: HarbrTokens.space4),
            Text(
              [
                series!.year.toString(),
                if (series!.network != null && series!.network!.isNotEmpty)
                  series!.network!,
              ].join(' \u00B7 '),
              style: const TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: HarbrTokens.space16),
          // Status badges — large pill buttons
          _statusBadges(),
          // Rating badge
          if (series!.ratings?.value != null &&
              series!.ratings!.value! > 0) ...[
            const SizedBox(height: HarbrTokens.space12),
            _ratingBadge(),
          ],
          const SizedBox(height: HarbrTokens.space24),
        ],
      ),
    );
  }

  Widget _statusBadges() {
    return Wrap(
      spacing: HarbrTokens.space8,
      runSpacing: HarbrTokens.space8,
      alignment: WrapAlignment.center,
      children: [
        if (series!.monitored ?? false)
          _largePillBadge(
            icon: Icons.visibility_rounded,
            label: 'Monitored',
            color: const Color(0xFF8B7FB8), // accent
          )
        else
          _largePillBadge(
            icon: Icons.visibility_off_rounded,
            label: 'Unmonitored',
            color: const Color(0xFF484F58), // faint
          ),
        if (series!.status == 'continuing')
          _largePillBadge(
            icon: Icons.play_circle_outline_rounded,
            label: 'Continuing',
            color: const Color(0xFF3FB950), // green
          ),
        if (series!.status == 'ended')
          _largePillBadge(
            icon: Icons.stop_circle_outlined,
            label: 'Ended',
            color: const Color(0xFF484F58),
          ),
        if (series!.status == 'upcoming')
          _largePillBadge(
            icon: Icons.schedule_rounded,
            label: 'Upcoming',
            color: const Color(0xFF58A6FF),
          ),
      ],
    );
  }

  /// Large pill badge matching Figma spec: px-6 py-3 rounded-2xl.
  Widget _largePillBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isNegative = color == const Color(0xFF484F58);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isNegative
            ? const Color(0xFF3D3550)
            : color.withValues(alpha: 0.2),
        borderRadius: HarbrTokens.borderRadiusXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isNegative ? Colors.white70 : color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isNegative ? Colors.white70 : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Rating badge — Figma: px-8 py-4 bg-black/30 backdrop-blur rounded-2xl.
  Widget _ratingBadge() {
    final rating = series!.ratings!.value!;
    final displayRating =
        rating > 10 ? rating.toStringAsFixed(0) : rating.toStringAsFixed(1);
    return ClipRRect(
      borderRadius: HarbrTokens.borderRadiusXl,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: HarbrTokens.borderRadiusXl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayRating,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'TVDB',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overviewSection() {
    final overview = series!.overview;
    final hasOverview = overview != null && overview.isNotEmpty;
    final genres = series!.genres;
    final hasGenres = genres != null && genres.isNotEmpty;

    return HarbrCollapsibleSection(
      title: 'Overview',
      initiallyExpanded: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          HarbrTokens.lg,
          0,
          HarbrTokens.lg,
          HarbrTokens.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                final harbr = context.harbr;
                return GestureDetector(
                  onTap: hasOverview
                      ? () async => HarbrDialogs()
                          .textPreview(context, series!.title, overview)
                      : null,
                  child: Text(
                    hasOverview
                        ? overview
                        : 'sonarr.NoSummaryAvailable'.tr(),
                    style: TextStyle(
                      color: harbr.onSurfaceDim,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            if (hasGenres) ...[
              const SizedBox(height: HarbrTokens.space12),
              Builder(
                builder: (context) {
                  return Wrap(
                    spacing: HarbrTokens.space6,
                    runSpacing: HarbrTokens.space4,
                    children: genres
                        .map(
                          (g) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: HarbrTokens.borderRadiusPill,
                            ),
                            child: Text(
                              g,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailsSection(
    SonarrQualityProfile? qualityProfile,
    SonarrLanguageProfile? languageProfile,
    List<SonarrTag> tags,
  ) {
    return HarbrCollapsibleSection(
      title: 'Details',
      initiallyExpanded: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          HarbrTokens.lg,
          0,
          HarbrTokens.lg,
          HarbrTokens.lg,
        ),
        child: SonarrSeriesDetailsOverviewInformationBlock(
          series: series,
          qualityProfile: qualityProfile,
          languageProfile: languageProfile,
          tags: tags,
        ),
      ),
    );
  }

  Widget _seasonsSection() {
    return HarbrCollapsibleSection(
      title: 'Seasons',
      initiallyExpanded: false,
      child: _SonarrSeasonsContent(series: series),
    );
  }

  Widget _historySection(BuildContext context) {
    return HarbrCollapsibleSection(
      title: 'History',
      initiallyExpanded: false,
      child: _SonarrHistoryContent(),
    );
  }

  Widget _watchStatisticsSection() {
    return HarbrCollapsibleSection(
      title: 'Watch Statistics',
      initiallyExpanded: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          HarbrTokens.lg,
          0,
          HarbrTokens.lg,
          HarbrTokens.lg,
        ),
        child: Text(
          'Connect Tautulli in Settings to view watch statistics for this series.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _castCrewSection() {
    return HarbrCollapsibleSection(
      title: 'Cast & Crew',
      initiallyExpanded: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          HarbrTokens.lg,
          0,
          HarbrTokens.lg,
          HarbrTokens.lg,
        ),
        child: Text(
          'Connect Overseerr or Jellyseerr in Settings to view cast and crew information.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _recommendationsSection() {
    return HarbrCollapsibleSection(
      title: 'Recommendations',
      initiallyExpanded: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          HarbrTokens.lg,
          0,
          HarbrTokens.lg,
          HarbrTokens.lg,
        ),
        child: Text(
          'Connect Overseerr or Jellyseerr in Settings to view recommendations.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

/// Inline seasons content widget with Figma-style season cards.
///
/// Each season is shown as a card with a completion count pill that has
/// a green border when complete and a red border when incomplete.
class _SonarrSeasonsContent extends StatelessWidget {
  final SonarrSeries? series;

  const _SonarrSeasonsContent({required this.series});

  @override
  Widget build(BuildContext context) {
    if (series?.seasons?.isEmpty ?? true) {
      return Padding(
        padding: HarbrTokens.paddingLg,
        child: Center(
          child: Text(
            'sonarr.NoSeasonsFound'.tr(),
            style: TextStyle(
              color: context.harbr.onSurfaceDim,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    List<SonarrSeriesSeason> seasons = List.from(series!.seasons!);
    seasons.sort((a, b) => a.seasonNumber!.compareTo(b.seasonNumber!));
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HarbrTokens.lg,
        0,
        HarbrTokens.lg,
        HarbrTokens.lg,
      ),
      child: Wrap(
        spacing: HarbrTokens.space8,
        runSpacing: HarbrTokens.space8,
        children: [
          if (seasons.length > 1)
            _buildSeasonCard(
              context,
              label: 'All Seasons',
              season: null,
            ),
          ...seasons.reversed.map(
            (season) => _buildSeasonCard(
              context,
              label: season.seasonNumber == 0
                  ? 'Specials'
                  : 'Season ${season.seasonNumber}',
              season: season,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonCard(
    BuildContext context, {
    required String label,
    required SonarrSeriesSeason? season,
  }) {
    final stats = season?.statistics;
    final episodeCount = stats?.episodeCount ?? 0;
    final episodeFileCount = stats?.episodeFileCount ?? 0;
    final isComplete = episodeCount > 0 && episodeFileCount >= episodeCount;
    final pillColor =
        isComplete ? const Color(0xFF3FB950) : const Color(0xFFF85149);

    return GestureDetector(
      onTap: () {
        if (season != null) {
          SonarrRoutes.SERIES_SEASON.go(params: {
            'series': series!.id.toString(),
            'season': season.seasonNumber.toString(),
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: HarbrTokens.borderRadiusLg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (season != null && episodeCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: HarbrTokens.borderRadiusPill,
                  border: Border.all(
                    color: pillColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '$episodeFileCount/$episodeCount',
                  style: TextStyle(
                    color: pillColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline history content widget that replaces the old page.
class _SonarrHistoryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.select<SonarrSeriesDetailsState,
          Future<List<SonarrHistoryRecord>>?>((s) => s.history),
      builder: (context, AsyncSnapshot<List<SonarrHistoryRecord>> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: HarbrTokens.paddingLg,
            child: HarbrMessage.error(
              onTap: () => context
                  .read<SonarrSeriesDetailsState>()
                  .fetchHistory(context),
            ),
          );
        }
        if (snapshot.hasData) {
          final history = snapshot.data!;
          if (history.isEmpty) {
            return Padding(
              padding: HarbrTokens.paddingLg,
              child: Center(
                child: Text(
                  'sonarr.NoHistoryFound'.tr(),
                  style: TextStyle(
                    color: context.harbr.onSurfaceDim,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: history
                .map((h) => SonarrHistoryTile(
                      history: h,
                      type: SonarrHistoryTileType.SERIES,
                    ))
                .toList(),
          );
        }
        return const Padding(
          padding: HarbrTokens.paddingLg,
          child: Center(child: HarbrLoader()),
        );
      },
    );
  }
}
