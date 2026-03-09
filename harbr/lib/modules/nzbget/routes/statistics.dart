import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/nzbget.dart';

class StatisticsRoute extends StatefulWidget {
  const StatisticsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StatisticsRoute> createState() => _State();
}

class _State extends State<StatisticsRoute> with HarbrScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<bool>? _future;
  late NZBGetStatisticsData _statistics;
  List<NZBGetLogData> _logs = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (mounted)
      setState(() {
        _future = _fetch();
      });
  }

  Future<bool> _fetch() async {
    final _api = NZBGetAPI.from(HarbrProfile.current);
    return _fetchStatistics(_api)
        .then((_) => _fetchLogs(_api))
        .then((_) => true);
  }

  Future<void> _fetchStatistics(NZBGetAPI api) async {
    return await api.getStatistics().then((stats) {
      _statistics = stats;
    });
  }

  Future<void> _fetchLogs(NZBGetAPI api) async {
    return await api.getLogs().then((logs) {
      _logs = logs;
    });
  }

  @override
  Widget build(BuildContext context) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar as PreferredSizeWidget?,
        body: _body,
      );

  Widget get _appBar => HarbrAppBar(
        title: 'Server Statistics',
        scrollControllers: [scrollController],
      );

  Widget get _body => HarbrRefreshIndicator(
        context: context,
        key: _refreshKey,
        onRefresh: _refresh,
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  if (snapshot.hasError || snapshot.data == null)
                    return HarbrMessage.error(onTap: _refresh);
                  return _list;
                }
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
              default:
                return const HarbrLoader();
            }
          },
        ),
      );

  Widget get _list => HarbrListView(
        controller: scrollController,
        children: <Widget>[
          const HarbrHeader(text: 'Status'),
          _statusBlock(),
          const HarbrHeader(text: 'Logs'),
          for (var entry in _logs)
            NZBGetLogTile(
              data: entry,
            ),
        ],
      );

  Widget _statusBlock() {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
            title: 'Server',
            body: _statistics.serverPaused ? 'Paused' : 'Active'),
        HarbrTableContent(
            title: 'Post', body: _statistics.postPaused ? 'Paused' : 'Active'),
        HarbrTableContent(
            title: 'Scan', body: _statistics.scanPaused ? 'Paused' : 'Active'),
        HarbrTableContent(title: '', body: ''),
        HarbrTableContent(title: 'Uptime', body: _statistics.uptimeString),
        HarbrTableContent(
            title: 'Speed Limit', body: _statistics.speedLimitString),
        HarbrTableContent(
            title: 'Free Space', body: _statistics.freeSpaceString),
        HarbrTableContent(title: 'Download', body: _statistics.downloadedString),
      ],
    );
  }
}
