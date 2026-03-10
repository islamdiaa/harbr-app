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
        _ConfigMenuItem(
          title: 'settings.General'.tr(),
          subtitle: 'settings.GeneralDescription'.tr(),
          icon: Icons.brush_rounded,
          iconColor: const Color(0xFFFF6B9D),
          onTap: SettingsRoutes.CONFIGURATION_GENERAL.go,
        ),
        _ConfigMenuItem(
          title: 'settings.Drawer'.tr(),
          subtitle: 'settings.DrawerDescription'.tr(),
          icon: Icons.menu_rounded,
          iconColor: const Color(0xFF8B7FB8),
          onTap: SettingsRoutes.CONFIGURATION_DRAWER.go,
        ),
        if (HarbrQuickActions.isSupported)
          _ConfigMenuItem(
            title: 'settings.QuickActions'.tr(),
            subtitle: 'settings.QuickActionsDescription'.tr(),
            icon: Icons.rounded_corner_rounded,
            iconColor: const Color(0xFFFF9000),
            onTap: SettingsRoutes.CONFIGURATION_QUICK_ACTIONS.go,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HarbrTokens.lg,
            vertical: HarbrTokens.sm,
          ),
          child: HarbrDivider(),
        ),
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
    return _ConfigMenuItem(
      title: module.title,
      subtitle: 'settings.ConfigureModule'.tr(args: [module.title]),
      icon: module.icon,
      iconColor: module.color,
      onTap: module.settingsRoute!.go,
    );
  }
}

class _ConfigMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ConfigMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return HarbrSurface(
      level: SurfaceLevel.canvas,
      borderRadius: HarbrTokens.borderRadiusXl,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(
        horizontal: HarbrTokens.md,
        vertical: HarbrTokens.xs,
      ),
      onTap: onTap,
      child: Row(
        children: [
          HarbrIconCircle(
            icon: icon,
            color: iconColor,
            size: 40,
          ),
          const SizedBox(width: HarbrTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: HarbrUI.FONT_SIZE_H2,
                    fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
                    color: harbr.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: HarbrUI.FONT_SIZE_H3,
                    color: harbr.onSurfaceDim,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: HarbrTokens.sm),
          Icon(
            Icons.chevron_right_rounded,
            color: harbr.onSurfaceFaint,
            size: HarbrTokens.iconLg,
          ),
        ],
      ),
    );
  }
}
