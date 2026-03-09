import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationLidarrConnectionDetailsRoute extends StatefulWidget {
  const ConfigurationLidarrConnectionDetailsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationLidarrConnectionDetailsRoute> createState() => _State();
}

class _State extends State<ConfigurationLidarrConnectionDetailsRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'settings.ConnectionDetails'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomActionBar() {
    return HarbrBottomActionBar(
      actions: [
        _testConnection(),
      ],
    );
  }

  Widget _body() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) => HarbrListView(
        controller: scrollController,
        children: [
          _host(),
          _apiKey(),
          _customHeaders(),
        ],
      ),
    );
  }

  Widget _host() {
    String host = HarbrProfile.current.lidarrHost;
    return HarbrBlock(
      title: 'settings.Host'.tr(),
      body: [TextSpan(text: host.isEmpty ? 'harbr.NotSet'.tr() : host)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> _values = await SettingsDialogs().editHost(
          context,
          prefill: host,
        );
        if (_values.item1) {
          HarbrProfile.current.lidarrHost = _values.item2;
          HarbrProfile.current.save();
          context.read<LidarrState>().reset();
        }
      },
    );
  }

  Widget _apiKey() {
    String apiKey = HarbrProfile.current.lidarrKey;
    return HarbrBlock(
      title: 'settings.ApiKey'.tr(),
      body: [
        TextSpan(
          text: apiKey.isEmpty
              ? 'harbr.NotSet'.tr()
              : HarbrUI.TEXT_OBFUSCATED_PASSWORD,
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> _values = await HarbrDialogs().editText(
          context,
          'settings.ApiKey'.tr(),
          prefill: apiKey,
        );
        if (_values.item1) {
          HarbrProfile.current.lidarrKey = _values.item2;
          HarbrProfile.current.save();
          context.read<LidarrState>().reset();
        }
      },
    );
  }

  Widget _testConnection() {
    return HarbrButton.text(
      text: 'settings.TestConnection'.tr(),
      icon: Icons.wifi_tethering_rounded,
      onTap: () async {
        HarbrProfile _profile = HarbrProfile.current;
        if (_profile.lidarrHost.isEmpty) {
          showHarbrErrorSnackBar(
            title: 'settings.HostRequired'.tr(),
            message: 'settings.HostRequiredMessage'.tr(
              args: [HarbrModule.LIDARR.title],
            ),
          );
          return;
        }
        if (_profile.lidarrKey.isEmpty) {
          showHarbrErrorSnackBar(
            title: 'settings.ApiKeyRequired'.tr(),
            message: 'settings.ApiKeyRequiredMessage'.tr(
              args: [HarbrModule.LIDARR.title],
            ),
          );
          return;
        }
        LidarrAPI.from(HarbrProfile.current)
            .testConnection()
            .then(
              (_) => showHarbrSuccessSnackBar(
                title: 'settings.ConnectedSuccessfully'.tr(),
                message: 'settings.ConnectedSuccessfullyMessage'.tr(
                  args: [HarbrModule.LIDARR.title],
                ),
              ),
            )
            .catchError((error, trace) {
          HarbrLogger().error(
            'Connection Test Failed',
            error,
            trace,
          );
          showHarbrErrorSnackBar(
            title: 'settings.ConnectionTestFailed'.tr(),
            error: error,
          );
        });
      },
    );
  }

  Widget _customHeaders() {
    return HarbrBlock(
      title: 'settings.CustomHeaders'.tr(),
      body: [TextSpan(text: 'settings.CustomHeadersDescription'.tr())],
      trailing: const HarbrIconButton.arrow(),
      onTap: SettingsRoutes.CONFIGURATION_LIDARR_CONNECTION_DETAILS_HEADERS.go,
    );
  }
}
