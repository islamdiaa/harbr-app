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

  double get _progressValue {
    if (queueRecord.size == null || queueRecord.size == 0) return 0.0;
    double left = queueRecord.sizeleft ?? 0;
    return (1 - (left / queueRecord.size!)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return HarbrMediaRow(
      title: queueRecord.harbrTitle,
      subtitle: '${queueRecord.harbrPercentDone} \u2022 ${queueRecord.timeleft ?? HarbrUI.TEXT_EMDASH}',
      status: _statusSection(),
      metadata: _metaChips(),
      trailing: (queueRecord.statusMessages ?? []).isNotEmpty
          ? _trailing(context)
          : null,
      onTap: () => _onTap(context),
      onLongPress: () => _removeFromQueue(context),
    );
  }

  StatusType _mapStatusType() {
    final status = queueRecord.status?.toLowerCase() ?? '';
    if (status == 'completed') return StatusType.downloaded;
    if (status == 'failed' || status == 'warning') return StatusType.error;
    if (status == 'downloading' || status == 'queued') return StatusType.queued;
    return StatusType.importing;
  }

  Widget _statusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HarbrStatusBadge(
              type: _mapStatusType(),
              label: queueRecord.harbrStatus,
            ),
            const SizedBox(width: HarbrTokens.xs),
            HarbrMetaChip(
              label: queueRecord.harbrPercentDone,
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        HarbrProgressBar(
          progress: _progressValue,
          height: 3.0,
        ),
      ],
    );
  }

  List<Widget> _metaChips() {
    return [
      HarbrMetaChip(
        icon: Icons.storage_rounded,
        label: queueRecord.harbrSizeleft,
      ),
      if ((queueRecord.downloadClient ?? '').isNotEmpty)
        HarbrMetaChip(
          icon: Icons.download_rounded,
          label: queueRecord.downloadClient!,
        ),
      HarbrMetaChip(
        icon: Icons.schedule_rounded,
        label: queueRecord.timeleft ?? HarbrUI.TEXT_EMDASH,
      ),
    ];
  }

  Widget _trailing(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HarbrDialogs().showMessages(
          context,
          queueRecord.statusMessages!
              .map<String>((status) => status.messages!.join('\n'))
              .toList(),
        );
      },
      child: Icon(
        Icons.messenger_outline_rounded,
        size: HarbrTokens.iconSm,
        color: context.harbr.warning,
      ),
    );
  }

  void _onTap(BuildContext context) {
    HarbrBottomModalSheet().show(
      builder: (_) => HarbrListViewModal(
        children: [
          HarbrHeader(text: queueRecord.harbrTitle),
          // Highlighted nodes
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HarbrUI.DEFAULT_MARGIN_SIZE,
              vertical: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
            ),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
              runSpacing: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
              children: [
                HarbrHighlightedNode(
                  text: queueRecord.harbrStatus,
                  backgroundColor: HarbrColours.accent,
                ),
              ],
            ),
          ),
          // Table content
          ...[
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
          ].map((item) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: HarbrUI.DEFAULT_MARGIN_SIZE,
                ),
                child: item,
              )),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
            ),
            child: Wrap(
              children: List.generate(
                _tableButtons(context).length,
                (index) {
                  final buttons = _tableButtons(context);
                  int bCount = buttons.length;
                  double widthFactor = 0.5;
                  if (index == (bCount - 1) && bCount.isOdd) {
                    widthFactor = 1;
                  }
                  return FractionallySizedBox(
                    widthFactor: widthFactor,
                    child: buttons[index],
                  );
                },
              ),
            ),
          ),
        ],
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
