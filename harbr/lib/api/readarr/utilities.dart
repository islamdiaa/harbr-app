library readarr_utilities;

import 'package:harbr/api/readarr/types.dart';

class ReadarrUtilities {
  ReadarrUtilities._();

  static DateTime? dateTimeFromJson(String? date) => DateTime.tryParse(date ?? '');
  static String? dateTimeToJson(DateTime? date) => date?.toIso8601String();

  static ReadarrEventType? eventTypeFromJson(String? type) => ReadarrEventType.GRABBED.from(type);
  static String? eventTypeToJson(ReadarrEventType? type) => type?.value;

  static ReadarrHistorySortKey? historySortKeyFromJson(String? key) => ReadarrHistorySortKey.DATE.from(key);
  static String? historySortKeyToJson(ReadarrHistorySortKey? key) => key?.value;

  static ReadarrWantedMissingSortKey? wantedMissingSortKeyFromJson(String? key) => ReadarrWantedMissingSortKey.TITLE.from(key);
  static String? wantedMissingSortKeyToJson(ReadarrWantedMissingSortKey? key) => key?.value;
}
