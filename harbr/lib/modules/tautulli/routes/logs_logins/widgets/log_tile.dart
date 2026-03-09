import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliLogsLoginsLogTile extends StatelessWidget {
  final TautulliUserLoginRecord login;

  const TautulliLogsLoginsLogTile({
    Key? key,
    required this.login,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: login.friendlyName,
      body: _body(),
      trailing: _trailing(),
    );
  }

  List<TextSpan> _body() {
    return [
      TextSpan(text: '${login.ipAddress}\n'),
      TextSpan(text: '${login.os}\n'),
      TextSpan(text: '${login.host}\n'),
      TextSpan(
        text: login.timestamp!.asDateTime(),
        style: const TextStyle(
          color: HarbrColours.accent,
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        ),
      ),
    ];
  }

  Widget _trailing() {
    return Column(
      children: [
        HarbrIconButton(
          icon: login.success!
              ? Icons.check_circle_rounded
              : Icons.cancel_rounded,
          color: login.success! ? Colors.white : HarbrColours.red,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
