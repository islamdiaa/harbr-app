import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/router/routes/tautulli.dart';

class LogsRoute extends StatefulWidget {
  const LogsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LogsRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      title: 'Logs',
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrBlock(
          title: 'Logins',
          body: const [TextSpan(text: 'Tautulli Login Logs')],
          trailing: HarbrIconButton(
            icon: Icons.vpn_key_rounded,
            color: HarbrColours().byListIndex(0),
          ),
          onTap: TautulliRoutes.LOGS_LOGINS.go,
        ),
        HarbrBlock(
          title: 'Newsletters',
          body: const [TextSpan(text: 'Tautulli Newsletter Logs')],
          trailing: HarbrIconButton(
            icon: Icons.email_rounded,
            color: HarbrColours().byListIndex(1),
          ),
          onTap: TautulliRoutes.LOGS_NEWSLETTERS.go,
        ),
        HarbrBlock(
          title: 'Notifications',
          body: const [TextSpan(text: 'Tautulli Notification Logs')],
          trailing: HarbrIconButton(
            icon: Icons.notifications_rounded,
            color: HarbrColours().byListIndex(2),
          ),
          onTap: TautulliRoutes.LOGS_NOTIFICATIONS.go,
        ),
        HarbrBlock(
          title: 'Plex Media Scanner',
          body: const [TextSpan(text: 'Plex Media Scanner Logs')],
          trailing: HarbrIconButton(
            icon: Icons.scanner_rounded,
            color: HarbrColours().byListIndex(3),
          ),
          onTap: TautulliRoutes.LOGS_PLEX_MEDIA_SCANNER.go,
        ),
        HarbrBlock(
          title: 'Plex Media Server',
          body: const [TextSpan(text: 'Plex Media Server Logs')],
          trailing: HarbrIconButton(
            icon: HarbrIcons.PLEX,
            iconSize: HarbrUI.ICON_SIZE - 2.0,
            color: HarbrColours().byListIndex(4),
          ),
          onTap: TautulliRoutes.LOGS_PLEX_MEDIA_SERVER.go,
        ),
        HarbrBlock(
          title: 'Tautulli',
          body: const [TextSpan(text: 'Tautulli Logs')],
          trailing: HarbrIconButton(
            icon: HarbrIcons.TAUTULLI,
            color: HarbrColours().byListIndex(5),
          ),
          onTap: TautulliRoutes.LOGS_TAUTULLI.go,
        ),
      ],
    );
  }
}
