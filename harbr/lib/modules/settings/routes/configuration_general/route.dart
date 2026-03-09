import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/database/tables/bios.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/system/network/network.dart';
import 'package:harbr/system/platform.dart';

class ConfigurationGeneralRoute extends StatefulWidget {
  const ConfigurationGeneralRoute({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<ConfigurationGeneralRoute>
    with HarbrScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'settings.General'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        ..._appearance(),
        ..._localization(),
        ..._modules(),
        if (HarbrNetwork.isSupported) ..._network(),
        ..._platform(),
      ],
    );
  }

  List<Widget> _appearance() {
    return [
      HarbrHeader(text: 'settings.Appearance'.tr()),
      _imageBackgroundOpacity(),
      _amoledTheme(),
      _amoledThemeBorders(),
    ];
  }

  List<Widget> _localization() {
    return [
      HarbrHeader(text: 'settings.Localization'.tr()),
      _use24HourTime(),
    ];
  }

  List<Widget> _modules() {
    return [
      HarbrHeader(text: 'dashboard.Modules'.tr()),
      _bootModule(),
    ];
  }

  List<Widget> _network() {
    return [
      HarbrHeader(text: 'settings.Network'.tr()),
      _useTLSValidation(),
    ];
  }

  List<Widget> _platform() {
    if (HarbrPlatform.isAndroid) {
      return [
        HarbrHeader(text: 'settings.Platform'.tr()),
        _openDrawerOnBackAction(),
      ];
    }

    return [];
  }

  Widget _openDrawerOnBackAction() {
    const _db = HarbrDatabase.ANDROID_BACK_OPENS_DRAWER;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.OpenDrawerOnBackAction'.tr(),
        body: [
          TextSpan(text: 'settings.OpenDrawerOnBackActionDescription'.tr()),
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }

  Widget _amoledTheme() {
    const _db = HarbrDatabase.THEME_AMOLED;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.AmoledTheme'.tr(),
        body: [
          TextSpan(text: 'settings.AmoledThemeDescription'.tr()),
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: (value) {
            _db.update(value);
            HarbrTheme().initialize();
          },
        ),
      ),
    );
  }

  Widget _amoledThemeBorders() {
    return HarbrBox.harbr.listenableBuilder(
      selectItems: [
        HarbrDatabase.THEME_AMOLED_BORDER,
        HarbrDatabase.THEME_AMOLED,
      ],
      builder: (context, _) => HarbrBlock(
        title: 'settings.AmoledThemeBorders'.tr(),
        body: [
          TextSpan(text: 'settings.AmoledThemeBordersDescription'.tr()),
        ],
        trailing: HarbrSwitch(
          value: HarbrDatabase.THEME_AMOLED_BORDER.read(),
          onChanged: HarbrDatabase.THEME_AMOLED.read()
              ? HarbrDatabase.THEME_AMOLED_BORDER.update
              : null,
        ),
      ),
    );
  }

  Widget _imageBackgroundOpacity() {
    const _db = HarbrDatabase.THEME_IMAGE_BACKGROUND_OPACITY;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.BackgroundImageOpacity'.tr(),
        body: [
          TextSpan(
            text: _db.read() == 0 ? 'harbr.Disabled'.tr() : '${_db.read()}%',
          ),
        ],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, int> result =
              await SettingsDialogs().changeBackgroundImageOpacity(context);
          if (result.item1) _db.update(result.item2);
        },
      ),
    );
  }

  Widget _useTLSValidation() {
    const _db = HarbrDatabase.NETWORKING_TLS_VALIDATION;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.TLSCertificateValidation'.tr(),
        body: [
          TextSpan(text: 'settings.TLSCertificateValidationDescription'.tr()),
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: (data) {
            _db.update(data);
            if (HarbrNetwork.isSupported) HarbrNetwork().initialize();
          },
        ),
      ),
    );
  }

  Widget _use24HourTime() {
    const _db = HarbrDatabase.USE_24_HOUR_TIME;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.Use24HourTime'.tr(),
        body: [TextSpan(text: 'settings.Use24HourTimeDescription'.tr())],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }

  Widget _bootModule() {
    const _db = BIOSDatabase.BOOT_MODULE;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.BootModule'.tr(),
        body: [TextSpan(text: _db.read().title)],
        trailing: HarbrIconButton(icon: _db.read().icon),
        onTap: () async {
          final result = await SettingsDialogs().selectBootModule();
          if (result.item1) {
            BIOSDatabase.BOOT_MODULE.update(result.item2!);
          }
        },
      ),
    );
  }
}
