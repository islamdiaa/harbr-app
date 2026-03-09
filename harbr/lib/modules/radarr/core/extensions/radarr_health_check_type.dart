import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrHealthCheckTypeExtension on RadarrHealthCheckType? {
  Color get harbrColour {
    switch (this) {
      case RadarrHealthCheckType.NOTICE:
        return HarbrColours.blue;
      case RadarrHealthCheckType.WARNING:
        return HarbrColours.orange;
      case RadarrHealthCheckType.ERROR:
        return HarbrColours.red;
      default:
        return Colors.white;
    }
  }
}
