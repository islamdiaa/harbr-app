import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/double/time.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/lidarr.dart';
import 'package:harbr/router/router.dart';

class LidarrReleasesTile extends StatefulWidget {
  final LidarrReleaseData release;

  const LidarrReleasesTile({
    Key? key,
    required this.release,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LidarrReleasesTile> {
  HarbrLoadingState _downloadState = HarbrLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: widget.release.title,
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
      ],
      collapsedTrailing: _trailing(),
      expandedHighlightedNodes: _highlightedNodes(),
      expandedTableContent: _tableContent(),
      expandedTableButtons: _tableButtons(),
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(children: [
      TextSpan(
        style: TextStyle(
          color: harbrProtocolColor,
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        ),
        text: widget.release.protocol.toTitleCase(),
      ),
      if (widget.release.isTorrent)
        TextSpan(
          text: ' (${widget.release.seeders}/${widget.release.leechers})',
          style: TextStyle(
            color: harbrProtocolColor,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
      TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
      TextSpan(text: widget.release.indexer),
      TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
      TextSpan(text: widget.release.ageHours.asTimeAgo()),
    ]);
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(text: widget.release.quality),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.size.asBytes()),
      ],
    );
  }

  Widget _trailing() {
    return HarbrIconButton(
      icon: widget.release.approved
          ? Icons.file_download_rounded
          : Icons.report_outlined,
      color: widget.release.approved ? Colors.white : HarbrColours.red,
      onPressed: () async =>
          widget.release.approved ? _startDownload() : _showWarnings(),
      onLongPress: _startDownload,
      loadingState: _downloadState,
    );
  }

  List<HarbrHighlightedNode> _highlightedNodes() {
    return [
      HarbrHighlightedNode(
        text: widget.release.protocol.toTitleCase(),
        backgroundColor: harbrProtocolColor,
      ),
    ];
  }

  List<HarbrTableContent> _tableContent() {
    return [
      HarbrTableContent(
          title: 'source', body: widget.release.protocol.toTitleCase()),
      HarbrTableContent(title: 'age', body: widget.release.ageHours.asTimeAgo()),
      HarbrTableContent(title: 'indexer', body: widget.release.indexer),
      HarbrTableContent(title: 'size', body: widget.release.size.asBytes()),
      HarbrTableContent(title: 'quality', body: widget.release.quality),
      if (widget.release.protocol == 'torrent' &&
          widget.release.seeders != null)
        HarbrTableContent(title: 'seeders', body: '${widget.release.seeders}'),
      if (widget.release.protocol == 'torrent' &&
          widget.release.leechers != null)
        HarbrTableContent(title: 'leechers', body: '${widget.release.leechers}'),
    ];
  }

  Color get harbrProtocolColor {
    if (!widget.release.isTorrent) return HarbrColours.accent;
    int seeders = widget.release.seeders ?? 0;
    if (seeders > 10) return HarbrColours.blue;
    if (seeders > 0) return HarbrColours.orange;
    return HarbrColours.red;
  }

  List<HarbrButton> _tableButtons() {
    return [
      HarbrButton(
        type: HarbrButtonType.TEXT,
        icon: Icons.download_rounded,
        text: 'Download',
        onTap: _startDownload,
        loadingState: _downloadState,
      ),
      if (widget.release.infoUrl.isNotEmpty)
        HarbrButton.text(
          text: 'Indexer',
          icon: Icons.info_outline_rounded,
          color: HarbrColours.blue,
          onTap: widget.release.infoUrl.openLink,
        ),
      if (!widget.release.approved)
        HarbrButton.text(
          text: 'Rejected',
          icon: Icons.report_outlined,
          color: HarbrColours.red,
          onTap: _showWarnings,
        ),
    ];
  }

  Future<void> _startDownload() async {
    setState(() => _downloadState = HarbrLoadingState.ACTIVE);
    LidarrAPI _api = LidarrAPI.from(HarbrProfile.current);
    await _api
        .downloadRelease(widget.release.guid, widget.release.indexerId)
        .then((_) {
      showHarbrSuccessSnackBar(
        title: 'Downloading...',
        message: widget.release.title,
        showButton: true,
        buttonText: 'Back',
        buttonOnPressed: HarbrRouter().popToRootRoute,
      );
    }).catchError((error, stack) {
      showHarbrErrorSnackBar(
        title: 'Failed to Start Downloading',
        error: error,
      );
    });
    setState(() => _downloadState = HarbrLoadingState.INACTIVE);
  }

  Future<void> _showWarnings() async => await HarbrDialogs().showRejections(
        context,
        widget.release.rejections.cast<String>(),
      );
}
