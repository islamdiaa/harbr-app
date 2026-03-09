import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/datetime.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/int/duration.dart';
import 'package:harbr/modules/radarr.dart';

extension HarbrRadarrMovieExtension on RadarrMovie {
  String get harbrRuntime {
    return this.runtime.asVideoDuration();
  }

  String get harbrAlternateTitles {
    if (this.alternateTitles?.isNotEmpty ?? false) {
      return this.alternateTitles!.map((title) => title.title).join('\n');
    }
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrGenres {
    if (this.genres?.isNotEmpty ?? false) return this.genres!.join('\n');
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrStudio {
    if (this.studio?.isNotEmpty ?? false) return this.studio!;
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrYear {
    if (this.year != null && this.year != 0) return this.year.toString();
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrMinimumAvailability {
    if (this.minimumAvailability != null) {
      return this.minimumAvailability!.readable;
    }
    return HarbrUI.TEXT_EMDASH;
  }

  String harbrDateAdded([bool short = false]) {
    if (this.added != null) return this.added!.asDateOnly(shortenMonth: short);
    return HarbrUI.TEXT_EMDASH;
  }

  bool get harbrIsInCinemas {
    if (this.inCinemas != null)
      return this.inCinemas!.toLocal().isBefore(DateTime.now());
    return false;
  }

  String harbrInCinemasOn([bool short = false]) {
    if (this.inCinemas != null)
      return this.inCinemas!.asDateOnly(shortenMonth: short);
    return HarbrUI.TEXT_EMDASH;
  }

  String harbrPhysicalReleaseDate([bool short = false]) {
    if (this.physicalRelease != null)
      return this.physicalRelease!.asDateOnly(shortenMonth: short);
    return HarbrUI.TEXT_EMDASH;
  }

  String harbrDigitalReleaseDate([bool short = false]) {
    if (this.digitalRelease != null)
      return this.digitalRelease!.asDateOnly(shortenMonth: short);
    return HarbrUI.TEXT_EMDASH;
  }

  String get harbrReleaseDate {
    if (this.harbrEarlierReleaseDate != null)
      return this.harbrEarlierReleaseDate!.asDateOnly();
    return HarbrUI.TEXT_EMDASH;
  }

  String harbrTags(List<RadarrTag> tags) {
    if (tags.isNotEmpty) return tags.map<String?>((t) => t.label).join('\n');
    return HarbrUI.TEXT_EMDASH;
  }

  bool get harbrIsReleased {
    if (this.status == RadarrAvailability.RELEASED) return true;
    if (this.digitalRelease != null)
      return this.digitalRelease!.toLocal().isBefore(DateTime.now());
    if (this.physicalRelease != null)
      return this.physicalRelease!.toLocal().isBefore(DateTime.now());
    return false;
  }

  String get harbrFileSize {
    if (!this.hasFile!) return HarbrUI.TEXT_EMDASH;
    return this.sizeOnDisk.asBytes();
  }

  Text harbrHasFileTextObject() {
    if (this.hasFile!)
      return Text(
        harbrFileSize,
        style: const TextStyle(
          color: HarbrColours.accent,
          fontSize: HarbrUI.FONT_SIZE_H3,
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        ),
      );
    return const Text(
      '',
      style: TextStyle(
        fontSize: HarbrUI.FONT_SIZE_H3,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
    );
  }

  Text harbrNextReleaseTextObject() {
    DateTime now = DateTime.now();
    // If we already have a file or it is released
    if (this.hasFile! || harbrIsReleased)
      return const Text(
        '',
        style: TextStyle(fontSize: HarbrUI.FONT_SIZE_H3),
      );
    // In Cinemas
    if (this.inCinemas != null && this.inCinemas!.toLocal().isAfter(now)) {
      String _date = this.inCinemas!.asDaysDifference().toUpperCase();
      return Text(
        _date == 'TODAY' ? _date : 'IN $_date',
        style: const TextStyle(
          color: HarbrColours.orange,
          fontSize: HarbrUI.FONT_SIZE_H3,
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        ),
      );
    }
    DateTime? _release = harbrEarlierReleaseDate;
    // Releases
    if (_release != null) {
      String _date = _release.asDaysDifference().toUpperCase();
      return Text(
        _date == 'TODAY' ? _date : 'IN $_date',
        style: const TextStyle(
          color: HarbrColours.blue,
          fontSize: HarbrUI.FONT_SIZE_H3,
          fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
        ),
      );
    }
    // Unknown case
    return const Text(
      '',
      style: TextStyle(
        fontSize: HarbrUI.FONT_SIZE_H3,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
    );
  }

  /// Compare two movies by their release dates. Returns an integer value compatible with `.sort()` in arrays.
  ///
  /// Compares and uses the earlier date between `physicalRelease` and `digitalRelease`.
  int harbrCompareToByReleaseDate(RadarrMovie movie) {
    if (this.physicalRelease == null &&
        this.digitalRelease == null &&
        movie.physicalRelease == null &&
        movie.digitalRelease == null)
      return this
          .sortTitle!
          .toLowerCase()
          .compareTo(movie.sortTitle!.toLowerCase());
    if (this.physicalRelease == null && this.digitalRelease == null) return 1;
    if (movie.physicalRelease == null && movie.digitalRelease == null)
      return -1;
    DateTime a = (this.physicalRelease ?? DateTime(9999))
            .isBefore((this.digitalRelease ?? DateTime(9999)))
        ? this.physicalRelease!
        : this.digitalRelease!;
    DateTime b = (movie.physicalRelease ?? DateTime(9999))
            .isBefore((movie.digitalRelease ?? DateTime(9999)))
        ? movie.physicalRelease!
        : movie.digitalRelease!;
    int comparison = a.compareTo(b);
    if (comparison == 0)
      comparison = this
          .sortTitle!
          .toLowerCase()
          .compareTo(movie.sortTitle!.toLowerCase());
    return comparison;
  }

  /// Compare two movies by their cinema release date. Returns an integer value compatible with `.sort()` in arrays.
  int harbrCompareToByInCinemas(RadarrMovie movie) {
    if (this.inCinemas == null && movie.inCinemas == null)
      return this
          .sortTitle!
          .toLowerCase()
          .compareTo(movie.sortTitle!.toLowerCase());
    if (this.inCinemas == null) return 1;
    if (movie.inCinemas == null) return -1;
    int comparison = this.inCinemas!.compareTo(movie.inCinemas!);
    if (comparison == 0)
      comparison = this
          .sortTitle!
          .toLowerCase()
          .compareTo(movie.sortTitle!.toLowerCase());
    return comparison;
  }

  /// Compares the digital and physical release dates and returns the earlier date.
  ///
  /// If both are null, returns null.
  DateTime? get harbrEarlierReleaseDate {
    if (this.physicalRelease == null && this.digitalRelease == null)
      return null;
    if (this.physicalRelease == null) return this.digitalRelease;
    if (this.digitalRelease == null) return this.physicalRelease;
    return this.digitalRelease!.isBefore(this.physicalRelease!)
        ? this.digitalRelease
        : this.physicalRelease;
  }

  /// Creates a clone of the [RadarrMovie] object (deep copy).
  RadarrMovie clone() => RadarrMovie.fromJson(this.toJson());

  /// Copies changes from a [RadarrMoviesEditState] state object into a new [RadarrMovie] object.
  RadarrMovie updateEdits(RadarrMoviesEditState edits) {
    RadarrMovie movie = this.clone();
    movie.monitored = edits.monitored;
    movie.minimumAvailability = edits.availability;
    movie.qualityProfileId = edits.qualityProfile.id ?? this.qualityProfileId;
    movie.path = edits.path;
    movie.tags = edits.tags.map((t) => t.id).toList();
    return movie;
  }
}
