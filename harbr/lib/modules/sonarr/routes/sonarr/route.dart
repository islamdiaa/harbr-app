import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrRoute extends StatefulWidget {
  const SonarrRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SonarrRoute> createState() => _State();
}

class _State extends State<SonarrRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrPageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = HarbrPageController(
      initialPage: SonarrDatabase.NAVIGATION_INDEX.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.SONARR,
      drawer: _drawer(),
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body(),
    );
  }

  Widget _drawer() {
    return HarbrDrawer(page: HarbrModule.SONARR.key);
  }

  Widget? _bottomNavigationBar() {
    if (context.read<SonarrState>().enabled) {
      return SonarrNavigationBar(pageController: _pageController);
    }
    return null;
  }

  PreferredSizeWidget _appBar() {
    List<String> profiles = HarbrBox.profiles.keys.fold(
      [],
      (value, element) {
        if (HarbrBox.profiles.read(element)?.sonarrEnabled ?? false) {
          value.add(element);
        }
        return value;
      },
    );
    List<Widget>? actions;
    if (context.watch<SonarrState>().enabled) {
      actions = [
        const SonarrAppBarAddSeriesAction(),
        const SonarrAppBarGlobalSettingsAction(),
      ];
    }
    return HarbrAppBar.dropdown(
      title: HarbrModule.SONARR.title,
      useDrawer: true,
      profiles: profiles,
      actions: actions,
      pageController: _pageController,
      scrollControllers: SonarrNavigationBar.scrollControllers,
    );
  }

  Widget _body() {
    return Selector<SonarrState, bool?>(
      selector: (_, state) => state.enabled,
      builder: (context, enabled, _) {
        if (!enabled!) {
          return HarbrMessage.moduleNotEnabled(
            context: context,
            module: 'Sonarr',
          );
        }
        return HarbrPageView(
          controller: _pageController,
          children: const [
            SonarrCatalogueRoute(),
            SonarrUpcomingRoute(),
            SonarrMissingRoute(),
            SonarrMoreRoute(),
          ],
        );
      },
    );
  }
}
