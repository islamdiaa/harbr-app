import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/sabnzbd.dart';
import 'package:harbr/router/routes/sabnzbd.dart';

class SABnzbdHistoryTile extends StatefulWidget {
  final SABnzbdHistoryData data;
  final Function() refresh;

  const SABnzbdHistoryTile({
    Key? key,
    required this.data,
    required this.refresh,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SABnzbdHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: widget.data.name,
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
      ],
      expandedTableContent: _expandedTableContent(),
      expandedHighlightedNodes: _expandedHighlightedNodes(),
      expandedTableButtons: _expandedButtons(),
      onLongPress: () async => _handlePopup(),
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(children: [
      TextSpan(text: widget.data.completeTimeString),
      TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
      TextSpan(text: widget.data.sizeReadable),
      TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
      TextSpan(text: widget.data.category),
    ]);
  }

  TextSpan _subtitle2() {
    return TextSpan(
      text: widget.data.statusString,
      style: TextStyle(
        color: widget.data.statusColor,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
    );
  }

  List<HarbrTableContent> _expandedTableContent() {
    return [
      HarbrTableContent(title: 'age', body: widget.data.completeTimeString),
      HarbrTableContent(title: 'size', body: widget.data.sizeReadable),
      HarbrTableContent(title: 'category', body: widget.data.category),
      HarbrTableContent(title: 'path', body: widget.data.storageLocation),
    ];
  }

  List<HarbrHighlightedNode> _expandedHighlightedNodes() {
    return [
      HarbrHighlightedNode(
        text: widget.data.status,
        backgroundColor: widget.data.statusColor,
      ),
    ];
  }

  List<HarbrButton> _expandedButtons() {
    return [
      HarbrButton.text(
        text: 'Stages',
        icon: Icons.subject_rounded,
        onTap: () async => _enterStages(),
      ),
      HarbrButton.text(
        text: 'Delete',
        icon: Icons.delete_rounded,
        color: HarbrColours.red,
        onTap: () async => _delete(),
      ),
    ];
  }

  Future<void> _enterStages() async {
    return SABnzbdRoutes.HISTORY_STAGES.go(
      extra: widget.data,
    );
  }

  Future<void> _handlePopup() async {
    List values = await SABnzbdDialogs.historySettings(
        context, widget.data.name, widget.data.failed);
    if (values[0])
      switch (values[1]) {
        case 'retry':
          _retry();
          break;
        case 'password':
          _password();
          break;
        case 'delete':
          _delete();
          break;
        default:
          HarbrLogger().warning('Unknown Case: ${values[1]}');
      }
  }

  Future<void> _delete() async {
    List values = await SABnzbdDialogs.deleteHistory(context);
    if (values[0]) {
      SABnzbdAPI.from(HarbrProfile.current)
          .deleteHistory(widget.data.nzoId)
          .then((_) => _handleRefresh('History Deleted'))
          .catchError((error) => showHarbrErrorSnackBar(
                title: 'Failed to Delete History',
                error: error,
              ));
    }
  }

  Future<void> _password() async {
    List values = await SABnzbdDialogs.setPassword(context);
    if (values[0])
      SABnzbdAPI.from(HarbrProfile.current)
          .retryFailedJobPassword(widget.data.nzoId, values[1])
          .then((_) => _handleRefresh('Password Set / Retrying...'))
          .catchError((error) => showHarbrErrorSnackBar(
                title: 'Failed to Set Password / Retry Job',
                error: error,
              ));
  }

  Future<void> _retry() async {
    SABnzbdAPI.from(HarbrProfile.current)
        .retryFailedJob(widget.data.nzoId)
        .then((_) => _handleRefresh('Retrying Job'))
        .catchError((error) => showHarbrErrorSnackBar(
              title: 'Failed to Retry Job',
              error: error,
            ));
  }

  void _handleRefresh(String title) {
    showHarbrSuccessSnackBar(
      title: title,
      message: widget.data.name,
    );
    widget.refresh();
  }
}
