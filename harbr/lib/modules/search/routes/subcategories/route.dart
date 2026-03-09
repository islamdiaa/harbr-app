import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/search.dart';
import 'package:harbr/router/routes/search.dart';

class SubcategoriesRoute extends StatefulWidget {
  const SubcategoriesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SubcategoriesRoute> createState() => _State();
}

class _State extends State<SubcategoriesRoute> with HarbrScrollControllerMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
      title: context.read<SearchState>().activeCategory?.name ??
          'search.Subcategories'.tr(),
      scrollControllers: [scrollController],
      actions: [
        HarbrIconButton(
          icon: Icons.search_rounded,
          onPressed: () async {
            context.read<SearchState>().activeSubcategory = null;
            SearchRoutes.SEARCH.go();
          },
        ),
      ],
    );
  }

  Widget _body() {
    return Selector<SearchState, NewznabCategoryData?>(
      selector: (_, state) => state.activeCategory,
      builder: (context, category, child) {
        List<NewznabSubcategoryData> subcategories =
            category?.subcategories ?? [];
        return HarbrListView(
          controller: scrollController,
          children: [
            const SearchSubcategoryAllTile(),
            ...List.generate(
              subcategories.length,
              (index) => SearchSubcategoryTile(index: index),
            ),
          ],
        );
      },
    );
  }
}
