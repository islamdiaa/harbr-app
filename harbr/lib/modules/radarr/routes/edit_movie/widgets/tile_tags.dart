import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMoviesEditTagsTile extends StatelessWidget {
  const RadarrMoviesEditTagsTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RadarrTag> _tags = context.watch<RadarrMoviesEditState>().tags;
    return HarbrBlock(
      title: 'radarr.Tags'.tr(),
      body: [
        TextSpan(
          text: _tags.isEmpty
              ? HarbrUI.TEXT_EMDASH
              : _tags.map((e) => e.label).join(', '),
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async => await RadarrDialogs().setEditTags(context),
    );
  }
}
