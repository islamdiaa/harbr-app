import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/router/routes/settings.dart';
import 'package:harbr/system/quick_actions/quick_actions.dart';
import 'package:harbr/utils/profile_tools.dart';

class ConfigurationRoute extends StatefulWidget {
  const ConfigurationRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationRoute> createState() => _State();
}

class _State extends State<ConfigurationRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'settings.Configuration'.tr(),
      scrollControllers: [scrollController],
      actions: [_enabledProfile()],
    );
  }

  Widget _enabledProfile() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) {
        if (HarbrBox.profiles.size < 2) return const SizedBox();
        return HarbrIconButton(
          icon: Icons.switch_account_rounded,
          onPressed: () async {
            final dialogs = SettingsDialogs();
            final enabledProfile = HarbrDatabase.ENABLED_PROFILE.read();
            final profiles = HarbrProfile.list;
            profiles.removeWhere((p) => p == enabledProfile);

            if (profiles.isEmpty) {
              showHarbrInfoSnackBar(
                title: 'settings.NoProfilesFound'.tr(),
                message: 'settings.NoAdditionalProfilesAdded'.tr(),
              );
              return;
            }

            final selected = await dialogs.enabledProfile(
              HarbrState.context,
              profiles,
            );
            if (selected.item1) {
              HarbrProfileTools().changeTo(selected.item2);
            }
          },
        );
      },
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrBlock(
          title: 'settings.General'.tr(),
          body: [TextSpan(text: 'settings.GeneralDescription'.tr())],
          trailing: const HarbrIconButton(icon: Icons.brush_rounded),
          onTap: SettingsRoutes.CONFIGURATION_GENERAL.go,
        ),
        HarbrBlock(
          title: 'settings.Drawer'.tr(),
          body: [TextSpan(text: 'settings.DrawerDescription'.tr())],
          trailing: const HarbrIconButton(icon: Icons.menu_rounded),
          onTap: SettingsRoutes.CONFIGURATION_DRAWER.go,
        ),
        if (HarbrQuickActions.isSupported)
          HarbrBlock(
            title: 'settings.QuickActions'.tr(),
            body: [TextSpan(text: 'settings.QuickActionsDescription'.tr())],
            trailing: const HarbrIconButton(icon: Icons.rounded_corner_rounded),
            onTap: SettingsRoutes.CONFIGURATION_QUICK_ACTIONS.go,
          ),
        HarbrDivider(),
        ..._moduleList(),
      ],
    );
  }

  List<Widget> _moduleList() {
    return ([HarbrModule.DASHBOARD, ...HarbrModule.active])
        .map(_tileFromModuleMap)
        .toList();
  }

  Widget _tileFromModuleMap(HarbrModule module) {
    return HarbrBlock(
      title: module.title,
      body: [
        TextSpan(text: 'settings.ConfigureModule'.tr(args: [module.title]))
      ],
      trailing: HarbrIconButton(icon: module.icon),
      onTap: module.settingsRoute!.go,
    );
  }
}
