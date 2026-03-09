import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/external_module.dart';
import 'package:harbr/extensions/string/links.dart';

class ExternalModulesModuleTile extends StatelessWidget {
  final HarbrExternalModule? module;

  const ExternalModulesModuleTile({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: module!.displayName,
      body: [TextSpan(text: module!.host)],
      trailing: const HarbrIconButton.arrow(),
      onTap: module!.host.openLink,
    );
  }
}
