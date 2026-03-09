library readarr_commands;

import 'package:harbr/api/readarr/models.dart';
import 'package:harbr/api/readarr/types.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

// Author
part 'controllers/author.dart';
part 'controllers/author/get_all_authors.dart';
part 'controllers/author/get_author.dart';
part 'controllers/author/add_author.dart';
part 'controllers/author/update_author.dart';
part 'controllers/author/delete_author.dart';
part 'controllers/author/lookup_author.dart';

// Book
part 'controllers/book.dart';
part 'controllers/book/get_all_books.dart';
part 'controllers/book/get_book.dart';
part 'controllers/book/add_book.dart';
part 'controllers/book/update_book.dart';
part 'controllers/book/delete_book.dart';

// Book Lookup
part 'controllers/book_lookup.dart';
part 'controllers/book_lookup/lookup.dart';

// Command
part 'controllers/command.dart';
part 'controllers/command/backup.dart';
part 'controllers/command/author_search.dart';
part 'controllers/command/book_search.dart';
part 'controllers/command/missing_book_search.dart';
part 'controllers/command/refresh_author.dart';
part 'controllers/command/refresh_monitored_downloads.dart';
part 'controllers/command/rescan_folders.dart';
part 'controllers/command/rss_sync.dart';

// History
part 'controllers/history.dart';
part 'controllers/history/get_history.dart';
part 'controllers/history/get_history_by_author.dart';
part 'controllers/history/get_history_by_book.dart';

// Metadata Profile
part 'controllers/metadata_profile.dart';
part 'controllers/metadata_profile/get_metadata_profiles.dart';

// Quality Profile
part 'controllers/profile.dart';
part 'controllers/profile/get_quality_profiles.dart';

// Queue
part 'controllers/queue.dart';
part 'controllers/queue/get_queue.dart';
part 'controllers/queue/delete_queue.dart';

// Release
part 'controllers/release.dart';
part 'controllers/release/get_release.dart';
part 'controllers/release/add_release.dart';

// Root Folder
part 'controllers/root_folder.dart';
part 'controllers/root_folder/get_root_folders.dart';

// System
part 'controllers/system.dart';
part 'controllers/system/get_status.dart';

// Tag
part 'controllers/tag.dart';
part 'controllers/tag/get_all_tags.dart';
part 'controllers/tag/get_tag.dart';
part 'controllers/tag/add_tag.dart';
part 'controllers/tag/delete_tag.dart';
part 'controllers/tag/update_tag.dart';

// Wanted
part 'controllers/wanted.dart';
part 'controllers/wanted/get_missing.dart';
