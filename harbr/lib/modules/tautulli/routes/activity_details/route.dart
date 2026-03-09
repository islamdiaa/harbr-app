import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class ActivityDetailsRoute extends StatefulWidget {
  final int sessionKey;

  const ActivityDetailsRoute({
    Key? key,
    required this.sessionKey,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ActivityDetailsRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    context.read<TautulliState>().resetActivity();
    await context.read<TautulliState>().activity;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sessionKey == -1) {
      return HarbrMessage.goBack(
        context: context,
        text: 'tautulli.SessionEnded'.tr(),
      );
    }

    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
      bottomNavigationBar:
          TautulliActivityDetailsBottomActionBar(sessionKey: widget.sessionKey),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
        title: 'tautulli.ActivityDetails'.tr(),
        scrollControllers: [
          scrollController
        ],
        actions: [
          TautulliActivityDetailsUserAction(sessionKey: widget.sessionKey),
          TautulliActivityDetailsMetadataAction(sessionKey: widget.sessionKey),
        ]);
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: _refresh,
      child: FutureBuilder(
        future: context.select<TautulliState, Future<TautulliActivity?>>(
            (state) => state.activity!),
        builder: (context, AsyncSnapshot<TautulliActivity?> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              HarbrLogger().error(
                'Unable to pull Tautulli activity session',
                snapshot.error,
                snapshot.stackTrace,
              );
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData) {
            TautulliSession? session = snapshot.data!.sessions!
                .firstWhereOrNull(
                    (element) => element.sessionKey == widget.sessionKey);
            return _session(session);
          }
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _session(TautulliSession? session) {
    if (session == null)
      return HarbrMessage.goBack(
        context: context,
        text: 'tautulli.SessionEnded'.tr(),
      );
    return HarbrListView(
      controller: scrollController,
      children: [
        TautulliActivityTile(session: session, disableOnTap: true),
        HarbrHeader(text: 'tautulli.Metadata'.tr()),
        TautulliActivityDetailsMetadataBlock(session: session),
        HarbrHeader(text: 'tautulli.Player'.tr()),
        TautulliActivityDetailsPlayerBlock(session: session),
        HarbrHeader(text: 'tautulli.Stream'.tr()),
        TautulliActivityDetailsStreamBlock(session: session),
      ],
    );
  }
}
