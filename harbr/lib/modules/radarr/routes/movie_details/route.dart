import 'dart:ui' as ui;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/modules/radarr/routes/movie_details/sheets/links.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes/radarr.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

/// Figma-spec gradient colors for media detail pages.
/// Transparent canvas → opaque canvas (#1A1525).
const _kGradientColors = [
  Color(0x661A1525), // 40% canvas
  Color(0xCC1A1525), // 80% canvas
  Color(0xFF1A1525), // 100% canvas
];

class MovieDetailsRoute extends StatefulWidget {
  final int movieId;

  const MovieDetailsRoute({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MovieDetailsRoute> with HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  RadarrMovie? movie;

  @override
  Future<void> loadCallback() async {
    if (widget.movieId > 0) {
      RadarrMovie? result =
          _findMovie(await context.read<RadarrState>().movies!);
      setState(() => movie = result);
      context.read<RadarrState>().fetchQualityProfiles();
      context.read<RadarrState>().fetchTags();
      await context.read<RadarrState>().resetSingleMovie(widget.movieId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  RadarrMovie? _findMovie(List<RadarrMovie> movies) {
    return movies.firstWhereOrNull(
      (movie) => movie.id == widget.movieId,
    );
  }

  List<RadarrTag> _findTags(List<int?>? tagIds, List<RadarrTag> tags) {
    return tags.where((tag) => tagIds!.contains(tag.id)).toList();
  }

  RadarrQualityProfile? _findQualityProfile(
      int? profileId, List<RadarrQualityProfile> profiles) {
    return profiles.firstWhereOrNull(
      (profile) => profile.id == profileId,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movieId <= 0)
      return InvalidRoutePage(
        title: 'Movie Details',
        message: 'Movie Not Found',
      );
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.RADARR,
      appBar: _appBar(),
      extendBodyBehindAppBar: true,
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: '',
      backgroundColor: Colors.transparent,
      hideLeading: true,
    );
  }

  Widget _body() {
    return Consumer<RadarrState>(
      builder: (context, state, _) => FutureBuilder(
        future: Future.wait([
          state.qualityProfiles!,
          state.tags!,
          state.movies!,
        ]),
        builder: (context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              HarbrLogger().error(
                'Unable to pull Radarr movie details',
                snapshot.error,
                snapshot.stackTrace,
              );
            return HarbrMessage.error(onTap: loadCallback);
          }
          if (snapshot.hasData) {
            movie = _findMovie(snapshot.data![2] as List<RadarrMovie>);
            if (movie == null)
              return HarbrMessage.goBack(
                text: 'Movie Not Found',
                context: context,
              );
            RadarrQualityProfile? qualityProfile = _findQualityProfile(
                movie!.qualityProfileId,
                snapshot.data![0] as List<RadarrQualityProfile>);
            List<RadarrTag> tags =
                _findTags(movie!.tags, snapshot.data![1] as List<RadarrTag>);
            return _heroScrollView(qualityProfile, tags);
          }
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _heroScrollView(
      RadarrQualityProfile? qualityProfile, List<RadarrTag> tags) {
    return ChangeNotifierProvider(
      create: (context) =>
          RadarrMovieDetailsState(context: context, movie: movie!),
      builder: (context, _) {
        final posterUrl =
            context.read<RadarrState>().getPosterURL(movie!.id);
        return Stack(
          children: [
            // Blurred poster background
            if (posterUrl != null && posterUrl.isNotEmpty)
              Positioned.fill(
                child: ClipRect(
                  child: ImageFiltered(
                    imageFilter:
                        ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Transform.scale(
                      scale: 1.1,
                      child: Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(0.3),
                        errorBuilder: (_, __, ___) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
            // Gradient overlay
            Container(
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
                  _searchActions(context),
                  _overviewSection(),
                  _detailsSection(qualityProfile, tags),
                  _filesSection(context),
                  _historySection(context),
                  _castCrewSection(context),
                  _watchStatisticsSection(),
                  _recommendationsSection(),
                ],
              ),
            ),
          ],
        );
      },
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
          if (movie != null)
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
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
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
                LinksSheet(movie: movie!).show();
              },
            ),
            ListTile(
              leading: const Icon(HarbrIcons.EDIT),
              title: const Text('Edit Movie'),
              onTap: () {
                Navigator.pop(context);
                RadarrRoutes.MOVIE_EDIT.go(params: {
                  'movie': widget.movieId.toString(),
                });
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
              url: context.read<RadarrState>().getPosterURL(movie!.id),
              headers: context.read<RadarrState>().headers,
              placeholderIcon: HarbrIcons.VIDEO_CAM,
              borderRadius: HarbrTokens.borderRadiusXl,
            ),
          ),
          const SizedBox(height: HarbrTokens.space16),
          // Title — text-3xl
          Text(
            movie!.title ?? '',
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          // Subtitle — year + studio
          if (movie!.year != null && movie!.year != 0) ...[
            const SizedBox(height: HarbrTokens.space4),
            Text(
              [
                movie!.year.toString(),
                if (movie!.studio != null && movie!.studio!.isNotEmpty)
                  movie!.studio!,
              ].join(' \u00B7 '),
              style: TextStyle(
                color: harbr.onSurfaceDim,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: HarbrTokens.space16),
          // Status badges — large pill buttons
          _statusBadges(),
          // Rating badge
          if (movie!.ratings?.value != null && movie!.ratings!.value! > 0) ...[
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
        if (!(movie!.hasFile ?? false) && (movie!.monitored ?? false))
          const HarbrStatusBadge(
            type: StatusType.missing,
            medium: true,
          ),
        if (movie!.hasFile ?? false)
          const HarbrStatusBadge(
            type: StatusType.downloaded,
            medium: true,
          ),
        if (movie!.status == RadarrAvailability.ANNOUNCED)
          const HarbrStatusBadge(
            type: StatusType.upcoming,
            label: 'Announced',
            medium: true,
          ),
        if (movie!.status == RadarrAvailability.IN_CINEMAS)
          const HarbrStatusBadge(
            type: StatusType.upcoming,
            label: 'In Cinemas',
            medium: true,
          ),
      ],
    );
  }

  /// Ratings grid — Figma: card with 3-column grid (IMDb, RT, TMDB).
  Widget _ratingBadge() {
    final rating = movie!.ratings!.value!;
    final displayRating =
        rating > 10 ? rating.toStringAsFixed(0) : rating.toStringAsFixed(1);

    return Builder(
      builder: (context) {
        final harbr = context.harbr;
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HarbrTokens.space16,
            vertical: HarbrTokens.space12,
          ),
          decoration: BoxDecoration(
            color: harbr.surface0,
            borderRadius: HarbrTokens.borderRadius12,
            border: Border.all(color: harbr.border),
          ),
          child: Row(
            children: [
              // IMDb
              Expanded(child: _ratingColumn('—', 'IMDb', harbr)),
              // Rotten Tomatoes
              Expanded(child: _ratingColumn('—', 'RT', harbr)),
              // TMDB
              Expanded(child: _ratingColumn(displayRating, 'TMDB', harbr)),
            ],
          ),
        );
      },
    );
  }

  Widget _ratingColumn(String value, String label, HarbrThemeData harbr) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: harbr.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: harbr.onSurfaceDim,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _searchActions(BuildContext context) {
    return Padding(
      padding: HarbrTokens.paddingCard,
      child: Row(
        children: [
          Expanded(
            child: _RadarrSearchButton(movie: movie!),
          ),
          const SizedBox(width: HarbrTokens.space8),
          Expanded(
            child: HarbrButton.text(
              text: 'Interactive',
              icon: Icons.person_rounded,
              onTap: () async {
                RadarrRoutes.MOVIE_RELEASES.go(params: {
                  'movie': movie!.id!.toString(),
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewSection() {
    final overview = movie!.overview;
    final hasOverview = overview != null && overview.isNotEmpty;
    final genres = movie!.genres;
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
                          .textPreview(context, movie!.title, overview)
                      : null,
                  child: Text(
                    hasOverview ? overview : 'No summary available.',
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
                  final harbr = context.harbr;
                  return Text(
                    genres.join(', '),
                    style: TextStyle(color: harbr.accent, fontSize: 13),
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
      RadarrQualityProfile? qualityProfile, List<RadarrTag> tags) {
    return HarbrCollapsibleSection(
      title: 'Details',
      initiallyExpanded: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          HarbrTokens.lg,
          0,
          HarbrTokens.lg,
          HarbrTokens.lg,
        ),
        child: RadarrMovieDetailsOverviewInformationBlock(
          movie: movie,
          qualityProfile: qualityProfile,
          tags: tags,
        ),
      ),
    );
  }

  Widget _filesSection(BuildContext context) {
    return HarbrCollapsibleSection(
      title: 'Files',
      initiallyExpanded: false,
      child: const _RadarrFilesContent(),
    );
  }

  Widget _historySection(BuildContext context) {
    return HarbrCollapsibleSection(
      title: 'History',
      initiallyExpanded: false,
      child: _RadarrHistoryContent(movie: movie),
    );
  }

  Widget _castCrewSection(BuildContext context) {
    return HarbrCollapsibleSection(
      title: 'Cast & Crew',
      initiallyExpanded: false,
      child: _RadarrCastCrewContent(movie: movie),
    );
  }

  Widget _watchStatisticsSection() {
    return HarbrCollapsibleSection(
      title: 'Watch Statistics',
      initiallyExpanded: false,
      child: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(
            HarbrTokens.lg,
            0,
            HarbrTokens.lg,
            HarbrTokens.lg,
          ),
          child: Text(
            'Connect Tautulli in Settings to view watch statistics for this movie.',
            style: TextStyle(
              color: context.harbr.onSurfaceDim,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _recommendationsSection() {
    return HarbrCollapsibleSection(
      title: 'Recommendations',
      initiallyExpanded: false,
      child: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.fromLTRB(
            HarbrTokens.lg,
            0,
            HarbrTokens.lg,
            HarbrTokens.lg,
          ),
          child: Text(
            'Connect Overseerr or Jellyseerr in Settings to view recommendations.',
            style: TextStyle(
              color: context.harbr.onSurfaceDim,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Extracted automatic search button with its own loading state.
class _RadarrSearchButton extends StatefulWidget {
  final RadarrMovie movie;

  const _RadarrSearchButton({required this.movie});

  @override
  State<_RadarrSearchButton> createState() => _RadarrSearchButtonState();
}

class _RadarrSearchButtonState extends State<_RadarrSearchButton> {
  HarbrLoadingState _loadingState = HarbrLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    return HarbrButton(
      type: HarbrButtonType.TEXT,
      text: 'Automatic',
      icon: Icons.search_rounded,
      loadingState: _loadingState,
      onTap: () async {
        setState(() => _loadingState = HarbrLoadingState.ACTIVE);
        RadarrAPIHelper()
            .automaticSearch(
                context: context,
                movieId: widget.movie.id!,
                title: widget.movie.title!)
            .then((value) {
          if (mounted)
            setState(() {
              _loadingState =
                  value ? HarbrLoadingState.INACTIVE : HarbrLoadingState.ERROR;
            });
        });
      },
    );
  }
}

/// Inline files content widget that replaces the old page.
class _RadarrFilesContent extends StatelessWidget {
  const _RadarrFilesContent();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        context.watch<RadarrMovieDetailsState>().movieFiles,
        context.watch<RadarrMovieDetailsState>().extraFiles,
      ]),
      builder: (context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: HarbrTokens.paddingLg,
            child: HarbrMessage.error(
              onTap: () => context
                  .read<RadarrMovieDetailsState>()
                  .fetchFiles(context),
            ),
          );
        }
        if (snapshot.hasData) {
          final movieFiles =
              snapshot.requireData[0] as List<RadarrMovieFile>;
          final extraFiles =
              snapshot.requireData[1] as List<RadarrExtraFile>;
          if (movieFiles.isEmpty && extraFiles.isEmpty) {
            return Padding(
              padding: HarbrTokens.paddingLg,
              child: Center(
                child: Text(
                  'No Files Found',
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
            children: [
              ...movieFiles.map(
                (f) => RadarrMovieDetailsFilesFileBlock(file: f),
              ),
              ...extraFiles.map(
                (f) => RadarrMovieDetailsFilesExtraFileBlock(file: f),
              ),
            ],
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

/// Inline history content widget that replaces the old page.
class _RadarrHistoryContent extends StatelessWidget {
  final RadarrMovie? movie;

  const _RadarrHistoryContent({required this.movie});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<RadarrMovieDetailsState>().history,
      builder: (context, AsyncSnapshot<List<RadarrHistoryRecord>> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: HarbrTokens.paddingLg,
            child: HarbrMessage.error(
              onTap: () => context
                  .read<RadarrMovieDetailsState>()
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
                  'No History Found',
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
                .map((h) =>
                    RadarrHistoryTile(history: h, movieHistory: true))
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

/// Inline cast & crew content widget that replaces the old page.
class _RadarrCastCrewContent extends StatelessWidget {
  final RadarrMovie? movie;

  const _RadarrCastCrewContent({required this.movie});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<RadarrMovieDetailsState>().credits,
      builder: (context, AsyncSnapshot<List<RadarrMovieCredits>> snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: HarbrTokens.paddingLg,
            child: HarbrMessage.error(
              onTap: () => context
                  .read<RadarrMovieDetailsState>()
                  .fetchCredits(context),
            ),
          );
        }
        if (snapshot.hasData) {
          final credits = snapshot.data!;
          if (credits.isEmpty) {
            return Padding(
              padding: HarbrTokens.paddingLg,
              child: Center(
                child: Text(
                  'No Credits Found',
                  style: TextStyle(
                    color: context.harbr.onSurfaceDim,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }
          List<RadarrMovieCredits> cast = credits
              .where((c) => c.type == RadarrCreditType.CAST)
              .toList();
          List<RadarrMovieCredits> crew = credits
              .where((c) => c.type == RadarrCreditType.CREW)
              .toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...cast.map(
                  (c) => RadarrMovieDetailsCastCrewTile(credits: c)),
              ...crew.map(
                  (c) => RadarrMovieDetailsCastCrewTile(credits: c)),
            ],
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
