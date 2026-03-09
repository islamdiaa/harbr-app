import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/modules/search/core.dart';
import 'package:harbr/router/routes/settings.dart';

class ConfigurationSearchRoute extends StatefulWidget {
  const ConfigurationSearchRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationSearchRoute> createState() => _State();
}

class _State extends State<ConfigurationSearchRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'search.Search'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _bottomNavigationBar() {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'search.AddIndexer'.tr(),
          icon: Icons.add_rounded,
          onTap: SettingsRoutes.CONFIGURATION_SEARCH_ADD_INDEXER.go,
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrBox.indexers.listenableBuilder(
      builder: (context, _) => HarbrListView(
        controller: scrollController,
        children: [
          HarbrModule.SEARCH.informationBanner(),
          ..._indexerSection(),
          ..._customization(),
        ],
      ),
    );
  }

  List<Widget> _indexerSection() {
    if (HarbrBox.indexers.isEmpty) {
      return [HarbrMessage(text: 'search.NoIndexersFound'.tr())];
    }
    return _indexers;
  }

  List<Widget> get _indexers {
    List<HarbrIndexer> indexers = HarbrBox.indexers.data.toList();
    indexers.sort((a, b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    List<HarbrBlock> list = List.generate(
      indexers.length,
      (index) =>
          _indexerTile(indexers[index], indexers[index].key) as HarbrBlock,
    );
    return list;
  }

  Widget _indexerTile(HarbrIndexer indexer, int index) {
    return HarbrBlock(
      title: indexer.displayName,
      body: [TextSpan(text: indexer.host)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () => SettingsRoutes.CONFIGURATION_SEARCH_EDIT_INDEXER.go(
        params: {
          'id': index.toString(),
        },
      ),
    );
  }

  List<Widget> _customization() {
    return [
      HarbrDivider(),
      _hideAdultCategories(),
      _showLinks(),
    ];
  }

  Widget _hideAdultCategories() {
    const _db = SearchDatabase.HIDE_XXX;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'search.HideAdultCategories'.tr(),
        body: [TextSpan(text: 'search.HideAdultCategoriesDescription'.tr())],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }

  Widget _showLinks() {
    const _db = SearchDatabase.SHOW_LINKS;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'search.ShowLinks'.tr(),
        body: [TextSpan(text: 'search.ShowLinksDescription'.tr())],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: _db.update,
        ),
      ),
    );
  }
}
