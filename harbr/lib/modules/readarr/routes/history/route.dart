import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/history/widgets/history_tile.dart';

class ReadarrHistoryRoute extends StatefulWidget {
  const ReadarrHistoryRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrHistoryRoute> createState() => _State();
}

class _State extends State<ReadarrHistoryRoute>
    with HarbrScrollControllerMixin, HarbrLoadCallbackMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<ReadarrHistory>? _history;

  @override
  Future<void> loadCallback() async {
    if (context.read<ReadarrState>().enabled) {
      setState(() {
        _history = context.read<ReadarrState>().api!.history.get(
              pageSize: ReadarrDatabase.CONTENT_PAGE_SIZE.read(),
            );
      });
      await _history;
    }
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
      title: 'readarr.History'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: FutureBuilder(
        future: _history,
        builder: (context, AsyncSnapshot<ReadarrHistory> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              HarbrLogger().error(
                'Unable to fetch Readarr history',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData) return _list(snapshot.data!);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(ReadarrHistory history) {
    if ((history.records?.length ?? 0) == 0) {
      return HarbrMessage(
        text: 'readarr.NoHistoryFound'.tr(),
        buttonText: 'harbr.Refresh'.tr(),
        onTap: _refreshKey.currentState!.show,
      );
    }
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: history.records!.length,
      itemBuilder: (context, index) => ReadarrHistoryTile(
        history: history.records![index],
      ),
    );
  }
}
