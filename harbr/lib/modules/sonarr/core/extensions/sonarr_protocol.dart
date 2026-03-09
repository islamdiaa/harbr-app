import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';

extension HarbrSonarrProtocolExtension on SonarrProtocol {
  Color harbrProtocolColor({
    SonarrRelease? release,
  }) {
    if (this == SonarrProtocol.USENET) return HarbrColours.accent;
    if (release == null) return HarbrColours.blue;

    int seeders = release.seeders ?? 0;
    if (seeders > 10) return HarbrColours.blue;
    if (seeders > 0) return HarbrColours.orange;
    return HarbrColours.red;
  }

  String harbrReadable() {
    switch (this) {
      case SonarrProtocol.USENET:
        return 'sonarr.Usenet'.tr();
      case SonarrProtocol.TORRENT:
        return 'sonarr.Torrent'.tr();
    }
  }
}
