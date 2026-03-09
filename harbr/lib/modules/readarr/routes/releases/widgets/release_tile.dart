import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrReleaseTile extends StatefulWidget {
  final ReadarrRelease release;

  const ReadarrReleaseTile({
    Key? key,
    required this.release,
  }) : super(key: key);

  @override
  State<ReadarrReleaseTile> createState() => _State();
}

class _State extends State<ReadarrReleaseTile> {
  HarbrLoadingState _downloadState = HarbrLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: widget.release.harbrTitle,
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
        _subtitle3(),
      ],
      collapsedTrailing: _trailing(),
      expandedHighlightedNodes: [
        HarbrHighlightedNode(
          text: widget.release.protocol?.toTitleCase() ?? HarbrUI.TEXT_EMDASH,
          backgroundColor: HarbrColours.accent,
        ),
        if (_qualityName != null)
          HarbrHighlightedNode(
            text: _qualityName!,
            backgroundColor: HarbrColours.blue,
          ),
        if (widget.release.approved ?? false)
          HarbrHighlightedNode(
            text: 'readarr.Approved'.tr(),
            backgroundColor: HarbrColours.accent,
          ),
        if (!(widget.release.approved ?? false))
          HarbrHighlightedNode(
            text: 'readarr.Rejected'.tr(),
            backgroundColor: HarbrColours.red,
          ),
      ],
      expandedTableContent: [
        HarbrTableContent(
          title: 'readarr.Indexer'.tr(),
          body: widget.release.harbrIndexer,
        ),
        if (_qualityName != null)
          HarbrTableContent(
            title: 'Format',
            body: _qualityName!,
          ),
        HarbrTableContent(
          title: 'readarr.Size'.tr(),
          body: widget.release.harbrSize,
        ),
        HarbrTableContent(
          title: 'readarr.Age'.tr(),
          body: widget.release.harbrAge,
        ),
        if (widget.release.protocol == 'torrent')
          HarbrTableContent(
            title: 'readarr.Seeders'.tr(),
            body: widget.release.harbrSeeders,
          ),
        if (widget.release.protocol == 'torrent')
          HarbrTableContent(
            title: 'readarr.Leechers'.tr(),
            body: widget.release.harbrLeechers,
          ),
      ],
      expandedTableButtons: _tableButtons(),
    );
  }

  String? get _qualityName {
    Map<String, dynamic>? quality = widget.release.quality;
    if (quality == null) return null;
    Map<String, dynamic>? inner =
        quality['quality'] as Map<String, dynamic>?;
    return inner?['name'] as String?;
  }

  Widget _trailing() {
    return HarbrIconButton(
      icon: (widget.release.approved ?? false)
          ? Icons.download_rounded
          : Icons.report_outlined,
      color: (widget.release.approved ?? false)
          ? HarbrColours.accent
          : HarbrColours.red,
      onPressed: () async =>
          (widget.release.rejected ?? false) ? _showRejections() : _download(),
      onLongPress: _download,
      loadingState: _downloadState,
    );
  }

  List<HarbrButton> _tableButtons() {
    return [
      HarbrButton(
        type: HarbrButtonType.TEXT,
        text: 'Download',
        icon: Icons.download_rounded,
        onTap: _download,
        loadingState: _downloadState,
      ),
      if (widget.release.rejected ?? false)
        HarbrButton.text(
          text: 'Rejected',
          icon: Icons.report_outlined,
          color: HarbrColours.red,
          onTap: _showRejections,
        ),
    ];
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(text: widget.release.harbrIndexer),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(
          text: widget.release.protocol?.toTitleCase() ?? HarbrUI.TEXT_EMDASH,
          style: const TextStyle(
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
            color: HarbrColours.accent,
          ),
        ),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.harbrAge),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.harbrSize),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(
          text: _qualityName ?? HarbrUI.TEXT_EMDASH,
          style: const TextStyle(
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
            color: HarbrColours.blue,
          ),
        ),
      ],
    );
  }

  TextSpan _subtitle3() {
    if (widget.release.protocol == 'torrent') {
      return TextSpan(
        children: [
          const TextSpan(text: 'Peers: '),
          TextSpan(
            text: '${widget.release.seeders ?? 0}',
            style: const TextStyle(
              fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
              color: HarbrColours.accent,
            ),
          ),
          const TextSpan(text: ' / '),
          TextSpan(
            text: '${widget.release.leechers ?? 0}',
            style: const TextStyle(
              fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
            ),
          ),
        ],
      );
    }
    return TextSpan(
      text: widget.release.protocol?.toTitleCase() ?? '',
    );
  }

  Future<void> _download() async {
    setState(() => _downloadState = HarbrLoadingState.ACTIVE);
    ReadarrAPIController()
        .downloadRelease(context: context, release: widget.release)
        .then((value) {
      if (mounted) {
        setState(() => _downloadState =
            value ? HarbrLoadingState.INACTIVE : HarbrLoadingState.ERROR);
      }
    });
  }

  Future<void> _showRejections() async {
    List<String> rejections = widget.release.rejections ?? [];
    if (rejections.isEmpty) return;
    await HarbrDialogs().showRejections(context, rejections);
  }
}
