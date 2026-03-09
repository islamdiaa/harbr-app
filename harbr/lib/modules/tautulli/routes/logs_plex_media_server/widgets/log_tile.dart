import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliLogsPlexMediaServerLogTile extends StatelessWidget {
  final TautulliPlexLog log;

  const TautulliLogsPlexMediaServerLogTile({
    Key? key,
    required this.log,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: log.message!.trim(),
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
      ],
      expandedTableContent: _tableContent(),
    );
  }

  TextSpan _subtitle1() => TextSpan(text: log.timestamp ?? HarbrUI.TEXT_EMDASH);

  TextSpan _subtitle2() {
    return TextSpan(
      text: log.level ?? HarbrUI.TEXT_EMDASH,
      style: const TextStyle(
        color: HarbrColours.accent,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
    );
  }

  List<HarbrTableContent> _tableContent() {
    return [
      HarbrTableContent(title: 'level', body: log.level),
      HarbrTableContent(title: 'timestamp', body: log.timestamp),
    ];
  }
}
