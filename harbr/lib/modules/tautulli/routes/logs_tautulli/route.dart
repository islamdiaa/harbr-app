import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class LogsTautulliRoute extends StatefulWidget {
  const LogsTautulliRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LogsTautulliRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TautulliLogsTautulliState(context),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar(),
        body: _body(context),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'Tautulli Logs',
      scrollControllers: [scrollController],
    );
  }

  Widget _body(BuildContext context) {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async =>
          context.read<TautulliLogsTautulliState>().fetchLogs(context),
      child: FutureBuilder(
        future: context.select((TautulliLogsTautulliState state) => state.logs),
        builder: (context, AsyncSnapshot<List<TautulliLog>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              HarbrLogger().error(
                'Unable to fetch Tautulli logs',
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

  Widget _logs(List<TautulliLog>? logs) {
    if ((logs?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'No Logs Found',
        buttonText: 'Refresh',
        onTap: _refreshKey.currentState?.show,
      );
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: logs!.length,
      itemBuilder: (context, index) =>
          TautulliLogsTautulliLogTile(log: logs[index]),
    );
  }
}
