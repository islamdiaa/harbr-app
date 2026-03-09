import 'package:flutter/material.dart';
import 'package:harbr/system/environment.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

const FLAVOR_EDGE = 'edge';
const FLAVOR_BETA = 'beta';
const FLAVOR_STABLE = 'stable';

enum HarbrFlavor {
  EDGE(FLAVOR_EDGE),
  BETA(FLAVOR_BETA),
  STABLE(FLAVOR_STABLE);

  final String key;
  const HarbrFlavor(this.key);

  static HarbrFlavor fromKey(String key) {
    switch (key) {
      case FLAVOR_EDGE:
        return HarbrFlavor.EDGE;
      case FLAVOR_BETA:
        return HarbrFlavor.BETA;
      case FLAVOR_STABLE:
        return HarbrFlavor.STABLE;
    }
    throw Exception('Invalid HarbrFlavor');
  }

  static HarbrFlavor get current => HarbrFlavor.fromKey(HarbrEnvironment.flavor);

  static bool get isEdge => current == HarbrFlavor.EDGE;
  static bool get isBeta => current == HarbrFlavor.BETA;
  static bool get isStable => current == HarbrFlavor.STABLE;
}

extension HarbrFlavorExtension on HarbrFlavor {
  bool isRunningFlavor() {
    HarbrFlavor flavor = HarbrFlavor.current;
    if (flavor == this) return true;

    switch (this) {
      case HarbrFlavor.EDGE:
        return false;
      case HarbrFlavor.BETA:
        return flavor == HarbrFlavor.EDGE;
      case HarbrFlavor.STABLE:
        return true;
    }
  }

  String get downloadLink {
    String base = 'https://builds.harbr.app/#latest';
    switch (this) {
      case HarbrFlavor.EDGE:
        return '$base/${this.key}/';
      case HarbrFlavor.BETA:
        return '$base/${this.key}/';
      case HarbrFlavor.STABLE:
        return '$base/${this.key}/';
    }
  }

  String get name {
    switch (this) {
      case HarbrFlavor.EDGE:
        return 'harbr.Edge'.tr();
      case HarbrFlavor.BETA:
        return 'harbr.Beta'.tr();
      case HarbrFlavor.STABLE:
        return 'harbr.Stable'.tr();
    }
  }

  Color get color {
    switch (this) {
      case HarbrFlavor.EDGE:
        return HarbrColours.red;
      case HarbrFlavor.BETA:
        return HarbrColours.blue;
      case HarbrFlavor.STABLE:
        return HarbrColours.accent;
    }
  }
}
