import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

extension TautulliTableLibraryExtension on TautulliTableLibrary {
  String get readableCount {
    switch (this.sectionType) {
      case TautulliSectionType.MOVIE:
        return this.count == 1 ? '1 Movie' : '${this.count} Movies';
      case TautulliSectionType.SHOW:
        String _shows = this.count == 1 ? '1 Shows' : '${this.count} Shows';
        String _seasons =
            this.parentCount == 1 ? '1 Season' : '${this.parentCount} Seasons';
        String _episodes =
            this.childCount == 1 ? '1 Episode' : '${this.childCount} Episodes';
        return '$_shows ${HarbrUI.TEXT_BULLET} $_seasons ${HarbrUI.TEXT_BULLET} $_episodes';
      case TautulliSectionType.ARTIST:
        String _artists =
            this.count == 1 ? '1 Artist' : '${this.count} Artists';
        String _albums =
            this.parentCount == 1 ? '1 Album' : '${this.parentCount} Albums';
        String _tracks =
            this.childCount == 1 ? '1 Track' : '${this.childCount} Tracks';
        return '$_artists ${HarbrUI.TEXT_BULLET} $_albums ${HarbrUI.TEXT_BULLET} $_tracks';
      case TautulliSectionType.PHOTO:
        return this.count == 1 ? '${this.count} Photo' : '${this.count} Photos';
      case TautulliSectionType.NULL:
      default:
        return 'Unknown';
    }
  }
}
