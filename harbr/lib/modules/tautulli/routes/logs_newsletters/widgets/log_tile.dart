import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliLogsNewsletterLogTile extends StatelessWidget {
  final TautulliNewsletterLogRecord newsletter;

  const TautulliLogsNewsletterLogTile({
    Key? key,
    required this.newsletter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: newsletter.agentName,
      body: _body(),
      trailing: _trailing(),
    );
  }

  List<TextSpan> _body() {
    return [
      TextSpan(text: newsletter.notifyAction),
      TextSpan(text: newsletter.subjectText),
      TextSpan(text: newsletter.bodyText),
      TextSpan(
        text: newsletter.timestamp!.asDateTime(),
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
            icon: newsletter.success!
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: newsletter.success! ? HarbrColours.white : HarbrColours.red,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      );
}
