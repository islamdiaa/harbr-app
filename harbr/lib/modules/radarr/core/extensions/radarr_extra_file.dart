import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrExtraFileExtension on RadarrExtraFile {
  String get harbrRelativePath {
    if (this.relativePath?.isNotEmpty ?? false) return this.relativePath!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrExtension {
    if (this.extension?.isNotEmpty ?? false) return this.extension!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrType {
    if (this.type?.isNotEmpty ?? false) return this.type!.toTitleCase();
    return HarbrUI.TEXT_EMDASH;
  }
}
