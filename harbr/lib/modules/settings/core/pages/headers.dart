import 'package:flutter/material.dart';

import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/tautulli.dart';

class SettingsHeaderRoute extends StatefulWidget {
  final HarbrModule module;

  const SettingsHeaderRoute({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SettingsHeaderRoute> with HarbrScrollControllerMixin {
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

  Widget _bottomActionBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
            text: 'settings.AddHeader'.tr(),
            icon: Icons.add_rounded,
            onTap: () async {
              await HeaderUtility().addHeader(context, headers: _headers());
              _resetState();
            }),
      ],
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'settings.CustomHeaders'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrBox.profiles.listenableBuilder(
      builder: (context, _) => HarbrListView(
        controller: scrollController,
        children: [
          if ((_headers()).isEmpty) _noHeadersFound(),
          ..._headerList(),
        ],
      ),
    );
  }

  Widget _noHeadersFound() =>
      HarbrMessage.inList(text: 'settings.NoHeadersAdded'.tr());

  List<HarbrBlock> _headerList() {
    final headers = _headers();
    List<String> _sortedKeys = headers.keys.toList()..sort();
    return _sortedKeys
        .map<HarbrBlock>((key) => _headerBlock(key, headers[key]))
        .toList();
  }

  HarbrBlock _headerBlock(String key, String? value) {
    return HarbrBlock(
      title: key,
      body: [TextSpan(text: value)],
      trailing: HarbrIconButton(
          icon: HarbrIcons.DELETE,
          color: HarbrColours.red,
          onPressed: () async {
            await HeaderUtility().deleteHeader(
              context,
              key: key,
              headers: _headers(),
            );
            _resetState();
          }),
    );
  }

  Map<String, String> _headers() {
    switch (widget.module) {
      case HarbrModule.DASHBOARD:
        throw Exception('Dashboard does not have a headers page');
      case HarbrModule.EXTERNAL_MODULES:
        throw Exception('External modules do not have a headers page');
      case HarbrModule.LIDARR:
        return HarbrProfile.current.lidarrHeaders;
      case HarbrModule.RADARR:
        return HarbrProfile.current.radarrHeaders;
      case HarbrModule.SONARR:
        return HarbrProfile.current.sonarrHeaders;
      case HarbrModule.SABNZBD:
        return HarbrProfile.current.sabnzbdHeaders;
      case HarbrModule.NZBGET:
        return HarbrProfile.current.nzbgetHeaders;
      case HarbrModule.SEARCH:
        throw Exception('Search does not have a headers page');
      case HarbrModule.SETTINGS:
        throw Exception('Settings does not have a headers page');
      case HarbrModule.WAKE_ON_LAN:
        throw Exception('Wake on LAN does not have a headers page');
      case HarbrModule.OVERSEERR:
        throw Exception('Overseerr does not have a headers page');
      case HarbrModule.TAUTULLI:
        return HarbrProfile.current.tautulliHeaders;
      case HarbrModule.READARR:
        return HarbrProfile.current.readarrHeaders;
    }
  }

  Future<void> _resetState() async {
    switch (widget.module) {
      case HarbrModule.DASHBOARD:
        throw Exception('Dashboard does not have a global state');
      case HarbrModule.EXTERNAL_MODULES:
        throw Exception('External modules do not have a global state');
      case HarbrModule.LIDARR:
        return;
      case HarbrModule.RADARR:
        return context.read<RadarrState>().reset();
      case HarbrModule.SONARR:
        return context.read<SonarrState>().reset();
      case HarbrModule.SABNZBD:
        return;
      case HarbrModule.NZBGET:
        return;
      case HarbrModule.SEARCH:
        throw Exception('Search does not have a global state');
      case HarbrModule.SETTINGS:
        throw Exception('Settings does not have a global state');
      case HarbrModule.WAKE_ON_LAN:
        throw Exception('Wake on LAN does not have a global state');
      case HarbrModule.TAUTULLI:
        return context.read<TautulliState>().reset();
      case HarbrModule.OVERSEERR:
        return;
      case HarbrModule.READARR:
        return context.read<ReadarrState>().reset();
    }
  }
}
