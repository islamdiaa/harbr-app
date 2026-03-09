import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class SyncedItemsRoute extends StatefulWidget {
  const SyncedItemsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SyncedItemsRoute> createState() => _State();
}

class _State extends State<SyncedItemsRoute>
    with HarbrScrollControllerMixin, HarbrLoadCallbackMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> loadCallback() async {
    context.read<TautulliState>().resetSyncedItems();
    await context.read<TautulliState>().syncedItems;
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.TAUTULLI,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'Synced Items',
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: Selector<TautulliState, Future<List<TautulliSyncedItem>>?>(
        selector: (_, state) => state.syncedItems,
        builder: (context, synced, _) => FutureBuilder(
          future: synced,
          builder: (context, AsyncSnapshot<List<TautulliSyncedItem>> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting)
                HarbrLogger().error(
                  'Unable to fetch Tautulli synced items',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (snapshot.hasData) return _list(snapshot.data);
            return const HarbrLoader();
          },
        ),
      ),
    );
  }

  Widget _list(List<TautulliSyncedItem>? syncedItems) {
    if ((syncedItems?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'No Synced Items Found',
        buttonText: 'Refresh',
        onTap: _refreshKey.currentState!.show,
      );
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: syncedItems!.length,
      itemBuilder: (context, index) =>
          TautulliSyncedItemTile(syncedItem: syncedItems[index]),
    );
  }
}
