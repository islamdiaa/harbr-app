import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/external_module.dart';
import 'package:harbr/modules/settings.dart';

class ConfigurationExternalModulesAddRoute extends StatefulWidget {
  const ConfigurationExternalModulesAddRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationExternalModulesAddRoute> createState() => _State();
}

class _State extends State<ConfigurationExternalModulesAddRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HarbrExternalModule _module = HarbrExternalModule();

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
      title: 'settings.AddModule'.tr(),
    );
  }

  Widget _bottomNavigationBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'settings.AddModule'.tr(),
          icon: Icons.add_rounded,
          onTap: () async {
            if (_module.displayName.isEmpty || _module.host.isEmpty) {
              showHarbrErrorSnackBar(
                title: 'settings.AddModuleFailed'.tr(),
                message: 'settings.AllFieldsAreRequired'.tr(),
              );
            } else {
              HarbrBox.externalModules.create(_module);
              showHarbrSuccessSnackBar(
                title: 'settings.AddModuleSuccess'.tr(),
                message: _module.displayName,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        _displayNameTile(),
        _hostTile(),
      ],
    );
  }

  Widget _displayNameTile() {
    String _displayName = _module.displayName;
    return HarbrBlock(
      title: 'settings.DisplayName'.tr(),
      body: [
        TextSpan(
          text: _displayName.isEmpty ? 'harbr.NotSet'.tr() : _displayName,
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> values = await HarbrDialogs().editText(
          context,
          'settings.DisplayName'.tr(),
          prefill: _displayName,
        );
        if (values.item1) setState(() => _module.displayName = values.item2);
      },
    );
  }

  Widget _hostTile() {
    String _host = _module.host;
    return HarbrBlock(
      title: 'settings.Host'.tr(),
      body: [
        TextSpan(text: _host.isEmpty ? 'harbr.NotSet'.tr() : _host),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> values =
            await SettingsDialogs().editExternalModuleHost(
          context,
          prefill: _host,
        );
        if (values.item1) setState(() => _module.host = values.item2);
      },
    );
  }
}
