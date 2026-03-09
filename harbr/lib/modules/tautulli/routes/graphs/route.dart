import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class GraphsRoute extends StatefulWidget {
  const GraphsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<GraphsRoute> createState() => _State();
}

class _State extends State<GraphsRoute> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrPageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = HarbrPageController(
        initialPage: TautulliDatabase.NAVIGATION_INDEX_GRAPHS.read());
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      bottomNavigationBar: _bottomNavigationBar(),
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      pageController: _pageController,
      scrollControllers: TautulliGraphsNavigationBar.scrollControllers,
      title: 'Graphs',
      actions: const [
        TautulliGraphsTypeButton(),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return TautulliGraphsNavigationBar(pageController: _pageController);
  }

  Widget _body() {
    return HarbrPageView(
      controller: _pageController,
      children: const [
        TautulliGraphsPlayByPeriodRoute(),
        TautulliGraphsStreamInformationRoute(),
      ],
    );
  }
}
