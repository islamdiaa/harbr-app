import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliLogsNotificationLogTile extends StatelessWidget {
  final TautulliNotificationLogRecord notification;

  const TautulliLogsNotificationLogTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: notification.agentName,
      body: _body(),
      trailing: _trailing(),
    );
  }

  List<TextSpan> _body() {
    return [
      TextSpan(text: notification.notifyAction),
      TextSpan(text: notification.subjectText),
      TextSpan(text: notification.bodyText),
      TextSpan(
        text: notification.timestamp!.asDateTime(),
        style: const TextStyle(
          color: HarbrColours.accent,
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        ),
      ),
    ];
  }

  Widget _trailing() => Column(
        children: [
          HarbrIconButton(
            icon: notification.success!
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: notification.success! ? HarbrColours.white : HarbrColours.red,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      );
}
