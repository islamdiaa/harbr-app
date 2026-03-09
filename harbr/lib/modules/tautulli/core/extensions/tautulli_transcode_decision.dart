import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

extension HarbrTautulliTranscodeDecisionExtension on TautulliTranscodeDecision? {
  String get localizedName {
    switch (this) {
      case TautulliTranscodeDecision.TRANSCODE:
        return 'tautulli.Transcode'.tr();
      case TautulliTranscodeDecision.COPY:
        return 'tautulli.DirectStream'.tr();
      case TautulliTranscodeDecision.DIRECT_PLAY:
        return 'tautulli.DirectPlay'.tr();
      case TautulliTranscodeDecision.BURN:
        return 'tautulli.Burn'.tr();
      case TautulliTranscodeDecision.NULL:
      default:
        return 'tautulli.None'.tr();
    }
  }
}
