import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesAddDetailsTagsTile extends StatelessWidget {
  const SonarrSeriesAddDetailsTagsTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SonarrTag> _tags = context.watch<SonarrSeriesAddDetailsState>().tags;
    return HarbrBlock(
      title: 'sonarr.Tags'.tr(),
      body: [
        TextSpan(
          text: _tags.isEmpty
              ? HarbrUI.TEXT_EMDASH
              : _tags.map((e) => e.label).join(', '),
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async => await SonarrDialogs().setAddTags(context),
    );
  }
}
