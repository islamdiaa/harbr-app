import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr/routes/edit_author/state.dart';

class ReadarrEditAuthorPathTile extends StatelessWidget {
  const ReadarrEditAuthorPathTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.AuthorPath'.tr(),
      body: [
        TextSpan(
          text: context.watch<ReadarrEditAuthorState>().author?.path ??
              HarbrUI.TEXT_EMDASH,
        ),
      ],
    );
  }
}
