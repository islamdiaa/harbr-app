import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/settings.dart';

class ConfigurationReadarrConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationReadarrConnectionDetailsHeadersRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: HarbrModule.READARR);
  }
}
