import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/nzbget.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationNZBGetConnectionDetailsRoute extends StatefulWidget {
  const ConfigurationNZBGetConnectionDetailsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationNZBGetConnectionDetailsRoute> createState() => _State();
}

class _State extends State<ConfigurationNZBGetConnectionDetailsRoute>
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
          _username(),
          _password(),
          _customHeaders(),
        ],
      ),
    );
  }

  Widget _host() {
    String host = HarbrProfile.current.nzbgetHost;
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
          HarbrProfile.current.nzbgetHost = _values.item2;
          HarbrProfile.current.save();
          context.read<NZBGetState>().reset();
        }
      },
    );
  }

  Widget _username() {
    String username = HarbrProfile.current.nzbgetUser;
    return HarbrBlock(
      title: 'settings.Username'.tr(),
      body: [
        TextSpan(text: username.isEmpty ? 'harbr.NotSet'.tr() : username),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> _values = await HarbrDialogs().editText(
          context,
          'settings.Username'.tr(),
          prefill: username,
        );
        if (_values.item1) {
          HarbrProfile.current.nzbgetUser = _values.item2;
          HarbrProfile.current.save();
          context.read<NZBGetState>().reset();
        }
      },
    );
  }

  Widget _password() {
    String password = HarbrProfile.current.nzbgetPass;
    return HarbrBlock(
      title: 'settings.Password'.tr(),
      body: [
        TextSpan(
          text: password.isEmpty
              ? 'harbr.NotSet'.tr()
              : HarbrUI.TEXT_OBFUSCATED_PASSWORD,
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        Tuple2<bool, String> _values = await HarbrDialogs().editText(
          context,
          'settings.Password'.tr(),
          prefill: password,
          extraText: [
            HarbrDialog.textSpanContent(
              text: '${HarbrUI.TEXT_BULLET} ${'settings.PasswordHint1'.tr()}',
            ),
          ],
        );
        if (_values.item1) {
          HarbrProfile.current.nzbgetPass = _values.item2;
          HarbrProfile.current.save();
          context.read<NZBGetState>().reset();
        }
      },
    );
  }

  Widget _testConnection() {
    return HarbrButton.text(
      text: 'settings.TestConnection'.tr(),
      icon: HarbrIcons.CONNECTION_TEST,
      onTap: () async {
        HarbrProfile _profile = HarbrProfile.current;
        if (_profile.nzbgetHost.isEmpty) {
          showHarbrErrorSnackBar(
            title: 'settings.HostRequired'.tr(),
            message: 'settings.HostRequiredMessage'
                .tr(args: [HarbrModule.NZBGET.title]),
          );
          return;
        }
        NZBGetAPI.from(HarbrProfile.current)
            .testConnection()
            .then((_) => showHarbrSuccessSnackBar(
                  title: 'settings.ConnectedSuccessfully'.tr(),
                  message: 'settings.ConnectedSuccessfullyMessage'
                      .tr(args: [HarbrModule.NZBGET.title]),
                ))
            .catchError((error, trace) {
          HarbrLogger().error('Connection Test Failed', error, trace);
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
      onTap: SettingsRoutes.CONFIGURATION_NZBGET_CONNECTION_DETAILS_HEADERS.go,
    );
  }
}
