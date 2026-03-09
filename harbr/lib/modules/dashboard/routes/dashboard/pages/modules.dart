import 'package:flutter/material.dart';

import 'package:harbr/modules.dart';
import 'package:harbr/database/models/profile.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:harbr/api/wake_on_lan/wake_on_lan.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

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
    return _list();
  }

  Widget _list() {
    if (!(HarbrProfile.current.isAnythingEnabled())) {
      return HarbrMessage(
        text: 'harbr.NoModulesEnabled'.tr(),
        buttonText: 'harbr.GoToSettings'.tr(),
        onTap: HarbrModule.SETTINGS.launch,
      );
    }
    return HarbrListView(
      controller: HomeNavigationBar.scrollControllers[0],
      itemExtent: HarbrBlock.calculateItemExtent(1),
      children: HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.read()
          ? _buildAlphabeticalList()
          : _buildManuallyOrderedList(),
    );
  }

  List<Widget> _buildAlphabeticalList() {
    List<Widget> modules = [];
    int index = 0;
    HarbrModule.active
      ..sort((a, b) => a.title.toLowerCase().compareTo(
            b.title.toLowerCase(),
          ))
      ..forEach((module) {
        if (module.isEnabled) {
          if (module == HarbrModule.WAKE_ON_LAN) {
            modules.add(_buildWakeOnLAN(context, index));
          } else {
            modules.add(_buildFromHarbrModule(module, index));
          }
          index++;
        }
      });
    modules.add(_buildFromHarbrModule(HarbrModule.SETTINGS, index));
    return modules;
  }

  List<Widget> _buildManuallyOrderedList() {
    List<Widget> modules = [];
    int index = 0;
    HarbrDrawer.moduleOrderedList().forEach((module) {
      if (module.isEnabled) {
        if (module == HarbrModule.WAKE_ON_LAN) {
          modules.add(_buildWakeOnLAN(context, index));
        } else {
          modules.add(_buildFromHarbrModule(module, index));
        }
        index++;
      }
    });
    modules.add(_buildFromHarbrModule(HarbrModule.SETTINGS, index));
    return modules;
  }

  Widget _buildFromHarbrModule(HarbrModule module, int listIndex) {
    return HarbrBlock(
      title: module.title,
      body: [TextSpan(text: module.description)],
      trailing: HarbrIconButton(icon: module.icon, color: module.color),
      onTap: module.launch,
    );
  }

  Widget _buildWakeOnLAN(BuildContext context, int listIndex) {
    return HarbrBlock(
      title: HarbrModule.WAKE_ON_LAN.title,
      body: [TextSpan(text: HarbrModule.WAKE_ON_LAN.description)],
      trailing: HarbrIconButton(
        icon: HarbrModule.WAKE_ON_LAN.icon,
        color: HarbrModule.WAKE_ON_LAN.color,
      ),
      onTap: () async => HarbrWakeOnLAN().wake(),
    );
  }
}
