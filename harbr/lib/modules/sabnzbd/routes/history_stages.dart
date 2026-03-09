import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sabnzbd.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class HistoryStagesRoute extends StatefulWidget {
  final SABnzbdHistoryData? history;

  const HistoryStagesRoute({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  State<HistoryStagesRoute> createState() => _State();
}

class _State extends State<HistoryStagesRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (widget.history == null) {
      return InvalidRoutePage(
        title: 'Stages',
        message: 'History Record Not Found',
      );
    }

    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() => HarbrAppBar(
        title: 'Stages',
        scrollControllers: [scrollController],
      );

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: List.generate(
        widget.history!.stageLog.length,
        (index) => HarbrBlock(
          title: widget.history!.stageLog[index]['name'],
          body: [
            TextSpan(
              text: widget.history!.stageLog[index]['actions'][0]
                  .replaceAll('<br/>', '.\n'),
            ),
          ],
          trailing: const HarbrIconButton.arrow(),
          onTap: () async {
            String _data = widget.history!.stageLog[index]['actions']
                .join(',\n')
                .replaceAll('<br/>', '.\n');
            HarbrDialogs().textPreview(
                context, widget.history!.stageLog[index]['name'], _data);
          },
        ),
      ),
    );
  }
}
