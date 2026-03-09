import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ConfigurationReadarrDefaultPagesRoute extends StatefulWidget {
  const ConfigurationReadarrDefaultPagesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationReadarrDefaultPagesRoute> createState() => _State();
}

class _State extends State<ConfigurationReadarrDefaultPagesRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<IconData> _icons = [
    Icons.person_rounded,
    Icons.calendar_today_rounded,
    Icons.event_busy_rounded,
    Icons.more_horiz_rounded,
  ];

  static List<String> get _titles => [
        'readarr.Authors'.tr(),
        'readarr.Upcoming'.tr(),
        'readarr.Missing'.tr(),
        'readarr.More'.tr(),
      ];

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'settings.DefaultPages'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        _homePage(),
      ],
    );
  }

  Widget _homePage() {
    const _db = ReadarrDatabase.NAVIGATION_INDEX;
    return _db.listenableBuilder(
      builder: (context, _) {
        return HarbrBlock(
          title: 'harbr.Home'.tr(),
          body: [TextSpan(text: _titles[_db.read()])],
          trailing: HarbrIconButton(icon: _icons[_db.read()]),
          onTap: () async {
            List values = await ReadarrDialogs.setDefaultPage(
              context,
              titles: _titles,
              icons: _icons,
            );
            if (values[0]) _db.update(values[1]);
          },
        );
      },
    );
  }
}
