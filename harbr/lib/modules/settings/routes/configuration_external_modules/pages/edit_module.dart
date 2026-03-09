import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/external_module.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ConfigurationExternalModulesEditRoute extends StatefulWidget {
  final int moduleId;

  const ConfigurationExternalModulesEditRoute({
    Key? key,
    required this.moduleId,
  }) : super(key: key);

  @override
  State<ConfigurationExternalModulesEditRoute> createState() => _State();
}

class _State extends State<ConfigurationExternalModulesEditRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrExternalModule? _module;

  @override
  Widget build(BuildContext context) {
    if (widget.moduleId < 0 ||
        !HarbrBox.externalModules.contains(widget.moduleId)) {
      return InvalidRoutePage(
        title: 'settings.EditModule'.tr(),
        message: 'settings.ModuleNotFound'.tr(),
      );
    }
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
      title: 'settings.EditModule'.tr(),
    );
  }

  Widget _bottomNavigationBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'settings.DeleteModule'.tr(),
          icon: Icons.delete_rounded,
          color: HarbrColours.red,
          onTap: () async {
            bool result = await SettingsDialogs().deleteExternalModule(context);
            if (result) {
              showHarbrSuccessSnackBar(
                  title: 'settings.DeleteModuleSuccess'.tr(),
                  message: _module!.displayName);
              _module!.delete();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrBox.externalModules.listenableBuilder(
      selectKeys: [widget.moduleId],
      builder: (context, dynamic _) {
        if (!HarbrBox.externalModules.contains(widget.moduleId))
          return Container();
        _module = HarbrBox.externalModules.read(widget.moduleId);
        return HarbrListView(
          controller: scrollController,
          children: [
            _displayNameTile(),
            _hostTile(),
          ],
        );
      },
    );
  }

  Widget _displayNameTile() {
    String _displayName = _module!.displayName;
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
        if (values.item1) _module!.displayName = values.item2;
        _module!.save();
      },
    );
  }

  Widget _hostTile() {
    String _host = _module!.host;
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
        if (values.item1) _module!.host = values.item2;
        _module!.save();
      },
    );
  }
}
