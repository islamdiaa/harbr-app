import 'package:harbr/core.dart';
import 'package:harbr/extensions/duration/timestamp.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/radarr.dart';

extension RadarrSystemStatusExtension on RadarrSystemStatus {
  String get harbrVersion {
    if (this.version != null && this.version!.isNotEmpty) return this.version!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrPackageVersion {
    String? packageAuthor, packageVersion;
    if (this.packageVersion != null && this.packageVersion!.isNotEmpty)
      packageVersion = this.packageVersion;
    if (this.packageAuthor != null && this.packageAuthor!.isNotEmpty)
      packageAuthor = this.packageAuthor;
    return '${packageVersion ?? HarbrUI.TEXT_EMDASH} by ${packageAuthor ?? HarbrUI.TEXT_EMDASH}';
  }

  String get harbrNetCore {
    if (this.isNetCore ?? false)
      return 'Yes (${this.runtimeVersion ?? HarbrUI.TEXT_EMDASH})';
    return 'No';
  }

  bool get harbrIsDocker {
    return this.isDocker ?? false;
  }

  String get harbrDBMigration {
    if (this.migrationVersion != null) return '${this.migrationVersion}';
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrAppDataDirectory {
    if (this.appData != null && this.appData!.isNotEmpty) return this.appData!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrStartupDirectory {
    if (this.startupPath != null && this.startupPath!.isNotEmpty)
      return this.startupPath!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrMode {
    if (this.mode != null && this.mode!.isNotEmpty)
      return this.mode!.toTitleCase();
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrUptime {
    if (this.startTime != null && this.startTime!.isNotEmpty) {
      DateTime? _start = DateTime.tryParse(this.startTime!);
      if (_start != null)
        return DateTime.now().difference(_start).asWordsTimestamp();
    }
    return HarbrUI.TEXT_EMDASH;
  }
}
