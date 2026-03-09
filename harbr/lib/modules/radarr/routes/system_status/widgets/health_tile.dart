import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrHealthCheckTile extends StatelessWidget {
  final RadarrHealthCheck healthCheck;

  const RadarrHealthCheckTile({
    Key? key,
    required this.healthCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: healthCheck.message!,
      collapsedSubtitles: [
        subtitle1(),
        subtitle2(),
      ],
      expandedTableContent: expandedTable(),
      expandedHighlightedNodes: highlightedNodes(),
      onLongPress: healthCheck.wikiUrl!.openLink,
    );
  }

  TextSpan subtitle1() {
    return TextSpan(text: healthCheck.source);
  }

  TextSpan subtitle2() {
    return TextSpan(
      text: healthCheck.type!.readable,
      style: TextStyle(
        color: healthCheck.type.harbrColour,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        fontSize: HarbrUI.FONT_SIZE_H3,
      ),
    );
  }

  List<HarbrHighlightedNode> highlightedNodes() {
    return [
      HarbrHighlightedNode(
        text: healthCheck.type!.readable!,
        backgroundColor: healthCheck.type.harbrColour,
      ),
    ];
  }

  List<HarbrTableContent> expandedTable() {
    return [
      HarbrTableContent(title: 'Source', body: healthCheck.source),
    ];
  }
}
