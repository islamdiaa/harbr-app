import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class LogsLoginsRoute extends StatefulWidget {
  const LogsLoginsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LogsLoginsRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TautulliLogsLoginsState(context),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar() as PreferredSizeWidget?,
        body: _body(context),
      ),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'Login Logs',
      scrollControllers: [scrollController],
    );
  }

  Widget _body(BuildContext context) {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async =>
          context.read<TautulliLogsLoginsState>().fetchLogs(context),
      child: FutureBuilder(
        future: context.select((TautulliLogsLoginsState state) => state.logs),
        builder: (context, AsyncSnapshot<TautulliUserLogins> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              HarbrLogger().error(
                'Unable to fetch Tautulli login logs',
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

  Widget _logs(TautulliUserLogins? logs) {
    if ((logs?.logins?.length ?? 0) == 0)
      return HarbrMessage(
        text: 'No Logs Found',
        buttonText: 'Refresh',
        onTap: _refreshKey.currentState?.show,
      );
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: logs!.logins!.length,
      itemBuilder: (context, index) =>
          TautulliLogsLoginsLogTile(login: logs.logins![index]),
    );
  }
}
