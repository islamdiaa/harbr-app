import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/search.dart';

class SearchResultTile extends StatelessWidget {
  final NewznabResultData data;

  const SearchResultTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrExpandableListTile(
      title: data.title,
      collapsedSubtitles: [
        _subtitle1(),
        _subtitle2(),
      ],
      expandedTableContent: _tableContent(),
      collapsedTrailing: _trailing(context),
      expandedTableButtons: _tableButtons(context),
    );
  }

  TextSpan _subtitle1() {
    return TextSpan(children: [
      TextSpan(text: data.size.asBytes()),
      TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
      TextSpan(text: data.category),
    ]);
  }

  TextSpan _subtitle2() {
    return TextSpan(text: data.age);
  }

  List<HarbrTableContent> _tableContent() {
    return [
      HarbrTableContent(title: 'search.Age'.tr(), body: data.age),
      HarbrTableContent(title: 'search.Size'.tr(), body: data.size.asBytes()),
      HarbrTableContent(title: 'search.Category'.tr(), body: data.category),
      if (SearchDatabase.SHOW_LINKS.read())
        HarbrTableContent(title: '', body: ''),
      if (SearchDatabase.SHOW_LINKS.read())
        HarbrTableContent(
            title: 'search.Comments'.tr(),
            body: data.linkComments,
            bodyIsUrl: true),
      if (SearchDatabase.SHOW_LINKS.read())
        HarbrTableContent(
            title: 'search.Download'.tr(),
            body: data.linkDownload,
            bodyIsUrl: true),
    ];
  }

  List<HarbrButton> _tableButtons(BuildContext context) {
    return [
      HarbrButton.text(
        icon: Icons.download_rounded,
        text: 'search.Download'.tr(),
        onTap: () async => _sendToClient(context),
      ),
    ];
  }

  HarbrIconButton _trailing(BuildContext context) {
    return HarbrIconButton(
      icon: Icons.download_rounded,
      onPressed: () => _sendToClient(context),
    );
  }

  Future<void> _sendToClient(BuildContext context) async {
    Tuple2<bool, SearchDownloadType?> result =
        await SearchDialogs().downloadResult(context);
    if (result.item1) result.item2!.execute(context, data);
  }
}
