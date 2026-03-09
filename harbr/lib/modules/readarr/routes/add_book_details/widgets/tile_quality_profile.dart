import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/state.dart';

class ReadarrAddBookDetailsQualityProfileTile extends StatelessWidget {
  const ReadarrAddBookDetailsQualityProfileTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.QualityProfile'.tr(),
      body: [
        TextSpan(
          text: _displayName(
              context.watch<ReadarrAddBookDetailsState>().qualityProfile?.name),
        ),
      ],
      trailing: const HarbrIconButton(icon: Icons.arrow_forward_ios_rounded),
      onTap: () async {
        List<ReadarrQualityProfile> profiles =
            await context.read<ReadarrState>().qualityProfiles!;
        Tuple2<bool, ReadarrQualityProfile?> result =
            await ReadarrDialogs().editQualityProfile(context, profiles);
        if (result.item1) {
          context.read<ReadarrAddBookDetailsState>().qualityProfile =
              result.item2;
        }
      },
    );
  }

  String _displayName(String? name) {
    if (name == null) return HarbrUI.TEXT_EMDASH;
    if (name.toLowerCase() == 'spoken') return 'Audiobook';
    return name;
  }
}
