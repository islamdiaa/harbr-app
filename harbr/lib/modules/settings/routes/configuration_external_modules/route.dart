import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/external_module.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationExternalModulesRoute extends StatefulWidget {
  const ConfigurationExternalModulesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationExternalModulesRoute> createState() => _State();
}

class _State extends State<ConfigurationExternalModulesRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      scrollControllers: [scrollController],
      title: HarbrModule.EXTERNAL_MODULES.title,
    );
  }

  Widget _bottomNavigationBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'settings.AddModule'.tr(),
          icon: Icons.add_rounded,
          onTap: SettingsRoutes.CONFIGURATION_EXTERNAL_MODULES_ADD.go,
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrBox.externalModules.listenableBuilder(
      builder: (context, _) => HarbrListView(
        controller: scrollController,
        children: [
          HarbrModule.EXTERNAL_MODULES.informationBanner(),
          ..._moduleSection(),
        ],
      ),
    );
  }

  List<Widget> _moduleSection() => [
        if (HarbrBox.externalModules.isEmpty)
          HarbrMessage(text: 'settings.NoExternalModulesFound'.tr()),
        ..._modules,
      ];

  List<Widget> get _modules {
    final modules = HarbrBox.externalModules.data.toList();
    modules.sort((a, b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    List<HarbrBlock> list = List.generate(
      modules.length,
      (index) => _moduleTile(modules[index], modules[index].key) as HarbrBlock,
    );
    return list;
  }

  Widget _moduleTile(HarbrExternalModule module, int index) {
    return HarbrBlock(
      title: module.displayName,
      body: [TextSpan(text: module.host)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        SettingsRoutes.CONFIGURATION_EXTERNAL_MODULES_EDIT.go(params: {
          'id': index.toString(),
        });
      },
    );
  }
}
