import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/api/wake_on_lan/wake_on_lan.dart';

class HarbrDrawer extends StatelessWidget {
  final String page;

  const HarbrDrawer({
    Key? key,
    required this.page,
  }) : super(key: key);

  static List<HarbrModule> moduleAlphabeticalList() {
    return HarbrModule.active
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  }

  static List<HarbrModule> moduleOrderedList() {
    try {
      const db = HarbrDatabase.DRAWER_MANUAL_ORDER;
      final modules = List.from(db.read());
      final missing = HarbrModule.active;

      missing.retainWhere((m) => !modules.contains(m));
      modules.addAll(missing);
      modules.retainWhere((m) => (m as HarbrModule).featureFlag);

      return modules.cast<HarbrModule>();
    } catch (error, stack) {
      HarbrLogger().error('Failed to create ordered module list', error, stack);
      return moduleAlphabeticalList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HarbrDatabase.ENABLED_PROFILE.listenableBuilder(
      builder: (context, _) => HarbrBox.indexers.listenableBuilder(
        builder: (context, _) => Drawer(
          elevation: HarbrUI.ELEVATION,
          backgroundColor: Theme.of(context).primaryColor,
          child: HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.listenableBuilder(
            builder: (context, _) => Column(
              children: [
                HarbrDrawerHeader(page: page),
                Expanded(
                  child: HarbrListView(
                    controller: PrimaryScrollController.of(context),
                    children: _moduleList(
                      context,
                      HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.read()
                          ? moduleAlphabeticalList()
                          : moduleOrderedList(),
                    ),
                    physics: const ClampingScrollPhysics(),
                    padding: MediaQuery.of(context).padding.copyWith(top: 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _sharedHeader(BuildContext context) {
    return [
      _buildEntry(
        context: context,
        module: HarbrModule.DASHBOARD,
      ),
    ];
  }

  List<Widget> _moduleList(BuildContext context, List<HarbrModule> modules) {
    return <Widget>[
      ..._sharedHeader(context),
      ...modules.map((module) {
        if (module.isEnabled) {
          return _buildEntry(
            context: context,
            module: module,
            onTap: module == HarbrModule.WAKE_ON_LAN ? _wakeOnLAN : null,
          );
        }
        return const SizedBox(height: 0.0);
      }),
    ];
  }

  Widget _buildEntry({
    required BuildContext context,
    required HarbrModule module,
    void Function()? onTap,
  }) {
    bool currentPage = page == module.key.toLowerCase();
    return SizedBox(
      height: HarbrTextInputBar.defaultAppBarHeight,
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              child: Icon(
                module.icon,
                color: currentPage ? module.color : HarbrColours.white,
              ),
              padding: HarbrUI.MARGIN_DEFAULT_HORIZONTAL * 1.5,
            ),
            Text(
              module.title,
              style: TextStyle(
                color: currentPage ? module.color : HarbrColours.white,
                fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
              ),
            ),
          ],
        ),
        onTap: onTap ??
            () async {
              Navigator.of(context).pop();
              if (!currentPage) module.launch();
            },
      ),
    );
  }

  Future<void> _wakeOnLAN() async => HarbrWakeOnLAN().wake();
}
