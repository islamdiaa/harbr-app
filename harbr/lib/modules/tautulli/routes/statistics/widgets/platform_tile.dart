import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/duration/timestamp.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliStatisticsPlatformTile extends StatefulWidget {
  final Map<String, dynamic> data;

  const TautulliStatisticsPlatformTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TautulliStatisticsPlatformTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: widget.data['platform'] ?? 'Unknown Platform',
      body: _body(),
      posterPlaceholderIcon: HarbrIcons.DEVICES,
      posterIsSquare: true,
    );
  }

  List<TextSpan> _body() {
    return [
      TextSpan(
        text: widget.data['total_plays'].toString() +
            (widget.data['total_plays'] == 1 ? ' Play' : ' Plays'),
        style: TextStyle(
          color: context.watch<TautulliState>().statisticsType ==
                  TautulliStatsType.PLAYS
              ? HarbrColours.accent
              : null,
          fontWeight: context.watch<TautulliState>().statisticsType ==
                  TautulliStatsType.PLAYS
              ? HarbrUI.FONT_WEIGHT_BOLD
              : null,
        ),
      ),
      widget.data['total_duration'] != null
          ? TextSpan(
              text: Duration(seconds: widget.data['total_duration'])
                  .asWordsTimestamp(),
              style: TextStyle(
                color: context.watch<TautulliState>().statisticsType ==
                        TautulliStatsType.DURATION
                    ? HarbrColours.accent
                    : null,
                fontWeight: context.watch<TautulliState>().statisticsType ==
                        TautulliStatsType.DURATION
                    ? HarbrUI.FONT_WEIGHT_BOLD
                    : null,
              ),
            )
          : const TextSpan(text: HarbrUI.TEXT_EMDASH),
    ];
  }
}
