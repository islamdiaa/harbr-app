import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrRootFolderTile extends StatelessWidget {
  final RadarrRootFolder rootFolder;

  const RadarrRootFolderTile({
    Key? key,
    required this.rootFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: rootFolder.harbrPath,
      body: [
        TextSpan(text: rootFolder.harbrSpace),
        TextSpan(
          text: rootFolder.harbrUnmappedFolders,
          style: const TextStyle(
            color: HarbrColours.accent,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
        )
      ],
    );
  }
}
