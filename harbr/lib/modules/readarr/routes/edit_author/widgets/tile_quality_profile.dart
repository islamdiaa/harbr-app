import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/edit_author/state.dart';

class ReadarrEditAuthorQualityProfileTile extends StatelessWidget {
  final List<ReadarrQualityProfile> profiles;

  const ReadarrEditAuthorQualityProfileTile({
    Key? key,
    required this.profiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.QualityProfile'.tr(),
      body: [
        TextSpan(
          text: _displayName(
              context.watch<ReadarrEditAuthorState>().qualityProfile?.name),
        ),
      ],
      trailing: const HarbrIconButton(icon: Icons.arrow_forward_ios_rounded),
      onTap: () async {
        Tuple2<bool, ReadarrQualityProfile?> result =
            await ReadarrDialogs().editQualityProfile(context, profiles);
        if (result.item1) {
          context.read<ReadarrEditAuthorState>().qualityProfile = result.item2;
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
