import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/duration/timestamp.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/router/routes/tautulli.dart';

class TautulliLibrariesLibraryTile extends StatelessWidget {
  final TautulliTableLibrary library;

  const TautulliLibrariesLibraryTile({
    Key? key,
    required this.library,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? _plays = library.plays;
    return HarbrBlock(
      title: library.sectionName,
      body: [
        TextSpan(text: library.readableCount),
        TextSpan(
          children: [
            TextSpan(text: _plays == 1 ? '1 Play' : '$_plays Plays'),
            TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
            TextSpan(text: library.duration!.asWordsTimestamp()),
          ],
        ),
        TextSpan(
          style: const TextStyle(
            color: HarbrColours.accent,
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
          ),
          text: library.lastAccessed?.asAge() ?? 'Unknown',
        ),
      ],
      backgroundUrl:
          context.watch<TautulliState>().getImageURLFromPath(library.thumb),
      backgroundHeaders: context.watch<TautulliState>().headers,
      onTap: () => TautulliRoutes.LIBRARIES_DETAILS.go(params: {
        'section': library.sectionId.toString(),
      }),
    );
  }
}
