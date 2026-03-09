import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/releases/state.dart';
import 'package:harbr/modules/readarr/routes/releases/widgets/release_tile.dart';
import 'package:harbr/modules/readarr/routes/releases/widgets/search_bar.dart';

class ReadarrReleasesRoute extends StatefulWidget {
  final int? bookId;

  const ReadarrReleasesRoute({
    Key? key,
    this.bookId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrReleasesRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReadarrReleasesState(
        context: context,
        bookId: widget.bookId,
      ),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar(context) as PreferredSizeWidget?,
        body: _body(context),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return HarbrAppBar(
      title: 'readarr.Releases'.tr(),
      scrollControllers: [scrollController],
      bottom: ReadarrReleasesSearchBar(scrollController: scrollController),
    );
  }

  Widget _body(BuildContext context) {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async {
        context.read<ReadarrReleasesState>().refreshReleases(context);
        await context.read<ReadarrReleasesState>().releases;
      },
      child: FutureBuilder(
        future: context.watch<ReadarrReleasesState>().releases,
        builder: (context, AsyncSnapshot<List<ReadarrRelease>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              HarbrLogger().error(
                'Unable to fetch Readarr releases',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
            return HarbrMessage.error(
              onTap: () => _refreshKey.currentState!.show(),
            );
          }
          if (snapshot.hasData) return _list(context, snapshot.data);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(BuildContext context, List<ReadarrRelease>? releases) {
    return Consumer<ReadarrReleasesState>(
      builder: (context, state, _) {
        if (releases?.isEmpty ?? true) {
          return HarbrMessage(
            text: 'readarr.NoReleasesFound'.tr(),
            buttonText: 'harbr.Refresh'.tr(),
            onTap: _refreshKey.currentState!.show,
          );
        }
        List<ReadarrRelease> _processed = _filterAndSortReleases(
          releases ?? [],
          state,
        );
        return HarbrListViewBuilder(
          controller: scrollController,
          itemCount: _processed.isEmpty ? 1 : _processed.length,
          itemBuilder: (context, index) {
            if (_processed.isEmpty) {
              return HarbrMessage.inList(text: 'readarr.NoReleasesFound'.tr());
            }
            return ReadarrReleaseTile(release: _processed[index]);
          },
        );
      },
    );
  }

  List<ReadarrRelease> _filterAndSortReleases(
    List<ReadarrRelease> releases,
    ReadarrReleasesState state,
  ) {
    if (releases.isEmpty) return releases;
    List<ReadarrRelease> filtered = releases.where(
      (release) {
        String _query = state.searchQuery;
        if (_query.isNotEmpty) {
          return release.title!.toLowerCase().contains(_query.toLowerCase());
        }
        return true;
      },
    ).toList();
    filtered = state.filterType.filter(filtered);
    filtered = state.sortType.sort(filtered, state.sortAscending);
    return filtered;
  }
}
