import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/book_details/state.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrBookDetailsAppBarSettingsAction extends StatelessWidget {
  final int bookId;

  const ReadarrBookDetailsAppBarSettingsAction({
    Key? key,
    required this.bookId,
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
      builder: (sheetContext) => FutureBuilder(
        future: context.read<ReadarrBookDetailsState>().book,
        builder: (sheetContext, AsyncSnapshot<ReadarrBook> snapshot) {
          if (!snapshot.hasData) return const HarbrLoader();
          final book = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HarbrBlock(
                title: 'readarr.RefreshAuthor'.tr(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  if (book.authorId != null) {
                    context
                        .read<ReadarrState>()
                        .api!
                        .command
                        .refreshAuthor(authorId: book.authorId!)
                        .then((_) {
                      showHarbrSuccessSnackBar(
                        title: 'harbr.Refreshing'.tr(),
                        message: book.title,
                      );
                    }).catchError((error, stack) {
                      HarbrLogger().error(
                        'Failed to refresh author for book: ${book.id}',
                        error,
                        stack,
                      );
                      showHarbrErrorSnackBar(
                        title: 'readarr.FailedToRefresh'.tr(),
                        error: error,
                      );
                    });
                  }
                },
                trailing: const HarbrIconButton(icon: Icons.refresh_rounded),
              ),
              HarbrBlock(
                title: 'readarr.AutomaticSearch'.tr(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ReadarrAPIController().bookSearch(
                    context: context,
                    book: book,
                  );
                },
                trailing: const HarbrIconButton(icon: Icons.search_rounded),
              ),
              HarbrBlock(
                title: 'readarr.InteractiveSearch'.tr(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ReadarrRoutes.RELEASES.go(queryParams: {
                    'book': book.id!.toString(),
                  });
                },
                trailing: const HarbrIconButton(icon: Icons.person_rounded),
              ),
              HarbrBlock(
                title: book.monitored!
                    ? 'readarr.UnmonitorBook'.tr()
                    : 'readarr.MonitorBook'.tr(),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ReadarrAPIController()
                      .toggleBookMonitored(
                    context: context,
                    book: book,
                  )
                      .then((success) {
                    if (success) {
                      context
                          .read<ReadarrBookDetailsState>()
                          .fetchBook(context);
                    }
                  });
                },
                trailing: HarbrIconButton(
                  icon: book.monitored!
                      ? Icons.turned_in_rounded
                      : Icons.turned_in_not_rounded,
                ),
              ),
              HarbrBlock(
                title: 'readarr.RemoveBook'.tr(),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  bool confirmed =
                      await ReadarrDialogs().confirmDeleteBook(context);
                  if (confirmed) {
                    ReadarrAPIController()
                        .removeBook(
                      context: context,
                      book: book,
                    )
                        .then((success) {
                      if (success) Navigator.of(context).pop();
                    });
                  }
                },
                trailing: const HarbrIconButton(
                  icon: Icons.delete_rounded,
                  color: HarbrColours.red,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
