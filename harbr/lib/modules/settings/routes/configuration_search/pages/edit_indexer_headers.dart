import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ConfigurationSearchEditIndexerHeadersRoute extends StatefulWidget {
  final int id;

  const ConfigurationSearchEditIndexerHeadersRoute({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ConfigurationSearchEditIndexerHeadersRoute> createState() => _State();
}

class _State extends State<ConfigurationSearchEditIndexerHeadersRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HarbrIndexer? _indexer;

  @override
  Widget build(BuildContext context) {
    if (widget.id < 0 || !HarbrBox.indexers.contains(widget.id)) {
      return InvalidRoutePage(
        title: 'settings.CustomHeaders'.tr(),
        message: 'search.IndexerNotFound'.tr(),
      );
    }

    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'settings.CustomHeaders'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomActionBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'settings.AddHeader'.tr(),
          icon: Icons.add_rounded,
          onTap: () async => HeaderUtility().addHeader(context,
              headers: _indexer!.headers, indexer: _indexer),
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrBox.indexers.listenableBuilder(
      selectKeys: [widget.id],
      builder: (context, _) {
        if (!HarbrBox.indexers.contains(widget.id)) return Container();
        _indexer = HarbrBox.indexers.read(widget.id);
        return HarbrListView(
          controller: scrollController,
          children: [
            if (_indexer!.headers.isEmpty)
              HarbrMessage.inList(text: 'settings.NoHeadersAdded'.tr()),
            ..._list(),
          ],
        );
      },
    );
  }

  List<Widget> _list() {
    final headers = _indexer!.headers.cast<String, dynamic>();
    List<String> _sortedKeys = headers.keys.toList()..sort();
    return _sortedKeys
        .map<HarbrBlock>((key) => _headerBlock(key, headers[key]))
        .toList();
  }

  HarbrBlock _headerBlock(String key, String? value) {
    return HarbrBlock(
      title: key.toString(),
      body: [TextSpan(text: value.toString())],
      trailing: HarbrIconButton(
        icon: HarbrIcons.DELETE,
        color: HarbrColours.red,
        onPressed: () async => HeaderUtility().deleteHeader(
          context,
          headers: _indexer!.headers,
          key: key,
          indexer: _indexer,
        ),
      ),
    );
  }
}
