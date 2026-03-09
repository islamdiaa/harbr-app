import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMovieDetailsFilesExtraFileBlock extends StatelessWidget {
  final RadarrExtraFile file;

  const RadarrMovieDetailsFilesExtraFileBlock({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(title: 'relative path', body: file.harbrRelativePath),
        HarbrTableContent(title: 'type', body: file.harbrType),
        HarbrTableContent(title: 'extension', body: file.harbrExtension),
      ],
    );
  }
}
