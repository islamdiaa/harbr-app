import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/book_details/sheets/links.dart';
import 'package:harbr/modules/readarr/routes/book_details/state.dart';
import 'package:harbr/modules/readarr/routes/book_details/widgets/appbar_settings_action.dart';
import 'package:harbr/modules/readarr/routes/history/widgets/history_tile.dart';
import 'package:harbr/router/routes/readarr.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ReadarrBookDetailsRoute extends StatefulWidget {
  final int bookId;

  const ReadarrBookDetailsRoute({
    Key? key,
    required this.bookId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrBookDetailsRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookId <= 0) {
      return InvalidRoutePage(
        title: 'readarr.BookDetails'.tr(),
        message: 'readarr.BookNotFound'.tr(),
      );
    }
    return ChangeNotifierProvider(
      create: (context) => ReadarrBookDetailsState(
        context: context,
        bookId: widget.bookId,
      ),
      builder: (context, _) {
        return FutureBuilder(
          future: context.watch<ReadarrBookDetailsState>().book,
          builder: (context, AsyncSnapshot<ReadarrBook> snapshot) {
            return HarbrScaffold(
              scaffoldKey: _scaffoldKey,
              module: HarbrModule.READARR,
              appBar: _appBar(snapshot.data),
              body: _body(context, snapshot),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _appBar(ReadarrBook? book) {
    List<Widget>? actions;

    if (book != null) {
      actions = [
        HarbrIconButton(
          icon: HarbrIcons.LINK,
          onPressed: () async {
            ReadarrBookDetailsLinksSheet(book: book).show();
          },
        ),
        ReadarrBookDetailsAppBarSettingsAction(bookId: widget.bookId),
      ];
    }

    return HarbrAppBar(
      title: 'readarr.BookDetails'.tr(),
      scrollControllers: [_scrollController],
      actions: actions,
    );
  }

  Widget _body(BuildContext context, AsyncSnapshot<ReadarrBook> snapshot) {
    if (snapshot.hasError) {
      if (snapshot.connectionState != ConnectionState.waiting) {
        HarbrLogger().error(
          'Unable to fetch Readarr book details',
          snapshot.error,
          snapshot.stackTrace,
        );
      }
      return HarbrMessage.error(
        onTap: () {
          context.read<ReadarrBookDetailsState>().fetchBook(context);
          context.read<ReadarrBookDetailsState>().fetchHistory(context);
        },
      );
    }
    if (snapshot.hasData) return _content(context, snapshot.data!);
    return const HarbrLoader();
  }

  Widget _content(BuildContext context, ReadarrBook book) {
    return HarbrListView(
      controller: _scrollController,
      children: [
        _heroSection(context, book),
        _actionButtons(context, book),
        _metadataSection(book),
        _descriptionSection(book),
        _historySection(context),
      ],
    );
  }

  /// Hero section: poster + title + author + status badge
  Widget _heroSection(BuildContext context, ReadarrBook book) {
    final harbr = context.harbr;

    return Padding(
      padding: HarbrTokens.paddingLg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HarbrPoster(
            url: context.read<ReadarrState>().getBookCoverURL(book),
            headers: context.read<ReadarrState>().headers,
            placeholderIcon: Icons.book_rounded,
            size: PosterSize.xl,
          ),
          const SizedBox(width: HarbrTokens.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title ?? HarbrUI.TEXT_EMDASH,
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HarbrTokens.xs),
                Text(
                  book.harbrAuthorTitle,
                  style: TextStyle(
                    color: harbr.onSurfaceDim,
                    fontSize: 14.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HarbrTokens.sm),
                Wrap(
                  spacing: HarbrTokens.xs,
                  runSpacing: HarbrTokens.xs,
                  children: [
                    _fileStatusBadge(book),
                    _monitoredBadge(book),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileStatusBadge(ReadarrBook book) {
    if (book.harbrHasFile) {
      return const HarbrStatusBadge(type: StatusType.downloaded);
    }
    if (book.harbrIsGrabbed) {
      return const HarbrStatusBadge(type: StatusType.queued);
    }
    return const HarbrStatusBadge(type: StatusType.missing);
  }

  Widget _monitoredBadge(ReadarrBook book) {
    return HarbrStatusBadge(
      type: book.harbrIsMonitored
          ? StatusType.monitored
          : StatusType.unmonitored,
    );
  }

  /// Action buttons row: Monitor, Search, Edit
  Widget _actionButtons(BuildContext context, ReadarrBook book) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HarbrTokens.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              context: context,
              icon: book.harbrIsMonitored
                  ? Icons.turned_in_rounded
                  : Icons.turned_in_not_rounded,
              label: book.harbrIsMonitored
                  ? 'readarr.Monitored'.tr()
                  : 'readarr.Unmonitored'.tr(),
              onTap: () {
                ReadarrAPIController()
                    .toggleBookMonitored(
                  context: context,
                  book: book,
                )
                    .then((success) {
                  if (success) {
                    context
                        .read<ReadarrBookDetailsState>()
                        .fetchBook(context);
                  }
                });
              },
            ),
          ),
          const SizedBox(width: HarbrTokens.sm),
          Expanded(
            child: _actionButton(
              context: context,
              icon: Icons.search_rounded,
              label: 'readarr.Search'.tr(),
              onTap: () {
                ReadarrAPIController().bookSearch(
                  context: context,
                  book: book,
                );
              },
            ),
          ),
          const SizedBox(width: HarbrTokens.sm),
          Expanded(
            child: _actionButton(
              context: context,
              icon: Icons.edit_rounded,
              label: 'readarr.EditBook'.tr(),
              onTap: () {
                ReadarrRoutes.BOOK_EDIT.go(params: {
                  'book': book.id!.toString(),
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final harbr = context.harbr;

    return HarbrSurface(
      level: SurfaceLevel.raised,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(
        vertical: HarbrTokens.md,
        horizontal: HarbrTokens.sm,
      ),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: HarbrTokens.iconLg, color: harbr.accent),
          const SizedBox(height: HarbrTokens.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: harbr.onSurfaceDim,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Metadata table in a raised surface
  Widget _metadataSection(ReadarrBook book) {
    return _section(
      title: 'readarr.Overview'.tr(),
      child: HarbrSurface(
        level: SurfaceLevel.raised,
        padding: HarbrTokens.paddingLg,
        child: Column(
          children: [
            _metadataRow('readarr.Author'.tr(), book.harbrAuthorTitle),
            _metadataRow('readarr.Status'.tr(), book.harbrFileStatus),
            _metadataRow('readarr.SizeOnDisk'.tr(), book.harbrSizeOnDisk),
            _metadataRow('readarr.ReleaseDate'.tr(), book.harbrReleaseDate),
            _metadataRow('readarr.Pages'.tr(), book.harbrPageCount),
            _metadataRow('readarr.Genres'.tr(), book.harbrGenres),
            _metadataRow('readarr.AddedOn'.tr(), book.harbrDateAdded),
            _metadataRow(
                'readarr.Editions'.tr(), book.harbrEditionCount, last: true),
          ],
        ),
      ),
    );
  }

  Widget _metadataRow(String label, String value, {bool last = false}) {
    final harbr = context.harbr;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: HarbrTokens.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: harbr.onSurfaceDim,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: harbr.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!last)
          Divider(
            height: 1,
            color: harbr.border,
          ),
      ],
    );
  }

  /// Description/overview section
  Widget _descriptionSection(ReadarrBook book) {
    final harbr = context.harbr;

    return _section(
      title: 'readarr.Description'.tr(),
      child: HarbrSurface(
        level: SurfaceLevel.raised,
        padding: HarbrTokens.paddingLg,
        child: Text(
          book.harbrOverview ?? '',
          style: TextStyle(
            fontSize: 13,
            color: harbr.onSurfaceDim,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  /// History section (inline, no longer a separate tab)
  Widget _historySection(BuildContext context) {
    return _section(
      title: 'readarr.History'.tr(),
      child: FutureBuilder(
        future: context.watch<ReadarrBookDetailsState>().history,
        builder:
            (context, AsyncSnapshot<List<ReadarrHistoryRecord>> snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: HarbrTokens.paddingLg,
              child: HarbrMessage.error(onTap: () {
                context
                    .read<ReadarrBookDetailsState>()
                    .fetchHistory(context);
              }),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return HarbrEmptyState(
                icon: Icons.history_rounded,
                title: 'readarr.NoHistoryFound'.tr(),
              );
            }
            return Column(
              children: snapshot.data!
                  .map((record) => ReadarrHistoryTile(history: record))
                  .toList(),
            );
          }
          return const Padding(
            padding: HarbrTokens.paddingXl,
            child: HarbrLoader(),
          );
        },
      ),
    );
  }

  /// Section header helper
  Widget _section({required String title, required Widget child}) {
    final harbr = context.harbr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: HarbrTokens.lg),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HarbrTokens.lg,
            vertical: HarbrTokens.sm,
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: harbr.onSurfaceFaint,
              letterSpacing: 0.8,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
