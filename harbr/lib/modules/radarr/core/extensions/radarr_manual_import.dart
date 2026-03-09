import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrManualImportExtension on RadarrManualImport {
  String? get harbrLanguage {
    if ((this.languages?.length ?? 0) > 1) return 'Multi-Language';
    if ((this.languages?.length ?? 0) == 1) return this.languages![0].name;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrQualityProfile {
    return this.quality?.quality?.name ?? HarbrUI.TEXT_EMDASH;
  }

  String get harbrSize {
    return this.size.asBytes();
  }

  String get harbrMovie {
    if (this.movie == null) return HarbrUI.TEXT_EMDASH;
    String title = this.movie!.title ?? HarbrUI.TEXT_EMDASH;
    int? year = (this.movie!.year ?? 0) == 0 ? null : this.movie!.year;
    return [
      title,
      if (year != null) '($year)',
    ].join(' ');
  }
}
