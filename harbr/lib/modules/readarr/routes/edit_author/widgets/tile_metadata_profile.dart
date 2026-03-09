import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/edit_author/state.dart';

class ReadarrEditAuthorMetadataProfileTile extends StatelessWidget {
  final List<ReadarrMetadataProfile> profiles;

  const ReadarrEditAuthorMetadataProfileTile({
    Key? key,
    required this.profiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.MetadataProfile'.tr(),
      body: [
        TextSpan(
          text:
              context.watch<ReadarrEditAuthorState>().metadataProfile?.name ??
                  HarbrUI.TEXT_EMDASH,
        ),
      ],
      trailing: const HarbrIconButton(icon: Icons.arrow_forward_ios_rounded),
      onTap: () async {
        Tuple2<bool, ReadarrMetadataProfile?> result =
            await ReadarrDialogs().editMetadataProfile(context, profiles);
        if (result.item1) {
          context.read<ReadarrEditAuthorState>().metadataProfile = result.item2;
        }
      },
    );
  }
}
