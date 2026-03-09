import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesEditQualityProfileTile extends StatelessWidget {
  final List<SonarrQualityProfile?> profiles;

  const SonarrSeriesEditQualityProfileTile({
    Key? key,
    required this.profiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'sonarr.QualityProfile'.tr(),
      body: [
        TextSpan(
          text: context.watch<SonarrSeriesEditState>().qualityProfile?.name ??
              HarbrUI.TEXT_EMDASH,
        )
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    Tuple2<bool, SonarrQualityProfile?> result =
        await SonarrDialogs().editQualityProfile(context, profiles);
    if (result.item1)
      context.read<SonarrSeriesEditState>().qualityProfile = result.item2!;
  }
}
