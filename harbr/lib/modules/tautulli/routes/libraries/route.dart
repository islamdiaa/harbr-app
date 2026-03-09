import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class LibrariesRoute extends StatefulWidget {
  const LibrariesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<LibrariesRoute> createState() => _State();
}

class _State extends State<LibrariesRoute>
    with HarbrScrollControllerMixin, HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> loadCallback() async {
    context.read<TautulliState>().resetLibrariesTable();
    await context.read<TautulliState>().librariesTable;
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'Libraries',
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      onRefresh: loadCallback,
      key: _refreshKey,
      child: Selector<TautulliState, Future<TautulliLibrariesTable>?>(
        selector: (_, state) => state.librariesTable,
        builder: (context, future, _) => FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<TautulliLibrariesTable> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting)
                HarbrLogger().error(
                  'Unable to fetch Tautulli libraries table',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (snapshot.hasData) return _libraries(snapshot.data);
            return const HarbrLoader();
          },
        ),
      ),
    );
  }

  Widget _libraries(TautulliLibrariesTable? libraries) {
    if ((libraries?.libraries?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'No Libraries Found',
        buttonText: 'Refresh',
        onTap: _refreshKey.currentState?.show,
      );
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: libraries!.libraries!.length,
      itemBuilder: (context, index) =>
          TautulliLibrariesLibraryTile(library: libraries.libraries![index]),
    );
  }
}
