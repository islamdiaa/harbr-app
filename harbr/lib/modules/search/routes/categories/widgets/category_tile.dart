import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/search.dart';
import 'package:harbr/router/routes/search.dart';

class SearchCategoryTile extends StatelessWidget {
  final NewznabCategoryData category;
  final int index;

  const SearchCategoryTile({
    Key? key,
    required this.category,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: category.name ?? 'harbr.Unknown'.tr(),
      body: [TextSpan(text: category.subcategoriesTitleList)],
      trailing: HarbrIconButton(
        icon: category.icon,
        color: HarbrColours().byListIndex(index),
      ),
      onTap: () async {
        context.read<SearchState>().activeCategory = category;
        SearchRoutes.SUBCATEGORIES.go();
      },
    );
  }
}
