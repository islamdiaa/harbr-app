import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesAddDetailsUseSeasonFoldersTile extends StatelessWidget {
  const SonarrSeriesAddDetailsUseSeasonFoldersTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'sonarr.SeasonFolders'.tr(),
      trailing: HarbrSwitch(
        value: context.watch<SonarrSeriesAddDetailsState>().useSeasonFolders,
        onChanged: (value) {
          context.read<SonarrSeriesAddDetailsState>().useSeasonFolders = value;
          SonarrDatabase.ADD_SERIES_DEFAULT_USE_SEASON_FOLDERS.update(value);
        },
      ),
    );
  }
}
