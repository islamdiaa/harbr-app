import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/settings.dart';

class ConfigurationWakeOnLANRoute extends StatefulWidget {
  const ConfigurationWakeOnLANRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationWakeOnLANRoute> createState() => _State();
}

class _State extends State<ConfigurationWakeOnLANRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      scrollControllers: [scrollController],
      title: HarbrModule.WAKE_ON_LAN.title,
    );
  }

  Widget _body() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) => HarbrListView(
        controller: scrollController,
        children: [
          HarbrModule.WAKE_ON_LAN.informationBanner(),
          _enabledToggle(),
          _broadcastAddress(),
          _macAddress(),
        ],
      ),
    );
  }

  Widget _enabledToggle() {
    return HarbrBlock(
      title: 'settings.EnableModule'.tr(args: [HarbrModule.WAKE_ON_LAN.title]),
      trailing: HarbrSwitch(
        value: HarbrProfile.current.wakeOnLANEnabled,
        onChanged: (value) {
          HarbrProfile.current.wakeOnLANEnabled = value;
          HarbrProfile.current.save();
        },
      ),
    );
  }

  Widget _broadcastAddress() {
    String? broadcastAddress = HarbrProfile.current.wakeOnLANBroadcastAddress;
    return HarbrBlock(
      title: 'settings.BroadcastAddress'.tr(),
      body: [
        TextSpan(
          text:
              broadcastAddress == '' ? 'harbr.NotSet'.tr() : broadcastAddress,
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> _values =
            await SettingsDialogs().editBroadcastAddress(
          context,
          broadcastAddress,
        );
        if (_values.item1) {
          HarbrProfile.current.wakeOnLANBroadcastAddress = _values.item2;
          HarbrProfile.current.save();
        }
      },
    );
  }

  Widget _macAddress() {
    String? macAddress = HarbrProfile.current.wakeOnLANMACAddress;
    return HarbrBlock(
      title: 'settings.MACAddress'.tr(),
      body: [
        TextSpan(text: macAddress == '' ? 'harbr.NotSet'.tr() : macAddress),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> _values = await SettingsDialogs().editMACAddress(
          context,
          macAddress,
        );
        if (_values.item1) {
          HarbrProfile.current.wakeOnLANMACAddress = _values.item2;
          HarbrProfile.current.save();
        }
      },
    );
  }
}
