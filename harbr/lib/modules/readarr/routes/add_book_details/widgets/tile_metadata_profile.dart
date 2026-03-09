import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/state.dart';

class ReadarrAddBookDetailsMetadataProfileTile extends StatelessWidget {
  const ReadarrAddBookDetailsMetadataProfileTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.MetadataProfile'.tr(),
      body: [
        TextSpan(
          text: context
                  .watch<ReadarrAddBookDetailsState>()
                  .metadataProfile
                  ?.name ??
              HarbrUI.TEXT_EMDASH,
        ),
      ],
      trailing: const HarbrIconButton(icon: Icons.arrow_forward_ios_rounded),
      onTap: () async {
        List<ReadarrMetadataProfile> profiles =
            await context.read<ReadarrState>().metadataProfiles!;
        Tuple2<bool, ReadarrMetadataProfile?> result =
            await ReadarrDialogs().editMetadataProfile(context, profiles);
        if (result.item1) {
          context.read<ReadarrAddBookDetailsState>().metadataProfile =
              result.item2;
        }
      },
    );
  }
}
