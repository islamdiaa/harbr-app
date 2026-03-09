import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/utils/links.dart';

class TautulliMediaDetailsOpenPlexButton extends StatelessWidget {
  final TautulliMediaType mediaType;
  final int ratingKey;

  const TautulliMediaDetailsOpenPlexButton({
    Key? key,
    required this.mediaType,
    required this.ratingKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<TautulliState>().serverIdentity,
      builder: (context, snapshot) {
        if (_isValidMediaType() && snapshot.hasData) {
          return HarbrIconButton.appBar(
            icon: HarbrIcons.PLEX,
            onPressed: () => _openPlex(snapshot.data as TautulliServerIdentity),
          );
        }
        return const SizedBox();
      },
    );
  }

  bool _isValidMediaType() {
    const invalidTypes = [
      TautulliMediaType.TRACK,
      TautulliMediaType.PHOTO,
    ];
    return !invalidTypes.contains(mediaType);
  }

  Future<void> _openPlex(TautulliServerIdentity identity) async {
    final mobile = HarbrLinkedContent.plexMobile(
      identity.machineIdentifier!,
      ratingKey,
    );

    if (await mobile.canOpenUrl()) {
      mobile.openLink();
      return;
    }

    final web = HarbrLinkedContent.plexWeb(
      identity.machineIdentifier!,
      ratingKey,
      mediaType == TautulliMediaType.CLIP,
    );
    web.openLink();
  }
}
