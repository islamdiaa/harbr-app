import 'package:flutter/material.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/api/wake_on_lan/wake_on_lan.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';
import 'package:harbr/widgets/ui/surface.dart';
import 'package:harbr/widgets/ui/responsive_grid.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ModulesPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _body();
  }

  Widget _body() {
    if (!(HarbrProfile.current.isAnythingEnabled())) {
      return HarbrMessage(
        text: 'harbr.NoModulesEnabled'.tr(),
        buttonText: 'harbr.GoToSettings'.tr(),
        onTap: HarbrModule.SETTINGS.launch,
      );
    }
    final modules = HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.read()
        ? _buildAlphabeticalList()
        : _buildManuallyOrderedList();

    return HarbrResponsiveGrid(
      minItemWidth: 300,
      spacing: HarbrTokens.sm,
      children: modules,
    );
  }

  List<Widget> _buildAlphabeticalList() {
    List<Widget> modules = [];
    HarbrModule.active
      ..sort((a, b) => a.title.toLowerCase().compareTo(
            b.title.toLowerCase(),
          ))
      ..forEach((module) {
        if (module.isEnabled) {
          if (module == HarbrModule.WAKE_ON_LAN) {
            modules.add(_buildWakeOnLANCard(context));
          } else {
            modules.add(_buildModuleCard(module));
          }
        }
      });
    modules.add(_buildModuleCard(HarbrModule.SETTINGS));
    return modules;
  }

  List<Widget> _buildManuallyOrderedList() {
    List<Widget> modules = [];
    HarbrDrawer.moduleOrderedList().forEach((module) {
      if (module.isEnabled) {
        if (module == HarbrModule.WAKE_ON_LAN) {
          modules.add(_buildWakeOnLANCard(context));
        } else {
          modules.add(_buildModuleCard(module));
        }
      }
    });
    modules.add(_buildModuleCard(HarbrModule.SETTINGS));
    return modules;
  }

  Widget _buildModuleCard(HarbrModule module) {
    return _ModuleCard(
      title: module.title,
      description: module.description,
      icon: module.icon,
      iconColor: module.color,
      isEnabled: module.isEnabled,
      onTap: module.launch,
    );
  }

  Widget _buildWakeOnLANCard(BuildContext context) {
    return _ModuleCard(
      title: HarbrModule.WAKE_ON_LAN.title,
      description: HarbrModule.WAKE_ON_LAN.description,
      icon: HarbrModule.WAKE_ON_LAN.icon,
      iconColor: HarbrModule.WAKE_ON_LAN.color,
      isEnabled: HarbrModule.WAKE_ON_LAN.isEnabled,
      onTap: () async => HarbrWakeOnLAN().wake(),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isEnabled;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return HarbrSurface(
      level: SurfaceLevel.base,
      borderRadius: HarbrTokens.borderRadiusMd,
      padding: HarbrTokens.paddingMd,
      margin: EdgeInsets.zero,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: HarbrTokens.borderRadiusSm,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: HarbrTokens.iconLg,
            ),
          ),
          const SizedBox(width: HarbrTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: harbr.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HarbrTokens.xs),
                Text(
                  description,
                  style: TextStyle(
                    color: harbr.onSurfaceDim,
                    fontSize: 13,
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
            size: HarbrTokens.iconMd,
          ),
        ],
      ),
    );
  }
}
