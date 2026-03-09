import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesDetailsHistoryPage extends StatefulWidget {
  const SonarrSeriesDetailsHistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SonarrSeriesDetailsHistoryPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.SONARR,
      body: _body(),
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async =>
          context.read<SonarrSeriesDetailsState>().fetchHistory(context),
      child: FutureBuilder(
        future: context.select<SonarrSeriesDetailsState,
            Future<List<SonarrHistoryRecord>>?>((s) => s.history),
        builder: (context, AsyncSnapshot<List<SonarrHistoryRecord>> snapshot) {
          if (snapshot.hasError) {
            HarbrLogger().error(
              'Unable to fetch Sonarr series history: ${context.read<SonarrSeriesDetailsState>().series.id}',
              snapshot.error,
              snapshot.stackTrace,
            );
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData) return _list(snapshot.data);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(List<SonarrHistoryRecord>? history) {
    if ((history?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'sonarr.NoHistoryFound'.tr(),
        buttonText: 'harbr.Refresh'.tr(),
        onTap: _refreshKey.currentState!.show,
      );
    return HarbrListViewBuilder(
      controller: SonarrSeriesDetailsNavigationBar.scrollControllers[2],
      itemCount: history!.length,
      itemBuilder: (context, index) => SonarrHistoryTile(
        history: history[index],
        type: SonarrHistoryTileType.SERIES,
      ),
    );
  }
}
