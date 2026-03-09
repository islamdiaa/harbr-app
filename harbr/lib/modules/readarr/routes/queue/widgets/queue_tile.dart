import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/queue/state.dart';

class ReadarrQueueTile extends StatelessWidget {
  final ReadarrQueueRecord queueRecord;

  const ReadarrQueueTile({
    Key? key,
    required this.queueRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: queueRecord.harbrTitle,
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
      ],
      expandedHighlightedNodes: [
        HarbrHighlightedNode(
          text: queueRecord.harbrStatus,
          backgroundColor: HarbrColours.accent,
        ),
      ],
      expandedTableContent: [
        HarbrTableContent(
          title: 'readarr.Size'.tr(),
          body: queueRecord.harbrSizeleft,
        ),
        HarbrTableContent(
          title: 'readarr.TimeLeft'.tr(),
          body: queueRecord.timeleft ?? HarbrUI.TEXT_EMDASH,
        ),
        HarbrTableContent(
          title: 'readarr.Client'.tr(),
          body: queueRecord.downloadClient ?? HarbrUI.TEXT_EMDASH,
        ),
        HarbrTableContent(
          title: 'readarr.Indexer'.tr(),
          body: queueRecord.indexer ?? HarbrUI.TEXT_EMDASH,
        ),
      ],
      expandedTableButtons: _tableButtons(context),
      onLongPress: () async => _removeFromQueue(context),
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(text: queueRecord.harbrPercentDone),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: queueRecord.timeleft ?? HarbrUI.TEXT_EMDASH),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      text: queueRecord.harbrStatus,
      style: const TextStyle(
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        color: HarbrColours.accent,
      ),
    );
  }

  List<HarbrButton> _tableButtons(BuildContext context) {
    return [
      if ((queueRecord.statusMessages ?? []).isNotEmpty)
        HarbrButton.text(
          icon: Icons.messenger_outline_rounded,
          color: HarbrColours.orange,
          text: 'readarr.Messages'.tr(),
          onTap: () async {
            HarbrDialogs().showMessages(
              context,
              queueRecord.statusMessages!
                  .map<String>((status) => status.messages!.join('\n'))
                  .toList(),
            );
          },
        ),
      HarbrButton.text(
        icon: Icons.delete_rounded,
        color: HarbrColours.red,
        text: 'harbr.Remove'.tr(),
        onTap: () async => _removeFromQueue(context),
      ),
    ];
  }

  Future<void> _removeFromQueue(BuildContext context) async {
    bool confirmed = await ReadarrDialogs().removeFromQueue(context);
    if (confirmed) {
      bool result = await ReadarrAPIController().removeFromQueue(
        context: context,
        queueRecord: queueRecord,
        removeFromClient: ReadarrDatabase.QUEUE_REMOVE_FROM_CLIENT.read(),
        blocklist: ReadarrDatabase.QUEUE_BLOCKLIST.read(),
      );
      if (result) {
        context.read<ReadarrQueueState>().fetchQueue(context);
      }
    }
  }
}
