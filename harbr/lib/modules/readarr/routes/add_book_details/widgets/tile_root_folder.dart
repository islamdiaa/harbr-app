import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/add_book_details/state.dart';

class ReadarrAddBookDetailsRootFolderTile extends StatelessWidget {
  const ReadarrAddBookDetailsRootFolderTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.RootFolder'.tr(),
      body: [
        TextSpan(
          text:
              context.watch<ReadarrAddBookDetailsState>().rootFolder?.path ??
                  HarbrUI.TEXT_EMDASH,
        ),
      ],
      trailing: const HarbrIconButton(icon: Icons.arrow_forward_ios_rounded),
      onTap: () async {
        List<ReadarrRootFolder> folders =
            await context.read<ReadarrState>().rootFolders!;
        Tuple2<bool, ReadarrRootFolder?> result =
            await ReadarrDialogs().editRootFolder(context, folders);
        if (result.item1) {
          context.read<ReadarrAddBookDetailsState>().rootFolder = result.item2;
        }
      },
    );
  }
}
