import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrAddMovieDetailsRootFolderTile extends StatelessWidget {
  const RadarrAddMovieDetailsRootFolderTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrAddMovieDetailsState, RadarrRootFolder>(
      selector: (_, state) => state.rootFolder,
      builder: (context, folder, _) => HarbrBlock(
        title: 'radarr.RootFolder'.tr(),
        body: [TextSpan(text: folder.path ?? HarbrUI.TEXT_EMDASH)],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          List<RadarrRootFolder> folders =
              await context.read<RadarrState>().rootFolders!;
          Tuple2<bool, RadarrRootFolder?> values =
              await RadarrDialogs().editRootFolder(context, folders);
          if (values.item1)
            context.read<RadarrAddMovieDetailsState>().rootFolder =
                values.item2!;
        },
      ),
    );
  }
}
