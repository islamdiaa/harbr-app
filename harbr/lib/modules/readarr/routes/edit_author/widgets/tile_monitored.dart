import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr/routes/edit_author/state.dart';

class ReadarrEditAuthorMonitoredTile extends StatelessWidget {
  const ReadarrEditAuthorMonitoredTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.Monitored'.tr(),
      trailing: HarbrSwitch(
        value: context.watch<ReadarrEditAuthorState>().author?.monitored ?? false,
        onChanged: (value) {
          context.read<ReadarrEditAuthorState>().setMonitored(value);
        },
      ),
    );
  }
}
