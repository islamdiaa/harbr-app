import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliActivityStatus extends StatelessWidget {
  final TautulliActivity? activity;

  const TautulliActivityStatus({
    required this.activity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrHeader(
      text: activity!.harbrSessionsHeader,
      subtitle: [
        activity!.harbrSessions,
        activity!.harbrBandwidth,
      ].join('\n'),
    );
  }
}
