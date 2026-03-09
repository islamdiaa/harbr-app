import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/search.dart';

class SearchRoute extends StatefulWidget {
  const SearchRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchRoute> createState() => _State();
}

class _State extends State<SearchRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      drawer: _drawer(),
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      useDrawer: true,
      title: HarbrModule.SEARCH.title,
      scrollControllers: [scrollController],
    );
  }

  Widget _drawer() => HarbrDrawer(page: HarbrModule.SEARCH.key);

  Widget _body() {
    if (HarbrBox.indexers.isEmpty) {
      return HarbrMessage.moduleNotEnabled(
        context: context,
        module: HarbrModule.SEARCH.title,
      );
    }
    return HarbrListView(
      controller: scrollController,
      children: _list,
    );
  }

  List<Widget> get _list {
    final list = HarbrBox.indexers.data
        .map((indexer) => SearchIndexerTile(indexer: indexer))
        .toList();
    list.sort((a, b) => a.indexer!.displayName
        .toLowerCase()
        .compareTo(b.indexer!.displayName.toLowerCase()));

    return list;
  }
}
