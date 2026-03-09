import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrHistoryTile extends StatelessWidget {
  final ReadarrHistoryRecord history;

  const ReadarrHistoryTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: history.harbrTitle,
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
      ],
      expandedHighlightedNodes: [
        HarbrHighlightedNode(
          text: history.harbrEventType,
          backgroundColor: HarbrColours.accent,
        ),
      ],
      expandedTableContent: [
        HarbrTableContent(
          title: 'readarr.Date'.tr(),
          body: history.harbrDate,
        ),
        HarbrTableContent(
          title: 'readarr.EventType'.tr(),
          body: history.harbrEventType,
        ),
      ],
      onLongPress: history.authorId != null
          ? () => ReadarrRoutes.AUTHOR.go(params: {
                'author': history.authorId!.toString(),
              })
          : null,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(text: history.harbrDate);
  }

  TextSpan _subtitle2() {
    return TextSpan(
      text: history.harbrEventType,
      style: const TextStyle(
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        color: HarbrColours.accent,
      ),
    );
  }
}
