import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/widgets/pages/invalid_route.dart';

class ConfigurationSearchAddIndexerHeadersRoute extends StatefulWidget {
  final HarbrIndexer? indexer;

  const ConfigurationSearchAddIndexerHeadersRoute({
    Key? key,
    required this.indexer,
  }) : super(key: key);

  @override
  State<ConfigurationSearchAddIndexerHeadersRoute> createState() => _State();
}

class _State extends State<ConfigurationSearchAddIndexerHeadersRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (widget.indexer == null) {
      return InvalidRoutePage(
        title: 'settings.CustomHeaders'.tr(),
        message: 'search.IndexerNotFound'.tr(),
      );
    }

    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomActionBar(),
    );
  }

  PreferredSizeWidget _appBar() {
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
          onTap: () async {
            await HeaderUtility()
                .addHeader(context, headers: widget.indexer!.headers);
            if (mounted) setState(() {});
          },
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        if (widget.indexer!.headers.isEmpty)
          HarbrMessage.inList(text: 'settings.NoHeadersAdded'.tr()),
        ..._list(),
      ],
    );
  }

  List<Widget> _list() {
    final headers = widget.indexer!.headers.cast<String, dynamic>();
    List<String> _sortedKeys = headers.keys.toList()..sort();
    return _sortedKeys
        .map<HarbrBlock>((key) => _headerTile(key, headers[key]))
        .toList();
  }

  HarbrBlock _headerTile(String key, String? value) {
    return HarbrBlock(
      title: key.toString(),
      body: [TextSpan(text: value.toString())],
      trailing: HarbrIconButton(
        icon: HarbrIcons.DELETE,
        color: HarbrColours.red,
        onPressed: () async {
          await HeaderUtility().deleteHeader(
            context,
            headers: widget.indexer!.headers,
            key: key,
          );
          if (mounted) setState(() {});
        },
      ),
    );
  }
}
