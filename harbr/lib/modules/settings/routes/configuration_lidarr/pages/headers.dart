import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/settings.dart';

class ConfigurationLidarrConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationLidarrConnectionDetailsHeadersRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: HarbrModule.LIDARR);
  }
}
