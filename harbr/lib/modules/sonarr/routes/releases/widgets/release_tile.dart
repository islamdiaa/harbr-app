import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrReleasesTile extends StatefulWidget {
  final SonarrRelease release;

  const SonarrReleasesTile({
    required this.release,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SonarrReleasesTile> {
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
            color: widget.release.protocol!.harbrProtocolColor(
              release: widget.release,
            ),
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
    String? _preferredWordScore =
        widget.release.harbrPreferredWordScore(nullOnEmpty: true);
    return TextSpan(
      children: [
        if (_preferredWordScore != null)
          TextSpan(
            text: _preferredWordScore,
            style: const TextStyle(
              color: HarbrColours.purple,
              fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
            ),
          ),
        if (_preferredWordScore != null)
          TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.harbrQuality),
        if (widget.release.language != null)
          TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        if (widget.release.language != null)
          TextSpan(text: widget.release.harbrLanguage),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: widget.release.harbrSize),
      ],
    );
  }

  List<HarbrHighlightedNode> _highlightedNodes() {
    return [
      HarbrHighlightedNode(
        text: widget.release.protocol!.harbrReadable(),
        backgroundColor: widget.release.protocol!.harbrProtocolColor(
          release: widget.release,
        ),
      ),
      if (widget.release.harbrPreferredWordScore(nullOnEmpty: true) != null)
        HarbrHighlightedNode(
          text: widget.release.harbrPreferredWordScore()!,
          backgroundColor: HarbrColours.purple,
        ),
    ];
  }

  List<HarbrTableContent> _tableContent() {
    return [
      HarbrTableContent(
        title: 'sonarr.Age'.tr(),
        body: widget.release.harbrAge,
      ),
      HarbrTableContent(
        title: 'sonarr.Indexer'.tr(),
        body: widget.release.harbrIndexer,
      ),
      HarbrTableContent(
        title: 'sonarr.Size'.tr(),
        body: widget.release.harbrSize,
      ),
      if (widget.release.language != null)
        HarbrTableContent(
          title: 'sonarr.Language'.tr(),
          body: widget.release.harbrLanguage,
        ),
      HarbrTableContent(
        title: 'sonarr.Quality'.tr(),
        body: widget.release.harbrQuality,
      ),
      if (widget.release.seeders != null)
        HarbrTableContent(
          title: 'sonarr.Seeders'.tr(),
          body: '${widget.release.seeders}',
        ),
      if (widget.release.leechers != null)
        HarbrTableContent(
          title: 'sonarr.Leechers'.tr(),
          body: '${widget.release.leechers}',
        ),
    ];
  }

  List<HarbrButton> _tableButtons() {
    return [
      HarbrButton(
        type: HarbrButtonType.TEXT,
        text: 'sonarr.Download'.tr(),
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
          text: 'sonarr.Rejected'.tr(),
          icon: Icons.report_outlined,
          color: HarbrColours.red,
          onTap: _showWarnings,
        ),
    ];
  }

  Future<void> _startDownload() async {
    Future<void> setDownloadState(HarbrLoadingState state) async {
      if (this.mounted) setState(() => _downloadState = state);
    }

    setDownloadState(HarbrLoadingState.ACTIVE);
    SonarrAPIController()
        .downloadRelease(
          context: context,
          release: widget.release,
        )
        .whenComplete(() async => setDownloadState(HarbrLoadingState.INACTIVE));
  }

  Future<void> _showWarnings() async => await HarbrDialogs()
      .showRejections(context, widget.release.rejections ?? []);
}
