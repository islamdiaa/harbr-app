import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/missing/widgets/missing_tile.dart';
import 'package:harbr/modules/readarr/routes/readarr/widgets/navigation_bar.dart';

class ReadarrMissingRoute extends StatefulWidget {
  const ReadarrMissingRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrMissingRoute> createState() => _State();
}

class _State extends State<ReadarrMissingRoute>
    with AutomaticKeepAliveClientMixin, HarbrLoadCallbackMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> loadCallback() async {
    ReadarrState _state = Provider.of<ReadarrState>(context, listen: false);
    _state.fetchMissing();
    await _state.missing;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.READARR,
      body: _body(),
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: Selector<ReadarrState, Future<ReadarrMissing>?>(
        selector: (_, state) => state.missing,
        builder: (context, future, _) => FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<ReadarrMissing> snapshot) {
            if (snapshot.hasError) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                HarbrLogger().error(
                  'Unable to fetch Readarr missing books',
                  snapshot.error,
                  snapshot.stackTrace,
                );
              }
              return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
            }
            if (snapshot.hasData) return _books(snapshot.data!);
            return const HarbrLoader();
          },
        ),
      ),
    );
  }

  Widget _books(ReadarrMissing missing) {
    if ((missing.records?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'readarr.NoBooksFound'.tr(),
        buttonText: 'harbr.Refresh'.tr(),
        onTap: _refreshKey.currentState?.show,
      );
    return HarbrListViewBuilder(
      controller: ReadarrNavigationBar.scrollControllers[2],
      itemCount: missing.records!.length,
      itemExtent: ReadarrMissingTile.itemExtent,
      itemBuilder: (context, index) => ReadarrMissingTile(
        record: missing.records![index],
      ),
    );
  }
}
