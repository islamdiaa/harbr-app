import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/edit_author/state.dart';

class ReadarrEditAuthorTagsTile extends StatelessWidget {
  const ReadarrEditAuthorTagsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ReadarrTag> tags = context.watch<ReadarrEditAuthorState>().tags;
    return HarbrBlock(
      title: 'readarr.Tags'.tr(),
      body: [
        TextSpan(
          text: tags.isEmpty
              ? HarbrUI.TEXT_EMDASH
              : tags.map((t) => t.label).join(', '),
        ),
      ],
      trailing: const HarbrIconButton(icon: Icons.arrow_forward_ios_rounded),
    );
  }
}
