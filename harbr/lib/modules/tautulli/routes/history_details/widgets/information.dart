import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/duration/timestamp.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliHistoryDetailsInformation extends StatelessWidget {
  final TautulliHistoryRecord history;
  final ScrollController scrollController;

  const TautulliHistoryDetailsInformation({
    Key? key,
    required this.history,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrListView(
      controller: scrollController,
      children: [
        const HarbrHeader(text: 'Metadata'),
        _metadataBlock(),
        const HarbrHeader(text: 'Session'),
        _sessionBlock(),
        const HarbrHeader(text: 'Player'),
        _playerBlock(),
      ],
    );
  }

  Widget _metadataBlock() {
    return HarbrTableCard(
      content: [
        HarbrTableContent(title: 'status', body: history.lsStatus),
        HarbrTableContent(title: 'title', body: history.lsFullTitle),
        if (history.year != null)
          HarbrTableContent(title: 'year', body: history.year.toString()),
        HarbrTableContent(title: 'user', body: history.friendlyName),
      ],
    );
  }

  Widget _sessionBlock() {
    return HarbrTableCard(
      content: [
        HarbrTableContent(title: 'state', body: history.lsState),
        HarbrTableContent(
            title: 'date',
            body: DateFormat('yyyy-MM-dd').format(history.date!)),
        HarbrTableContent(title: 'started', body: history.date!.asTimeOnly()),
        HarbrTableContent(
            title: 'stopped',
            body: history.state == null
                ? history.stopped!.asTimeOnly()
                : HarbrUI.TEXT_EMDASH),
        HarbrTableContent(
            title: 'paused', body: history.pausedCounter!.asWordsTimestamp()),
      ],
    );
  }

  Widget _playerBlock() {
    return HarbrTableCard(
      content: [
        HarbrTableContent(title: 'location', body: history.ipAddress),
        HarbrTableContent(title: 'platform', body: history.platform),
        HarbrTableContent(title: 'product', body: history.product),
        HarbrTableContent(title: 'player', body: history.player),
      ],
    );
  }
}
