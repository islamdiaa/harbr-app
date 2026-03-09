import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';

class RadarrHistoryTile extends StatelessWidget {
  final RadarrHistoryRecord history;
  final bool movieHistory;
  final String title;

  /// If [movieHistory] is false (default), you must supply a title or else a dash will be shown.
  const RadarrHistoryTile({
    Key? key,
    required this.history,
    this.movieHistory = false,
    this.title = HarbrUI.TEXT_EMDASH,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: movieHistory ? history.sourceTitle! : title,
      collapsedSubtitles: [
        TextSpan(
          text: [
            history.date?.asAge() ?? HarbrUI.TEXT_EMDASH,
            history.date?.asDateTime() ?? HarbrUI.TEXT_EMDASH,
          ].join(HarbrUI.TEXT_BULLET.pad()),
        ),
        TextSpan(
          text: history.eventType?.harbrReadable(history) ?? HarbrUI.TEXT_EMDASH,
          style: TextStyle(
            color: history.eventType?.harbrColour ?? HarbrColours.blueGrey,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      ],
      expandedHighlightedNodes: [
        HarbrHighlightedNode(
          text: history.eventType!.readable!,
          backgroundColor: history.eventType!.harbrColour,
        ),
        ...history.customFormats!
            .map<HarbrHighlightedNode>((format) => HarbrHighlightedNode(
                  text: format.name!,
                  backgroundColor: HarbrColours.blueGrey,
                )),
      ],
      expandedTableContent: history.eventType?.harbrTableContent(
            history,
            movieHistory: movieHistory,
          ) ??
          [],
      onLongPress: movieHistory
          ? null
          : () => RadarrRoutes.MOVIE.go(params: {
                'movie': history.movieId!.toString(),
              }),
    );
  }
}
