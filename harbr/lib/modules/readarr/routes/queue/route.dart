import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/queue/state.dart';
import 'package:harbr/modules/readarr/routes/queue/widgets/queue_tile.dart';

class ReadarrQueueRoute extends StatefulWidget {
  const ReadarrQueueRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReadarrQueueRoute> with HarbrScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReadarrQueueState(context),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar(),
        body: _body(context),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    await context.read<ReadarrQueueState>().fetchQueue(
          context,
          hardCheck: true,
        );
    await context.read<ReadarrQueueState>().queue;
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'readarr.Queue'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body(BuildContext context) {
    return HarbrRefreshIndicator(
      key: _refreshKey,
      context: context,
      onRefresh: () async => _onRefresh(context),
      child: FutureBuilder(
        future: context.watch<ReadarrQueueState>().queue,
        builder: (context, AsyncSnapshot<ReadarrQueue> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              HarbrLogger().error(
                'Unable to fetch Readarr queue',
                snapshot.error,
                snapshot.stackTrace,
              );
            }
            return HarbrMessage.error(
              onTap: _refreshKey.currentState!.show,
            );
          }
          if (snapshot.hasData) {
            return _list(snapshot.data!);
          }
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(ReadarrQueue queue) {
    if (queue.records!.isEmpty) {
      return HarbrMessage(
        text: 'readarr.EmptyQueue'.tr(),
        buttonText: 'harbr.Refresh'.tr(),
        onTap: _refreshKey.currentState!.show,
      );
    }
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: queue.records!.length,
      itemBuilder: (context, index) => ReadarrQueueTile(
        key: ObjectKey(queue.records![index].id),
        queueRecord: queue.records![index],
      ),
    );
  }
}
