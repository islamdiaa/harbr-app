import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/router/routes/tautulli.dart';

class TautulliActivityTile extends StatelessWidget {
  final TautulliSession session;
  final bool disableOnTap;

  const TautulliActivityTile({
    Key? key,
    required this.session,
    this.disableOnTap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: session.harbrTitle,
      posterUrl: session.harbrArtworkPath(context),
      posterHeaders: context.read<TautulliState>().headers,
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      backgroundUrl: context.watch<TautulliState>().getImageURLFromPath(
            session.art,
            width: MediaQuery.of(context).size.width.truncate(),
          ),
      body: [
        _subtitle1(),
        _subtitle2(),
        _subtitle3(),
      ],
      bottom: _bottomWidget(),
      bottomHeight: HarbrLinearPercentIndicator.height,
      trailing: HarbrIconButton(icon: session.harbrSessionStateIcon),
      onTap: disableOnTap ? null : () async => _enterDetails(context),
    );
  }

  TextSpan _subtitle1() {
    if (session.mediaType == TautulliMediaType.EPISODE) {
      return TextSpan(
        children: [
          TextSpan(text: session.parentTitle),
          TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
          TextSpan(
              text: 'tautulli.Episode'.tr(args: [
            session.mediaIndex?.toString() ?? HarbrUI.TEXT_EMDASH
          ])),
          const TextSpan(text: ': '),
          TextSpan(
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
            text: session.title ?? HarbrUI.TEXT_EMDASH,
          ),
        ],
      );
    }
    if (session.mediaType == TautulliMediaType.MOVIE) {
      return TextSpan(text: session.year.toString());
    }
    if (session.mediaType == TautulliMediaType.TRACK) {
      return TextSpan(
        children: [
          TextSpan(text: session.parentTitle),
          TextSpan(text: HarbrUI.TEXT_EMDASH.pad()),
          TextSpan(
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
            text: session.title,
          ),
        ],
      );
    }
    if (session.mediaType == TautulliMediaType.LIVE) {
      return TextSpan(text: session.title);
    }
    return const TextSpan(text: HarbrUI.TEXT_EMDASH);
  }

  TextSpan _subtitle2() {
    return TextSpan(text: session.harbrFriendlyName);
  }

  TextSpan _subtitle3() {
    return TextSpan(
      text: session.formattedStream(),
      style: const TextStyle(
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        color: HarbrColours.accent,
      ),
    );
  }

  Widget _bottomWidget() {
    return SizedBox(
      height: HarbrLinearPercentIndicator.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          HarbrLinearPercentIndicator(
            percent: session.harbrTranscodeProgress,
            progressColor: HarbrColours.accent.withOpacity(
              HarbrUI.OPACITY_SPLASH,
            ),
            backgroundColor: Colors.transparent,
          ),
          HarbrLinearPercentIndicator(
            percent: session.harbrProgressPercent,
            progressColor: HarbrColours.accent,
            backgroundColor: HarbrColours.grey.withOpacity(
              HarbrUI.OPACITY_SPLASH,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _enterDetails(BuildContext context) async {
    TautulliRoutes.ACTIVITY_DETAILS.go(params: {
      'session': session.sessionKey.toString(),
    });
  }
}
