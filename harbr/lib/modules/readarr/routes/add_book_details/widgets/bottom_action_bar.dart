import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/state.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrAddBookDetailsActionBar extends StatelessWidget {
  const ReadarrAddBookDetailsActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBottomActionBar(
      actions: [
        HarbrActionBarCard(
          title: 'harbr.Options'.tr(),
          subtitle: 'readarr.StartSearchFor'.tr(),
          onTap: () async => ReadarrDialogs().addBookOptions(context),
        ),
        HarbrButton(
          type: HarbrButtonType.TEXT,
          text: 'readarr.AddBook'.tr(),
          icon: Icons.add_rounded,
          onTap: () async => _add(context),
          loadingState: context.watch<ReadarrAddBookDetailsState>().state,
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context) async {
    ReadarrAddBookDetailsState addState =
        context.read<ReadarrAddBookDetailsState>();
    if (!addState.canExecuteAction) return;

    if (addState.rootFolder == null ||
        addState.qualityProfile == null ||
        addState.metadataProfile == null) {
      showHarbrErrorSnackBar(
        title: 'readarr.FailedToAddBook'.tr(),
        message: 'readarr.PleaseFillInRequiredFields'.tr(),
      );
      return;
    }

    addState.state = HarbrLoadingState.ACTIVE;

    try {
      ReadarrBook result = await context
          .read<ReadarrState>()
          .api!
          .book
          .create(
            book: addState.book,
            qualityProfileId: addState.qualityProfile!.id!,
            metadataProfileId: addState.metadataProfile!.id!,
            rootFolderPath: addState.rootFolder!.path!,
            monitored: addState.monitored,
            searchForNewBook:
                ReadarrDatabase.ADD_BOOK_SEARCH_FOR_MISSING.read(),
            tags: addState.tags.map((t) => t.id!).toList(),
          );
      context.read<ReadarrState>().fetchAllBooks();
      context.read<ReadarrState>().fetchAllAuthors();
      showHarbrSuccessSnackBar(
        title: 'readarr.AddedBook'.tr(),
        message: result.title ?? addState.book.title ?? '',
      );
      HarbrRouter.router.pop();
      ReadarrRoutes.BOOK.go(params: {
        'book': result.id!.toString(),
      });
    } catch (error, stack) {
      HarbrLogger().error('Failed to add book', error, stack);
      addState.state = HarbrLoadingState.ERROR;
      showHarbrErrorSnackBar(
        title: 'readarr.FailedToAddBook'.tr(),
        error: error,
      );
    }
  }
}
