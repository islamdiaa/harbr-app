import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrReleasesTile extends StatefulWidget {
  final RadarrRelease release;

  const RadarrReleasesTile({
    required this.release,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrReleasesTile> {
  HarbrLoadingState _downloadState = HarbrLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: widget.release.title!,
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

  Widget _trailing() {
    return HarbrIconButton(
      icon: widget.release.harbrTrailingIcon,
      color: widget.release.harbrTrailingColor,
      onPressed: () async =>
          widget.release.rejected! ? _showWarnings() : _startDownload(),
      onLongPress: _startDownload,
      loadingState: _downloadState,
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(
      children: [
        TextSpan(
          text: widget.release.harbrProtocol,
          style: TextStyle(
            color: widget.release.harbrProtocolColor,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        ),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.harbrIndexer),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.harbrAge),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(text: widget.release.harbrQuality),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.harbrSize),
      ],
    );
  }

  List<HarbrHighlightedNode> _highlightedNodes() {
    return [
      HarbrHighlightedNode(
        text: widget.release.protocol!.readable!,
        backgroundColor: widget.release.harbrProtocolColor,
      ),
      if (widget.release.harbrCustomFormatScore(nullOnEmpty: true) != null)
        HarbrHighlightedNode(
          text: widget.release.harbrCustomFormatScore()!,
          backgroundColor: HarbrColours.purple,
        ),
      ...widget.release.customFormats!.map<HarbrHighlightedNode>((custom) =>
          HarbrHighlightedNode(
              text: custom.name!, backgroundColor: HarbrColours.blueGrey)),
    ];
  }

  List<HarbrTableContent> _tableContent() {
    return [
      HarbrTableContent(title: 'age', body: widget.release.harbrAge),
      HarbrTableContent(title: 'indexer', body: widget.release.harbrIndexer),
      HarbrTableContent(title: 'size', body: widget.release.harbrSize),
      HarbrTableContent(
          title: 'language',
          body: widget.release.languages
                  ?.map<String>(
                      (language) => language.name ?? HarbrUI.TEXT_EMDASH)
                  .join('\n') ??
              HarbrUI.TEXT_EMDASH),
      HarbrTableContent(title: 'quality', body: widget.release.harbrQuality),
      if (widget.release.seeders != null)
        HarbrTableContent(title: 'seeders', body: '${widget.release.seeders}'),
      if (widget.release.leechers != null)
        HarbrTableContent(title: 'leechers', body: '${widget.release.leechers}'),
    ];
  }

  List<HarbrButton> _tableButtons() {
    return [
      HarbrButton(
        type: HarbrButtonType.TEXT,
        text: 'Download',
        icon: Icons.download_rounded,
        onTap: _startDownload,
        loadingState: _downloadState,
      ),
      if (widget.release.infoUrl?.isNotEmpty ?? false)
        HarbrButton.text(
          text: 'Indexer',
          icon: Icons.info_outline_rounded,
          color: HarbrColours.blue,
          onTap: widget.release.infoUrl!.openLink,
        ),
      if (widget.release.rejected!)
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
    RadarrAPIHelper()
        .pushRelease(context: context, release: widget.release)
        .then((value) {
      if (mounted)
        setState(() => _downloadState =
            value ? HarbrLoadingState.INACTIVE : HarbrLoadingState.ERROR);
    });
  }

  Future<void> _showWarnings() async => await HarbrDialogs()
      .showRejections(context, widget.release.rejections ?? []);
}
