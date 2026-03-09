import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrMovieFileExtension on RadarrMovieFile {
  String get harbrRelativePath {
    if (this.relativePath?.isNotEmpty ?? false) return this.relativePath!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrSize {
    if ((this.size ?? 0) != 0) return this.size.asBytes(decimals: 1);
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrLanguage {
    if (this.languages?.isEmpty ?? true) return HarbrUI.TEXT_EMDASH;
    return this.languages!.map<String?>((lang) => lang.name).join('\n');
  }

  String get harbrQuality {
    if (this.quality?.quality?.name != null)
      return this.quality!.quality!.name!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrDateAdded {
    if (this.dateAdded != null)
      return this.dateAdded!.asDateTime(delimiter: '\n');
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrCustomFormats {
    if (this.customFormats != null && this.customFormats!.isNotEmpty)
      return this
          .customFormats!
          .map<String?>((format) => format.name)
          .join('\n');
    return HarbrUI.TEXT_EMDASH;
  }
}
