import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrImportMode on RadarrImportMode {
  String get harbrReadable {
    switch (this) {
      case RadarrImportMode.COPY:
        return 'radarr.CopyFull'.tr();
      case RadarrImportMode.MOVE:
        return 'radarr.MoveFull'.tr();
    }
  }

  IconData get harbrIcon {
    switch (this) {
      case RadarrImportMode.COPY:
        return Icons.copy_rounded;
      case RadarrImportMode.MOVE:
        return Icons.drive_file_move_outline;
    }
  }
}
