import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';

class SonarrMoreRoute extends StatefulWidget {
  const SonarrMoreRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SonarrMoreRoute> createState() => _State();
}

class _State extends State<SonarrMoreRoute> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.SONARR,
      body: _body(),
    );
  }

  // ignore: unused_element
  Future<void> _showComingSoonMessage() async {
    showHarbrInfoSnackBar(
      title: 'harbr.ComingSoon'.tr(),
      message: 'This feature is still being developed!',
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: SonarrNavigationBar.scrollControllers[3],
      children: [
        HarbrBlock(
          title: 'sonarr.History'.tr(),
          body: [TextSpan(text: 'sonarr.HistoryDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.history_rounded,
            color: HarbrColours().byListIndex(0),
          ),
          onTap: SonarrRoutes.HISTORY.go,
        ),
        // HarbrBlock(
        //   title: 'sonarr.ManualImport'.tr(),
        //   body: [TextSpan(text: 'sonarr.ManualImportDescription'.tr())],
        //   trailing: HarbrIconButton(
        //     icon: Icons.download_done_rounded,
        //     color: HarbrColours().byListIndex(1),
        //   ),
        //   onTap: () async => _showComingSoonMessage(),
        // ),
        HarbrBlock(
          title: 'sonarr.Queue'.tr(),
          body: [TextSpan(text: 'sonarr.QueueDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.queue_play_next_rounded,
            color: HarbrColours().byListIndex(1),
          ),
          onTap: SonarrRoutes.QUEUE.go,
        ),
        // HarbrBlock(
        //   title: 'sonarr.SystemStatus'.tr(),
        //   body: [TextSpan(text: 'sonarr.SystemStatusDescription'.tr())],
        //   trailing: HarbrIconButton(
        //     icon: Icons.computer_rounded,
        //     color: HarbrColours().byListIndex(3),
        //   ),
        //   onTap: () async => _showComingSoonMessage(),
        // ),
        HarbrBlock(
          title: 'sonarr.Tags'.tr(),
          body: [TextSpan(text: 'sonarr.TagsDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.style_rounded,
            color: HarbrColours().byListIndex(2),
          ),
          onTap: SonarrRoutes.TAGS.go,
        ),
      ],
    );
  }
}
