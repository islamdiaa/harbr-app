import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/edit_author/state.dart';

class ReadarrEditAuthorActionBar extends StatelessWidget {
  const ReadarrEditAuthorActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBottomActionBar(
      actions: [
        HarbrButton.text(
          text: 'readarr.UpdateAuthor'.tr(),
          icon: Icons.save_rounded,
          onTap: () async => _save(context),
        ),
        HarbrButton.text(
          text: 'readarr.RemoveAuthor'.tr(),
          icon: Icons.delete_rounded,
          color: HarbrColours.red,
          onTap: () async => _delete(context),
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context) async {
    ReadarrEditAuthorState editState = context.read<ReadarrEditAuthorState>();
    if (!editState.canExecuteAction) return;

    ReadarrAuthor author = editState.author!.clone();
    author.monitored = editState.author!.monitored;
    author.qualityProfileId = editState.qualityProfile?.id;
    author.metadataProfileId = editState.metadataProfile?.id;
    author.tags = editState.tags.map((t) => t.id!).toList();
    author.path = editState.author!.path;

    bool result = await ReadarrAPIController().updateAuthor(
      context: context,
      author: author,
    );
    if (result) Navigator.of(context).pop();
  }

  Future<void> _delete(BuildContext context) async {
    ReadarrEditAuthorState editState = context.read<ReadarrEditAuthorState>();
    if (!editState.canExecuteAction) return;

    bool confirmed = await ReadarrDialogs().confirmDeleteAuthor(context);
    if (confirmed) {
      bool result = await ReadarrAPIController().removeAuthor(
        context: context,
        author: editState.author!,
      );
      if (result) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }
}
