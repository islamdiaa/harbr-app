import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrMoreRoute extends StatefulWidget {
  const RadarrMoreRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<RadarrMoreRoute> createState() => _State();
}

class _State extends State<RadarrMoreRoute> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return HarbrListView(
      controller: RadarrNavigationBar.scrollControllers[3],
      itemExtent: HarbrBlock.calculateItemExtent(1),
      children: [
        HarbrBlock(
          title: 'radarr.History'.tr(),
          body: [TextSpan(text: 'radarr.HistoryDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.history_rounded,
            color: HarbrColours().byListIndex(0),
          ),
          onTap: RadarrRoutes.HISTORY.go,
        ),
        HarbrBlock(
          title: 'radarr.ManualImport'.tr(),
          body: [TextSpan(text: 'radarr.ManualImportDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.download_done_rounded,
            color: HarbrColours().byListIndex(1),
          ),
          onTap: RadarrRoutes.MANUAL_IMPORT.go,
        ),
        HarbrBlock(
          title: 'radarr.Queue'.tr(),
          body: [TextSpan(text: 'radarr.QueueDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.queue_play_next_rounded,
            color: HarbrColours().byListIndex(2),
          ),
          onTap: RadarrRoutes.QUEUE.go,
        ),
        HarbrBlock(
          title: 'radarr.SystemStatus'.tr(),
          body: [TextSpan(text: 'radarr.SystemStatusDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.computer_rounded,
            color: HarbrColours().byListIndex(3),
          ),
          onTap: RadarrRoutes.SYSTEM_STATUS.go,
        ),
        HarbrBlock(
          title: 'radarr.Tags'.tr(),
          body: [TextSpan(text: 'radarr.TagsDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.style_rounded,
            color: HarbrColours().byListIndex(4),
          ),
          onTap: RadarrRoutes.TAGS.go,
        ),
      ],
    );
  }
}
