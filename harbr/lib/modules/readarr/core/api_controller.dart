import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrAPIController {
  Future<bool> downloadRelease({
    required BuildContext context,
    required ReadarrRelease release,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return context
          .read<ReadarrState>()
          .api!
          .release
          .add(
            indexerId: release.indexerId!,
            guid: release.guid!,
          )
          .then((_) {
        if (showSnackbar) {
          showHarbrSuccessSnackBar(
            title: 'readarr.DownloadingRelease'.tr(),
            message: release.title.uiSafe(),
          );
        }
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to download release (${release.guid})',
          error,
          stack,
        );
        if (showSnackbar) {
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToDownloadRelease'.tr(),
            error: error,
          );
        }
        return false;
      });
    }
    return false;
  }

  Future<bool> toggleAuthorMonitored({
    required BuildContext context,
    required ReadarrAuthor author,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      ReadarrAuthor authorCopy = author.clone();
      authorCopy.monitored = !author.monitored!;
      return await context
          .read<ReadarrState>()
          .api!
          .author
          .update(author: authorCopy)
          .then((data) async {
        return await context
            .read<ReadarrState>()
            .setSingleAuthor(authorCopy)
            .then((_) {
          if (showSnackbar) {
            showHarbrSuccessSnackBar(
              title: authorCopy.monitored!
                  ? 'readarr.Monitoring'.tr()
                  : 'readarr.NoLongerMonitoring'.tr(),
              message: authorCopy.authorName,
            );
          }
          return true;
        });
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Unable to toggle monitored state: ${author.monitored.toString()} to ${authorCopy.monitored.toString()}',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: author.monitored!
                ? 'readarr.FailedToUnmonitorAuthor'.tr()
                : 'readarr.FailedToMonitorAuthor'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> updateAuthor({
    required BuildContext context,
    required ReadarrAuthor author,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .author
          .update(author: author)
          .then((_) async {
        return await context
            .read<ReadarrState>()
            .setSingleAuthor(author)
            .then((_) {
          if (showSnackbar) {
            showHarbrSuccessSnackBar(
              title: 'readarr.UpdatedAuthor'.tr(),
              message: author.authorName,
            );
          }
          return true;
        });
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to update author: ${author.id}',
          error,
          stack,
        );
        showHarbrErrorSnackBar(
          title: 'readarr.FailedToUpdateAuthor'.tr(),
          error: error,
        );
        return false;
      });
    }
    return true;
  }

  Future<bool> updateBook({
    required BuildContext context,
    required ReadarrBook book,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .book
          .update(book: book)
          .then((_) {
        if (showSnackbar) {
          showHarbrSuccessSnackBar(
            title: 'readarr.UpdatedBook'.tr(),
            message: book.title,
          );
        }
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to update book: ${book.id}',
          error,
          stack,
        );
        showHarbrErrorSnackBar(
          title: 'readarr.FailedToUpdateBook'.tr(),
          error: error,
        );
        return false;
      });
    }
    return true;
  }

  Future<bool> refreshAuthor({
    required BuildContext context,
    required ReadarrAuthor author,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .refreshAuthor(authorId: author.id!)
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'harbr.Refreshing'.tr(),
            message: author.authorName,
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Readarr: Unable to refresh author: ${author.id}',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToRefresh'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> authorSearch({
    required BuildContext context,
    required ReadarrAuthor author,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .authorSearch(authorId: author.id!)
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'readarr.SearchingForMonitoredBooks'.tr(),
            message: author.authorName!,
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to search for monitored books (${author.id})',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToSearchForMonitoredBooks'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> removeAuthor({
    required BuildContext context,
    required ReadarrAuthor author,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .author
          .delete(
            authorId: author.id!,
            deleteFiles: ReadarrDatabase.REMOVE_AUTHOR_DELETE_FILES.read(),
          )
          .then((_) async {
        return await context
            .read<ReadarrState>()
            .removeSingleAuthor(author.id!)
            .then((_) {
          if (showSnackbar)
            showHarbrSuccessSnackBar(
              title: ReadarrDatabase.REMOVE_AUTHOR_DELETE_FILES.read()
                  ? 'readarr.RemovedAuthorWithFiles'.tr()
                  : 'readarr.RemovedAuthor'.tr(),
              message: author.authorName,
            );
          return true;
        });
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to remove author: ${author.id}',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToRemoveAuthor'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> toggleBookMonitored({
    required BuildContext context,
    required ReadarrBook book,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      ReadarrBook bookCopy = book.clone();
      bookCopy.monitored = !book.monitored!;
      return await context
          .read<ReadarrState>()
          .api!
          .book
          .update(book: bookCopy)
          .then((_) {
        if (showSnackbar) {
          showHarbrSuccessSnackBar(
            title: bookCopy.monitored!
                ? 'readarr.Monitoring'.tr()
                : 'readarr.NoLongerMonitoring'.tr(),
            message: bookCopy.title,
          );
        }
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to toggle book monitored state (${book.id})',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: book.monitored!
                ? 'readarr.FailedToUnmonitorBook'.tr()
                : 'readarr.FailedToMonitorBook'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> removeBook({
    required BuildContext context,
    required ReadarrBook book,
    bool deleteFiles = false,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .book
          .delete(
            bookId: book.id!,
            deleteFiles: deleteFiles,
          )
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: deleteFiles
                ? 'readarr.RemovedBookWithFiles'.tr()
                : 'readarr.RemovedBook'.tr(),
            message: book.title,
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to remove book: ${book.id}',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToRemoveBook'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> bookSearch({
    required BuildContext context,
    required ReadarrBook book,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .bookSearch(bookId: book.id!)
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'readarr.SearchingForBook'.tr(),
            message: book.title,
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to search for book: ${book.id}',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToSearch'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> addTag({
    required BuildContext context,
    required String label,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .tag
          .create(label: label)
          .then((tag) {
        showHarbrSuccessSnackBar(
          title: 'readarr.AddedTag'.tr(),
          message: tag.label,
        );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error('Failed to add tag: $label', error, stack);
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToAddTag'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> backupDatabase({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .backup()
          .then((_) {
        if (showSnackbar) {
          showHarbrSuccessSnackBar(
            title:
                'readarr.BackingUpDatabase'.tr(args: [HarbrUI.TEXT_ELLIPSIS]),
            message: 'readarr.BackingUpDatabaseDescription'.tr(),
          );
        }
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Readarr: Unable to backup database',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToBackupDatabase'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> runRSSSync({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .rssSync()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'readarr.RunningRSSSync'.tr(args: [HarbrUI.TEXT_ELLIPSIS]),
            message: 'readarr.RunningRSSSyncDescription'.tr(),
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Unable to run RSS sync',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToRunRSSSync'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> updateLibrary({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .refreshAuthor()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title:
                'readarr.UpdatingLibrary'.tr(args: [HarbrUI.TEXT_ELLIPSIS]),
            message: 'readarr.UpdatingLibraryDescription'.tr(),
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Unable to update library',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToUpdateLibrary'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> missingBookSearch({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .missingBookSearch()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'readarr.Searching'.tr(args: [HarbrUI.TEXT_ELLIPSIS]),
            message: 'readarr.SearchingDescription'.tr(),
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Readarr: Unable to search for all missing books',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToSearch'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> rescanFolders({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return await context
          .read<ReadarrState>()
          .api!
          .command
          .rescanFolders()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title:
                'readarr.RescanningFolders'.tr(args: [HarbrUI.TEXT_ELLIPSIS]),
            message: 'readarr.RescanningFoldersDescription'.tr(),
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Readarr: Unable to rescan folders',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToRescanFolders'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  Future<bool> removeFromQueue({
    required BuildContext context,
    required ReadarrQueueRecord queueRecord,
    bool removeFromClient = false,
    bool blocklist = false,
    bool showSnackbar = true,
  }) async {
    if (context.read<ReadarrState>().enabled) {
      return context
          .read<ReadarrState>()
          .api!
          .queue
          .delete(
            id: queueRecord.id!,
            removeFromClient: removeFromClient,
            blocklist: blocklist,
          )
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'readarr.RemovedFromQueue'.tr(),
            message: queueRecord.title,
          );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error(
          'Failed to remove queue record: ${queueRecord.id}',
          error,
          stack,
        );
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'readarr.FailedToRemoveFromQueue'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }
}
