import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/state.dart';

class ReadarrAddBookDetailsMonitoredTile extends StatelessWidget {
  const ReadarrAddBookDetailsMonitoredTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.Monitored'.tr(),
      trailing: HarbrSwitch(
        value: context.watch<ReadarrAddBookDetailsState>().monitored,
        onChanged: (value) {
          context.read<ReadarrAddBookDetailsState>().monitored = value;
        },
      ),
    );
  }
}
