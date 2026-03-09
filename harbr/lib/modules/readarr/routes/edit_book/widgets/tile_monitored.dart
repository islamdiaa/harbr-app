import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr/routes/edit_book/state.dart';

class ReadarrEditBookMonitoredTile extends StatelessWidget {
  const ReadarrEditBookMonitoredTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.Monitored'.tr(),
      trailing: HarbrSwitch(
        value: context.watch<ReadarrEditBookState>().book?.monitored ?? false,
        onChanged: (value) {
          context.read<ReadarrEditBookState>().setMonitored(value);
        },
      ),
    );
  }
}
