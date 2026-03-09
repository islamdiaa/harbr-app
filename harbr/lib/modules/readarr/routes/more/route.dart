import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr/routes/readarr/widgets/navigation_bar.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrMoreRoute extends StatefulWidget {
  const ReadarrMoreRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrMoreRoute> createState() => _State();
}

class _State extends State<ReadarrMoreRoute> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.READARR,
      body: _body(),
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: ReadarrNavigationBar.scrollControllers[3],
      children: [
        HarbrBlock(
          title: 'readarr.History'.tr(),
          body: [TextSpan(text: 'readarr.HistoryDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.history_rounded,
            color: HarbrColours().byListIndex(0),
          ),
          onTap: ReadarrRoutes.HISTORY.go,
        ),
        HarbrBlock(
          title: 'readarr.Queue'.tr(),
          body: [TextSpan(text: 'readarr.QueueDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.queue_play_next_rounded,
            color: HarbrColours().byListIndex(1),
          ),
          onTap: ReadarrRoutes.QUEUE.go,
        ),
        HarbrBlock(
          title: 'readarr.Tags'.tr(),
          body: [TextSpan(text: 'readarr.TagsDescription'.tr())],
          trailing: HarbrIconButton(
            icon: Icons.style_rounded,
            color: HarbrColours().byListIndex(2),
          ),
          onTap: ReadarrRoutes.TAGS.go,
        ),
      ],
    );
  }
}
