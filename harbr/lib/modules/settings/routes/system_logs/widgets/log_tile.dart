import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/log.dart';
import 'package:harbr/extensions/datetime.dart';

class SettingsSystemLogTile extends StatelessWidget {
  final HarbrLog log;

  const SettingsSystemLogTile({
    Key? key,
    required this.log,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateTime =
        DateTime.fromMillisecondsSinceEpoch(log.timestamp).asDateTime();
    return HarbrExpandableListTile(
      title: log.message,
      collapsedSubtitles: [
        TextSpan(text: dateTime),
        TextSpan(
          text: log.type.title.toUpperCase(),
          style: TextStyle(
            color: log.type.color,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      ],
      expandedHighlightedNodes: [
        HarbrHighlightedNode(
          text: log.type.title.toUpperCase(),
          backgroundColor: log.type.color,
        ),
        HarbrHighlightedNode(
          text: dateTime,
          backgroundColor: HarbrColours.blueGrey,
        ),
      ],
      expandedTableContent: [
        if (log.className != null && log.className!.isNotEmpty)
          HarbrTableContent(title: 'settings.Class'.tr(), body: log.className),
        if (log.methodName != null && log.methodName!.isNotEmpty)
          HarbrTableContent(title: 'settings.Method'.tr(), body: log.methodName),
        if (log.error != null && log.error!.isNotEmpty)
          HarbrTableContent(title: 'settings.Exception'.tr(), body: log.error),
      ],
    );
  }
}
