import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/sabnzbd.dart';

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
  Future<SABnzbdStatisticsData>? _future;
  SABnzbdStatisticsData? _data;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar as PreferredSizeWidget?,
        body: _body,
      );

  Future<SABnzbdStatisticsData> _fetch() async =>
      SABnzbdAPI.from(HarbrProfile.current).getStatistics();

  Future<void> _refresh() async {
    if (mounted)
      setState(() {
        _future = _fetch();
      });
  }

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
          builder: (context, AsyncSnapshot<SABnzbdStatisticsData> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  if (snapshot.hasError || snapshot.data == null)
                    return HarbrMessage.error(onTap: _refresh);
                  _data = snapshot.data;
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
          _status(),
          const HarbrHeader(text: 'Statistics'),
          _statistics(),
          ..._serverStatistics(),
        ],
      );

  Widget _status() {
    return HarbrTableCard(
      content: [
        HarbrTableContent(title: 'Uptime', body: _data!.uptime),
        HarbrTableContent(title: 'Version', body: _data!.version),
        HarbrTableContent(
            title: 'Temp. Space',
            body: '${_data!.tempFreespace.toString()} GB'),
        HarbrTableContent(
            title: 'Final Space',
            body: '${_data!.finalFreespace.toString()} GB'),
      ],
    );
  }

  Widget _statistics() {
    return HarbrTableCard(
      content: [
        HarbrTableContent(title: 'Daily', body: _data!.dailyUsage.asBytes()),
        HarbrTableContent(title: 'Weekly', body: _data!.weeklyUsage.asBytes()),
        HarbrTableContent(title: 'Monthly', body: _data!.monthlyUsage.asBytes()),
        HarbrTableContent(title: 'Total', body: _data!.totalUsage.asBytes()),
      ],
    );
  }

  List<Widget> _serverStatistics() {
    return _data!.servers
        .map((server) => [
              HarbrHeader(text: server.name),
              HarbrTableCard(
                content: [
                  HarbrTableContent(
                      title: 'Daily', body: server.dailyUsage.asBytes()),
                  HarbrTableContent(
                      title: 'Weekly', body: server.weeklyUsage.asBytes()),
                  HarbrTableContent(
                      title: 'Monthly', body: server.monthlyUsage.asBytes()),
                  HarbrTableContent(
                      title: 'Total', body: server.totalUsage.asBytes()),
                ],
              ),
            ])
        .expand((element) => element)
        .toList();
  }
}
