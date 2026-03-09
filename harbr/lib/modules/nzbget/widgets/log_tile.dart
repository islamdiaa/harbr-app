import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/nzbget.dart';

class NZBGetLogTile extends StatelessWidget {
  final NZBGetLogData data;

  const NZBGetLogTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: data.text,
      body: [TextSpan(text: data.timestamp)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async =>
          HarbrDialogs().textPreview(context, 'Log Entry', data.text!),
    );
  }
}
