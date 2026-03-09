import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class ConfigurationDrawerRoute extends StatefulWidget {
  const ConfigurationDrawerRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationDrawerRoute> createState() => _State();
}

class _State extends State<ConfigurationDrawerRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<HarbrModule>? _modules;

  @override
  void initState() {
    super.initState();
    _modules = HarbrDrawer.moduleOrderedList();
  }

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
      scrollControllers: [scrollController],
      title: 'settings.Drawer'.tr(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        SizedBox(height: HarbrUI.MARGIN_H_DEFAULT_V_HALF.bottom),
        HarbrBlock(
          title: 'settings.AutomaticallyManageOrder'.tr(),
          body: [
            TextSpan(text: 'settings.AutomaticallyManageOrderDescription'.tr()),
          ],
          trailing: HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.listenableBuilder(
            builder: (context, _) => HarbrSwitch(
              value: HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.read(),
              onChanged: HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.update,
            ),
          ),
        ),
        HarbrDivider(),
        Expanded(
          child: HarbrReorderableListViewBuilder(
            padding: MediaQuery.of(context).padding.copyWith(top: 0).add(
                EdgeInsets.only(bottom: HarbrUI.MARGIN_H_DEFAULT_V_HALF.bottom)),
            controller: scrollController,
            itemCount: _modules!.length,
            itemBuilder: (context, index) => _reorderableModuleTile(index),
            onReorder: (oIndex, nIndex) {
              if (oIndex > _modules!.length) oIndex = _modules!.length;
              if (oIndex < nIndex) nIndex--;
              HarbrModule module = _modules![oIndex];
              _modules!.remove(module);
              _modules!.insert(nIndex, module);
              HarbrDatabase.DRAWER_MANUAL_ORDER.update(_modules!);
            },
          ),
        ),
      ],
    );
  }

  Widget _reorderableModuleTile(int index) {
    return HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.listenableBuilder(
      key: ObjectKey(_modules![index]),
      builder: (context, _) => HarbrBlock(
        disabled: HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.read(),
        title: _modules![index].title,
        body: [TextSpan(text: _modules![index].description)],
        leading: HarbrIconButton(icon: _modules![index].icon),
        trailing: HarbrDatabase.DRAWER_AUTOMATIC_MANAGE.read()
            ? null
            : HarbrReorderableListViewDragger(index: index),
      ),
    );
  }
}
