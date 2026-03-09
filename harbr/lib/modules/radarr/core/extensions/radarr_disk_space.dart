import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrDiskSpaceExtension on RadarrDiskSpace {
  String? get harbrPath {
    if (this.path != null && this.path!.isNotEmpty) return this.path;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrSpace {
    String numerator = this.freeSpace.asBytes();
    String denumerator = this.totalSpace.asBytes();
    return '$numerator / $denumerator\n';
  }

  int get harbrPercentage {
    int? _percentNumerator = this.freeSpace;
    int? _percentDenominator = this.totalSpace;
    if (_percentNumerator != null &&
        _percentDenominator != null &&
        _percentDenominator != 0) {
      int _val = ((_percentNumerator / _percentDenominator) * 100).round();
      return (_val - 100).abs();
    }
    return 0;
  }

  String get harbrPercentageString => '$harbrPercentage%';

  Color get harbrColor {
    int percentage = this.harbrPercentage;
    if (percentage >= 90) return HarbrColours.red;
    if (percentage >= 80) return HarbrColours.orange;
    return HarbrColours.accent;
  }
}
