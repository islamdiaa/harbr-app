import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/search.dart';
import 'package:harbr/router/routes/search.dart';

class SearchSubcategoryTile extends StatelessWidget {
  final int index;

  const SearchSubcategoryTile({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SearchState, NewznabCategoryData?>(
      selector: (_, state) => state.activeCategory,
      builder: (context, category, _) {
        NewznabSubcategoryData subcategory = category!.subcategories[index];
        return HarbrBlock(
          title: subcategory.name ?? 'harbr.Unknown'.tr(),
          body: [
            TextSpan(
              text: [
                category.name ?? 'harbr.Unknown'.tr(),
                subcategory.name ?? 'harbr.Unknown'.tr(),
              ].join(' > '),
            )
          ],
          trailing: HarbrIconButton(
            icon: category.icon,
            color: HarbrColours().byListIndex(index + 1),
          ),
          onTap: () async {
            context.read<SearchState>().activeSubcategory = subcategory;
            SearchRoutes.RESULTS.go();
          },
        );
      },
    );
  }
}
