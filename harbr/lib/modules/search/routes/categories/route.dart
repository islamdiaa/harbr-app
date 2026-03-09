import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/search.dart';
import 'package:harbr/router/routes/search.dart';

class CategoriesRoute extends StatefulWidget {
  const CategoriesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriesRoute> createState() => _State();
}

class _State extends State<CategoriesRoute>
    with HarbrLoadCallbackMixin, HarbrScrollControllerMixin {
  static const ADULT_CATEGORIES = ['xxx', 'adult', 'porn'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Future<void> loadCallback() async {
    context.read<SearchState>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: context.read<SearchState>().indexer.displayName,
      scrollControllers: [scrollController],
      actions: <Widget>[
        HarbrIconButton(
          icon: Icons.search_rounded,
          onPressed: _enterSearch,
        ),
      ],
    );
  }

  Widget _body() {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: FutureBuilder(
        future: context.watch<SearchState>().categories,
        builder: (context, AsyncSnapshot<List<NewznabCategoryData>> snapshot) {
          if (snapshot.hasError) {
            HarbrLogger().error(
              'Unable to fetch categories',
              snapshot.error,
              snapshot.stackTrace,
            );
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) return _list(snapshot.data!);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(List<NewznabCategoryData> categories) {
    if (categories.isEmpty) {
      return HarbrMessage.goBack(
        context: context,
        text: 'search.NoCategoriesFound'.tr(),
      );
    }
    List<NewznabCategoryData> filtered = _filter(categories);
    return HarbrListViewBuilder(
      controller: scrollController,
      itemCount: filtered.length,
      itemBuilder: (context, index) => SearchCategoryTile(
        category: filtered[index],
        index: index,
      ),
    );
  }

  List<NewznabCategoryData> _filter(List<NewznabCategoryData> categories) {
    return categories.where((category) {
      if (!SearchDatabase.HIDE_XXX.read()) return true;
      if (category.id >= 6000 && category.id <= 6999) return false;
      if (ADULT_CATEGORIES.contains(category.name!.toLowerCase().trim())) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _enterSearch() async {
    context.read<SearchState>().activeCategory = null;
    context.read<SearchState>().activeSubcategory = null;
    SearchRoutes.SEARCH.go();
  }
}
