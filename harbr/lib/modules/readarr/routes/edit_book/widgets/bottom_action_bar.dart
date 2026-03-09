import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/edit_book/state.dart';

class ReadarrEditBookActionBar extends StatelessWidget {
  const ReadarrEditBookActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'readarr.UpdateBook'.tr(),
          icon: Icons.save_rounded,
          onTap: () async => _save(context),
        ),
        HarbrButton.text(
          text: 'readarr.RemoveBook'.tr(),
          icon: Icons.delete_rounded,
          color: HarbrColours.red,
          onTap: () async => _delete(context),
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context) async {
    ReadarrEditBookState editState = context.read<ReadarrEditBookState>();
    if (!editState.canExecuteAction) return;

    ReadarrBook book = editState.book!.clone();
    book.monitored = editState.book!.monitored;

    bool result = await ReadarrAPIController().updateBook(
      context: context,
      book: book,
    );
    if (result) Navigator.of(context).pop();
  }

  Future<void> _delete(BuildContext context) async {
    ReadarrEditBookState editState = context.read<ReadarrEditBookState>();
    if (!editState.canExecuteAction) return;

    bool confirmed = await ReadarrDialogs().confirmDeleteBook(context);
    if (confirmed) {
      bool result = await ReadarrAPIController().removeBook(
        context: context,
        book: editState.book!,
      );
      if (result) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }
}
