import 'package:harbr/database/table.dart';
import 'package:harbr/vendor.dart';

enum ReadarrDatabase<T> with HarbrTableMixin<T> {
  NAVIGATION_INDEX<int>(0),
  ADD_BOOK_DEFAULT_MONITORED<bool>(true),
  ADD_BOOK_DEFAULT_QUALITY_PROFILE<int?>(null),
  ADD_BOOK_DEFAULT_METADATA_PROFILE<int?>(null),
  ADD_BOOK_DEFAULT_ROOT_FOLDER<int?>(null),
  ADD_BOOK_DEFAULT_TAGS<List>([]),
  ADD_BOOK_SEARCH_FOR_MISSING<bool>(false),
  REMOVE_AUTHOR_DELETE_FILES<bool>(false),
  CONTENT_PAGE_SIZE<int>(10),
  QUEUE_PAGE_SIZE<int>(50),
  QUEUE_REFRESH_RATE<int>(15),
  QUEUE_REMOVE_FROM_CLIENT<bool>(false),
  QUEUE_BLOCKLIST<bool>(false),
  UPCOMING_FUTURE_DAYS<int>(7);

  @override
  HarbrTable get table => HarbrTable.readarr;

  @override
  final T fallback;
  const ReadarrDatabase(this.fallback);

  @override
  void register() {
    // Hive adapters for filter/sorting types will be registered later
    // when those types are created
  }
}
