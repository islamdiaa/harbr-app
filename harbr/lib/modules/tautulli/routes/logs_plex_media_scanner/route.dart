import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class LogsPlexMediaScannerRoute extends StatefulWidget {
  const LogsPlexMediaScannerRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LogsPlexMediaScannerRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TautulliLogsPlexMediaScannerState(context),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar() as PreferredSizeWidget?,
        body: _body(context),
      ),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'Plex Media Scanner Logs',
      scrollControllers: [scrollController],
    );
  }

  Widget _body(BuildContext context) {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async =>
          context.read<TautulliLogsPlexMediaScannerState>().fetchLogs(context),
      child: FutureBuilder(
        future: context
            .select((TautulliLogsPlexMediaScannerState state) => state.logs),
        builder: (context, AsyncSnapshot<List<TautulliPlexLog>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              HarbrLogger().error(
                'Unable to fetch Plex Media Scanner logs',
                snapshot.error,
                snapshot.stackTrace,
              );
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData) return _logs(snapshot.data);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _logs(List<TautulliPlexLog>? logs) {
    if ((logs?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'No Logs Found',
        buttonText: 'Refresh',
        onTap: _refreshKey.currentState?.show,
      );
    List<TautulliPlexLog> _reversed = logs!.reversed.toList();
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: _reversed.length,
      itemBuilder: (context, index) =>
          TautulliLogsPlexMediaScannerLogTile(log: _reversed[index]),
    );
  }
}
