import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrManualImportParentDirectoryTile extends StatefulWidget {
  final RadarrFileSystem? fileSystem;

  const RadarrManualImportParentDirectoryTile({
    Key? key,
    required this.fileSystem,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrManualImportParentDirectoryTile> {
  HarbrLoadingState _loadingState = HarbrLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    if (widget.fileSystem == null ||
        widget.fileSystem!.parent == null ||
        widget.fileSystem!.parent!.isEmpty) return const SizedBox(height: 0.0);
    return HarbrBlock(
      title: HarbrUI.TEXT_ELLIPSIS,
      body: [TextSpan(text: 'radarr.ParentDirectory'.tr())],
      trailing: HarbrIconButton(
        icon: Icons.arrow_upward_rounded,
        loadingState: _loadingState,
      ),
      onTap: () async {
        if (_loadingState == HarbrLoadingState.INACTIVE) {
          if (mounted) setState(() => _loadingState = HarbrLoadingState.ACTIVE);
          context.read<RadarrManualImportState>().fetchDirectories(
                context,
                widget.fileSystem!.parent,
              );
        }
      },
    );
  }
}
