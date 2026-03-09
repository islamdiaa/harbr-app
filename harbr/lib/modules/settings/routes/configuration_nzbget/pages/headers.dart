import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/settings.dart';

class ConfigurationNZBGetConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationNZBGetConnectionDetailsHeadersRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: HarbrModule.NZBGET);
  }
}
