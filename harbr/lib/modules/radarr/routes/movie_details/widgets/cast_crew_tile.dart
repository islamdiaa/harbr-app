import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/links.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrMovieDetailsCastCrewTile extends StatelessWidget {
  final RadarrMovieCredits credits;

  const RadarrMovieDetailsCastCrewTile({
    Key? key,
    required this.credits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: credits.personName,
      posterPlaceholderIcon: HarbrIcons.USER,
      posterUrl: credits.images!.isEmpty ? null : credits.images![0].url,
      body: [
        TextSpan(text: _position),
        TextSpan(
          text: credits.type!.readable,
          style: TextStyle(
            fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
            color: credits.type == RadarrCreditType.CAST
                ? HarbrColours.accent
                : HarbrColours.orange,
          ),
        ),
      ],
      onTap: credits.personTmdbId?.toString().openTmdbPerson,
    );
  }

  String? get _position {
    switch (credits.type) {
      case RadarrCreditType.CREW:
        return credits.job!.isEmpty ? HarbrUI.TEXT_EMDASH : credits.job;
      case RadarrCreditType.CAST:
        return credits.character!.isEmpty
            ? HarbrUI.TEXT_EMDASH
            : credits.character;
      default:
        return HarbrUI.TEXT_EMDASH;
    }
  }
}
