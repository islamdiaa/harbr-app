import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/router/routes/tautulli.dart';

class TautulliMoreRoute extends StatefulWidget {
  const TautulliMoreRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<TautulliMoreRoute> createState() => _State();
}

class _State extends State<TautulliMoreRoute>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.TAUTULLI,
      body: _body,
    );
  }

  Widget get _body {
    return HarbrListView(
      controller: TautulliNavigationBar.scrollControllers[3],
      children: [
        HarbrBlock(
          title: 'Check for Updates',
          body: const [TextSpan(text: 'Tautulli & Plex Updates')],
          trailing: HarbrIconButton(
            icon: Icons.system_update_rounded,
            color: HarbrColours().byListIndex(0),
          ),
          onTap: TautulliRoutes.CHECK_FOR_UPDATES.go,
        ),
        HarbrBlock(
          title: 'Graphs',
          body: const [TextSpan(text: 'Play Count & Duration Graphs')],
          trailing: HarbrIconButton(
            icon: Icons.insert_chart_rounded,
            color: HarbrColours().byListIndex(1),
          ),
          onTap: TautulliRoutes.GRAPHS.go,
        ),
        HarbrBlock(
          title: 'Libraries',
          body: const [TextSpan(text: 'Plex Library Information')],
          trailing: HarbrIconButton(
            icon: Icons.video_library_rounded,
            color: HarbrColours().byListIndex(2),
          ),
          onTap: TautulliRoutes.LIBRARIES.go,
        ),
        HarbrBlock(
          title: 'Logs',
          body: const [TextSpan(text: 'Tautulli & Plex Logs')],
          trailing: HarbrIconButton(
            icon: Icons.developer_mode_rounded,
            color: HarbrColours().byListIndex(3),
          ),
          onTap: TautulliRoutes.LOGS.go,
        ),
        HarbrBlock(
          title: 'Recently Added',
          body: const [TextSpan(text: 'Recently Added Content to Plex')],
          trailing: HarbrIconButton(
            icon: Icons.recent_actors_rounded,
            color: HarbrColours().byListIndex(4),
          ),
          onTap: TautulliRoutes.RECENTLY_ADDED.go,
        ),
        HarbrBlock(
          title: 'Search',
          body: const [TextSpan(text: 'Search Your Libraries')],
          trailing: HarbrIconButton(
            icon: Icons.search_rounded,
            color: HarbrColours().byListIndex(5),
          ),
          onTap: TautulliRoutes.SEARCH.go,
        ),
        HarbrBlock(
          title: 'Statistics',
          body: const [TextSpan(text: 'User & Library Statistics')],
          trailing: HarbrIconButton(
            icon: Icons.format_list_numbered_rounded,
            color: HarbrColours().byListIndex(6),
          ),
          onTap: TautulliRoutes.STATISTICS.go,
        ),
        HarbrBlock(
          title: 'Synced Items',
          body: const [TextSpan(text: 'Synced Content on Devices')],
          trailing: HarbrIconButton(
            icon: Icons.sync_rounded,
            color: HarbrColours().byListIndex(7),
          ),
          onTap: TautulliRoutes.SYNCED_ITEMS.go,
        ),
      ],
    );
  }
}
