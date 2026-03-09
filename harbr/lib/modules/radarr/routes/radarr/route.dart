import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrRoute extends StatefulWidget {
  const RadarrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<RadarrRoute> createState() => _State();
}

class _State extends State<RadarrRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrPageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = HarbrPageController(
      initialPage: RadarrDatabase.NAVIGATION_INDEX.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.RADARR,
      drawer: _drawer(),
      appBar: _appBar() as PreferredSizeWidget?,
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body(),
    );
  }

  Widget _drawer() {
    return HarbrDrawer(page: HarbrModule.RADARR.key);
  }

  Widget? _bottomNavigationBar() {
    if (context.read<RadarrState>().enabled) {
      return RadarrNavigationBar(pageController: _pageController);
    }
    return null;
  }

  Widget _appBar() {
    List<String> profiles = HarbrBox.profiles.keys.fold(
      [],
      (value, element) {
        if (HarbrBox.profiles.read(element)?.radarrEnabled ?? false) {
          value.add(element);
        }
        return value;
      },
    );
    List<Widget>? actions;
    if (context.watch<RadarrState>().enabled) {
      actions = [
        const RadarrAppBarAddMoviesAction(),
        const RadarrAppBarGlobalSettingsAction(),
      ];
    }
    return HarbrAppBar.dropdown(
      title: HarbrModule.RADARR.title,
      useDrawer: true,
      profiles: profiles,
      actions: actions,
      pageController: _pageController,
      scrollControllers: RadarrNavigationBar.scrollControllers,
    );
  }

  Widget _body() {
    return Selector<RadarrState, bool?>(
      selector: (_, state) => state.enabled,
      builder: (context, enabled, _) {
        if (!enabled!) {
          return HarbrMessage.moduleNotEnabled(
            context: context,
            module: 'Radarr',
          );
        }
        return HarbrPageView(
          controller: _pageController,
          children: const [
            RadarrCatalogueRoute(),
            RadarrUpcomingRoute(),
            RadarrMissingRoute(),
            RadarrMoreRoute(),
          ],
        );
      },
    );
  }
}
