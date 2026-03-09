import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/double/time.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrReleaseExtension on SonarrRelease {
  IconData get harbrTrailingIcon {
    if (this.approved!) return Icons.download_rounded;
    return Icons.report_outlined;
  }

  Color get harbrTrailingColor {
    if (this.approved!) return Colors.white;
    return HarbrColours.red;
  }

  String get harbrProtocol {
    if (this.protocol != null) {
      return this.protocol == SonarrProtocol.TORRENT
          ? '${this.protocol!.harbrReadable()} (${this.seeders ?? 0}/${this.leechers ?? 0})'
          : this.protocol!.harbrReadable();
    }
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrIndexer {
    if (this.indexer != null && this.indexer!.isNotEmpty) return this.indexer;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrAge {
    if (this.ageHours != null) return this.ageHours!.asTimeAgo();
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrQuality {
    if (this.quality != null && this.quality!.quality != null)
      return this.quality!.quality!.name;
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrLanguage {
    if (this.language != null && this.language != null)
      return this.language!.name;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrSize {
    if (this.size != null) return this.size.asBytes();
    return HarbrUI.TEXT_EMDASH;
  }

  String? harbrPreferredWordScore({bool nullOnEmpty = false}) {
    if ((this.preferredWordScore ?? 0) != 0) {
      String _prefix = this.preferredWordScore! > 0 ? '+' : '';
      return '$_prefix${this.preferredWordScore}';
    }
    if (nullOnEmpty) return null;
    return HarbrUI.TEXT_EMDASH;
  }
}
