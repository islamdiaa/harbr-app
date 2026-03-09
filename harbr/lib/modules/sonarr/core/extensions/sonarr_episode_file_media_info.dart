import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/sonarr.dart';

extension SonarrEpisodeFileMediaInfoExtension on SonarrEpisodeFileMediaInfo {
  String get harbrVideoBitDepth {
    if (videoBitDepth != null) return videoBitDepth.toString();
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrVideoBitrate {
    if (videoBitrate != null) return '${videoBitrate.asBits()}/s';
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrVideoCodec {
    if (videoCodec != null && videoCodec!.isNotEmpty) return videoCodec;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrVideoFps {
    if (videoFps != null) return videoFps.toString();
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrVideoResolution {
    if (resolution != null && resolution!.isNotEmpty) return resolution;
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrVideoScanType {
    if (scanType != null && scanType!.isNotEmpty) return scanType;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrAudioBitrate {
    if (audioBitrate != null) return '${audioBitrate.asBits()}/s';
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrAudioChannels {
    if (audioChannels != null) return audioChannels.toString();
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrAudioCodec {
    if (audioCodec != null && audioCodec!.isNotEmpty) return audioCodec;
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrAudioLanguages {
    if (audioLanguages != null && audioLanguages!.isNotEmpty)
      return audioLanguages;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrAudioStreamCount {
    if (audioStreamCount != null) return audioStreamCount.toString();
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrRunTime {
    if (runTime != null && runTime!.isNotEmpty) return runTime;
    return HarbrUI.TEXT_EMDASH;
  }

  String? get harbrSubtitles {
    if (subtitles != null && subtitles!.isNotEmpty) return subtitles;
    return HarbrUI.TEXT_EMDASH;
  }
}
