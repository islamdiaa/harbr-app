import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrManualImportDirectoryTile extends StatefulWidget {
  final RadarrFileSystemDirectory directory;

  const RadarrManualImportDirectoryTile({
    Key? key,
    required this.directory,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RadarrManualImportDirectoryTile> {
  HarbrLoadingState _loadingState = HarbrLoadingState.INACTIVE;

  @override
  Widget build(BuildContext context) {
    RadarrFileSystemDirectory _dir = widget.directory;
    if (_dir.path?.isEmpty ?? true) return const SizedBox(height: 0.0);
    return HarbrBlock(
      title: _dir.name ?? HarbrUI.TEXT_EMDASH,
      body: [TextSpan(text: _dir.path)],
      trailing: HarbrIconButton.arrow(loadingState: _loadingState),
      onTap: () async {
        if (_loadingState == HarbrLoadingState.INACTIVE) {
          if (mounted) setState(() => _loadingState = HarbrLoadingState.ACTIVE);
          context.read<RadarrManualImportState>().fetchDirectories(
                context,
                _dir.path,
              );
        }
      },
    );
  }
}
