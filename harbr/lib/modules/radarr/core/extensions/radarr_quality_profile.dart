import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';

extension RadarrQualityProfileExtension on RadarrQualityProfile {
  String? get harbrName {
    if (this.name != null && this.name!.isNotEmpty) return this.name;
    return HarbrUI.TEXT_EMDASH;
  }
}
