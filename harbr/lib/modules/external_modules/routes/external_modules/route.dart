import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/external_modules/routes/external_modules/widgets/module_tile.dart';

class ExternalModulesRoute extends StatefulWidget {
  const ExternalModulesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ExternalModulesRoute> createState() => _State();
}

class _State extends State<ExternalModulesRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      module: HarbrModule.EXTERNAL_MODULES,
      appBar: _appBar(),
      drawer: _drawer(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      useDrawer: true,
      title: HarbrModule.EXTERNAL_MODULES.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _drawer() => HarbrDrawer(page: HarbrModule.EXTERNAL_MODULES.key);

  Widget _body() {
    if (HarbrBox.externalModules.isEmpty) {
      return HarbrMessage.moduleNotEnabled(
        context: context,
        module: HarbrModule.EXTERNAL_MODULES.title,
      );
    }
    return HarbrListView(
      controller: scrollController,
      itemExtent: HarbrBlock.calculateItemExtent(1),
      children: _list,
    );
  }

  List<Widget> get _list {
    final list = HarbrBox.externalModules.data
        .map((module) => ExternalModulesModuleTile(module: module))
        .toList();
    list.sort((a, b) => a.module!.displayName
        .toLowerCase()
        .compareTo(b.module!.displayName.toLowerCase()));

    return list;
  }
}
