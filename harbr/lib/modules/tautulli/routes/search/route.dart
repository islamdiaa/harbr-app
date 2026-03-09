import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class SearchRoute extends StatefulWidget {
  const SearchRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchRoute> createState() => _State();
}

class _State extends State<SearchRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        module: HarbrModule.TAUTULLI,
        appBar: TautulliSearchAppBar(scrollController: scrollController)
            as PreferredSizeWidget?,
        body: TautulliSearchSearchResults(scrollController: scrollController),
      );
}
