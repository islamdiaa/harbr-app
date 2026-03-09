import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrSystemStatusAboutPage extends StatefulWidget {
  final ScrollController scrollController;

  const RadarrSystemStatusAboutPage({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrSystemStatusAboutPage>
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
      body: _body(),
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async =>
          context.read<RadarrSystemStatusState>().fetchStatus(context),
      child: FutureBuilder(
        future: context.watch<RadarrSystemStatusState>().status,
        builder: (context, AsyncSnapshot<RadarrSystemStatus> snapshot) {
          if (snapshot.hasError) {
            HarbrLogger().error('Unable to fetch Radarr system status',
                snapshot.error, snapshot.stackTrace);
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData) return _list(snapshot.data!);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(RadarrSystemStatus status) {
    return HarbrListView(
      controller: RadarrSystemStatusNavigationBar.scrollControllers[0],
      children: [
        HarbrTableCard(
          content: [
            HarbrTableContent(title: 'Version', body: status.harbrVersion),
            if (status.harbrIsDocker)
              HarbrTableContent(
                title: 'Package',
                body: status.harbrPackageVersion,
              ),
            HarbrTableContent(title: '.NET Core', body: status.harbrNetCore),
            HarbrTableContent(title: 'Migration', body: status.harbrDBMigration),
            HarbrTableContent(
                title: 'AppData', body: status.harbrAppDataDirectory),
            HarbrTableContent(
                title: 'Startup', body: status.harbrStartupDirectory),
            HarbrTableContent(title: 'mode', body: status.harbrMode),
            HarbrTableContent(title: 'uptime', body: status.harbrUptime),
          ],
        ),
      ],
    );
  }
}
