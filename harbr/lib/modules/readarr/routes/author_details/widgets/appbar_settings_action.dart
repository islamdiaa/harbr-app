import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrAuthorDetailsAppBarSettingsAction extends StatelessWidget {
  final int authorId;

  const ReadarrAuthorDetailsAppBarSettingsAction({
    Key? key,
    required this.authorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async => _showMenu(context),
    );
  }

  Future<void> _showMenu(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(HarbrUI.BORDER_RADIUS),
          topRight: Radius.circular(HarbrUI.BORDER_RADIUS),
        ),
      ),
      builder: (context) => FutureBuilder(
        future: context.read<ReadarrState>().authors,
        builder: (context, AsyncSnapshot<Map<int, ReadarrAuthor>> snapshot) {
          if (!snapshot.hasData) return const HarbrLoader();
          final author = snapshot.data![authorId];
          if (author == null) return const HarbrLoader();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HarbrBlock(
                title: 'readarr.EditAuthor'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  ReadarrRoutes.AUTHOR_EDIT.go(params: {
                    'author': authorId.toString(),
                  });
                },
                trailing: const HarbrIconButton(icon: HarbrIcons.EDIT),
              ),
              HarbrBlock(
                title: 'readarr.RefreshAuthor'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  ReadarrAPIController().refreshAuthor(
                    context: context,
                    author: author,
                  );
                },
                trailing: const HarbrIconButton(icon: Icons.refresh_rounded),
              ),
              HarbrBlock(
                title: 'readarr.SearchMonitoredBooks'.tr(),
                onTap: () {
                  Navigator.of(context).pop();
                  ReadarrAPIController().authorSearch(
                    context: context,
                    author: author,
                  );
                },
                trailing: const HarbrIconButton(icon: Icons.search_rounded),
              ),
            ],
          );
        },
      ),
    );
  }
}
