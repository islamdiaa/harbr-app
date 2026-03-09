import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrRootFolderExtension on RadarrRootFolder? {
  String get harbrPath {
    if (this?.path?.isNotEmpty ?? false) return this!.path!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrSpace {
    return this?.freeSpace.asBytes() ?? HarbrUI.TEXT_EMDASH;
  }

  String get harbrUnmappedFolders {
    int length = this?.unmappedFolders?.length ?? 0;
    if (this!.unmappedFolders!.length == 1) return 'radarr.UnmappedFolder'.tr();
    return 'radarr.UnmappedFolders'.tr(args: [length.toString()]);
  }
}
