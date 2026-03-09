import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/readarr/widgets/appbar_add_book_action.dart';
import 'package:harbr/modules/readarr/routes/readarr/widgets/appbar_global_settings_action.dart';
import 'package:harbr/modules/readarr/routes/readarr/widgets/navigation_bar.dart';
import 'package:harbr/modules/readarr/routes/catalogue/route.dart';
import 'package:harbr/modules/readarr/routes/upcoming/route.dart';
import 'package:harbr/modules/readarr/routes/missing/route.dart';
import 'package:harbr/modules/readarr/routes/more/route.dart';

class ReadarrRoute extends StatefulWidget {
  const ReadarrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadarrRoute> createState() => _State();
}

class _State extends State<ReadarrRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrPageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = HarbrPageController(
      initialPage: ReadarrDatabase.NAVIGATION_INDEX.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.READARR,
      drawer: _drawer(),
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body(),
    );
  }

  Widget _drawer() {
    return HarbrDrawer(page: HarbrModule.READARR.key);
  }

  Widget? _bottomNavigationBar() {
    if (context.read<ReadarrState>().enabled) {
      return ReadarrNavigationBar(pageController: _pageController);
    }
    return null;
  }

  PreferredSizeWidget _appBar() {
    List<String> profiles = HarbrBox.profiles.keys.fold(
      [],
      (value, element) {
        if (HarbrBox.profiles.read(element)?.readarrEnabled ?? false) {
          value.add(element);
        }
        return value;
      },
    );
    List<Widget>? actions;
    if (context.watch<ReadarrState>().enabled) {
      actions = [
        const ReadarrAppBarAddBookAction(),
        const ReadarrAppBarGlobalSettingsAction(),
      ];
    }
    return HarbrAppBar.dropdown(
      title: HarbrModule.READARR.title,
      useDrawer: true,
      profiles: profiles,
      actions: actions,
      pageController: _pageController,
      scrollControllers: ReadarrNavigationBar.scrollControllers,
    );
  }

  Widget _body() {
    return Selector<ReadarrState, bool?>(
      selector: (_, state) => state.enabled,
      builder: (context, enabled, _) {
        if (!enabled!) {
          return HarbrMessage.moduleNotEnabled(
            context: context,
            module: 'Readarr',
          );
        }
        return HarbrPageView(
          controller: _pageController,
          children: const [
            ReadarrCatalogueRoute(),
            ReadarrUpcomingRoute(),
            ReadarrMissingRoute(),
            ReadarrMoreRoute(),
          ],
        );
      },
    );
  }
}
