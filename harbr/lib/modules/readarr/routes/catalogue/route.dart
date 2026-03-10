import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/catalogue/widgets/book_tile.dart';
import 'package:harbr/modules/readarr/routes/catalogue/widgets/search_bar.dart';
import 'package:harbr/modules/readarr/routes/readarr/widgets/navigation_bar.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrCatalogueRoute extends StatefulWidget {
  const ReadarrCatalogueRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrCatalogueRoute> createState() => _State();
}

class _State extends State<ReadarrCatalogueRoute>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() async {
    ReadarrState _state = context.read<ReadarrState>();
    _state.fetchAllBooks();
    _state.fetchAllAuthors();
    _state.fetchQualityProfiles();
    _state.fetchTags();

    await Future.wait([
      _state.books!,
      _state.authors!,
      _state.qualityProfiles!,
      _state.tags!,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.READARR,
      body: _body(),
      appBar: _appBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar.empty(
      child: ReadarrAuthorSearchBar(
        scrollController: ReadarrNavigationBar.scrollControllers[0],
      ),
      height: 100,
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: _refresh,
      child: Selector<
          ReadarrState,
          Tuple3<Future<List<ReadarrBook>>?,
              Future<Map<int, ReadarrAuthor>>?,
              Future<List<ReadarrQualityProfile>>?>>(
        selector: (_, state) => Tuple3(
          state.books,
          state.authors,
          state.qualityProfiles,
        ),
        builder: (context, tuple, _) => FutureBuilder(
          future: Future.wait([
            tuple.item1!,
            tuple.item2!,
            tuple.item3!,
          ]),
          builder: (context, AsyncSnapshot<List<Object>> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                HarbrLogger().error(
                  'Unable to fetch Readarr books',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return HarbrMessage.error(
                onTap: _refreshKey.currentState!.show,
              );
            }
            if (snapshot.hasData) {
              return _books(
                snapshot.data![0] as List<ReadarrBook>,
                snapshot.data![1] as Map<int, ReadarrAuthor>,
              );
            }
            return const HarbrLoader();
          },
        ),
      ),
    );
  }

  List<ReadarrBook> _filterAndSort(
    List<ReadarrBook> books,
    Map<int, ReadarrAuthor> authors,
    String query,
  ) {
    if (books.isEmpty) return [];
    ReadarrBooksFilter filter = context.watch<ReadarrState>().filterType;
    ReadarrBooksSorting sortType = context.watch<ReadarrState>().sortType;
    bool ascending = context.watch<ReadarrState>().sortAscending;

    // Apply filter
    List<ReadarrBook> filtered = filter.filter(books);

    // Filter by search query
    if (query.isNotEmpty) {
      String q = query.toLowerCase();
      filtered = filtered.where((book) {
        if (book.id == null) return false;
        bool matchesTitle = book.title?.toLowerCase().contains(q) ?? false;
        bool matchesAuthor = false;
        if (book.authorId != null && authors.containsKey(book.authorId)) {
          matchesAuthor = authors[book.authorId]!
                  .authorName
                  ?.toLowerCase()
                  .contains(q) ??
              false;
        }
        return matchesTitle || matchesAuthor;
      }).toList();
    }

    // Sort
    filtered = sortType.sortBooks(filtered, ascending, authors);

    return filtered;
  }

  Widget _books(
    List<ReadarrBook> books,
    Map<int, ReadarrAuthor> authors,
  ) {
    if (books.isEmpty)
      return HarbrMessage(
        text: 'readarr.NoBooksFound'.tr(),
        buttonText: 'harbr.Refresh'.tr(),
        onTap: _refreshKey.currentState!.show,
      );
    return Selector<ReadarrState, String>(
      selector: (_, state) => state.searchQuery,
      builder: (context, query, _) {
        List<ReadarrBook> _filtered =
            _filterAndSort(books, authors, query);
        if (_filtered.isEmpty)
          return HarbrListView(
            controller: ReadarrNavigationBar.scrollControllers[0],
            children: [
              HarbrMessage.inList(text: 'readarr.NoBooksFound'.tr()),
              if (query.isNotEmpty)
                HarbrButtonContainer(
                  children: [
                    HarbrButton.text(
                      icon: null,
                      text: query.length > 20
                          ? 'readarr.SearchFor'.tr(args: [
                              '"${query.substring(0, 20)}${HarbrUI.TEXT_ELLIPSIS}"'
                            ])
                          : 'readarr.SearchFor'.tr(args: ['"$query"']),
                      backgroundColor: HarbrColours.accent,
                      onTap: () async {
                        ReadarrRoutes.ADD_BOOK.go(queryParams: {
                          'query': query,
                        });
                      },
                    ),
                  ],
                ),
            ],
          );
        return HarbrListViewBuilder(
          controller: ReadarrNavigationBar.scrollControllers[0],
          itemCount: _filtered.length,
          itemBuilder: (context, index) => ReadarrCatalogueBookTile(
            book: _filtered[index],
            authors: authors,
          ),
        );
      },
    );
  }
}
