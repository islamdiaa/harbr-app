import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliAPIHelper {
  /// Backup Tautulli's configuration.
  Future<bool> backupConfiguration({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<TautulliState>().enabled) {
      return await context
          .read<TautulliState>()
          .api!
          .system
          .backupConfig()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'tautulli.BackingUpConfiguration'.tr(),
            message: 'tautulli.BackingUpConfigurationDescription'.tr(),
          );
        return true;
      }).catchError((error, trace) {
        HarbrLogger().error('Failed to backup configuration', error, trace);
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'tautulli.BackingUpConfigurationFailed'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  /// Backup Tautulli's database.
  Future<bool> backupDatabase({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<TautulliState>().enabled) {
      return await context
          .read<TautulliState>()
          .api!
          .system
          .backupDB()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'tautulli.BackingUpDatabase'.tr(),
            message: 'tautulli.BackingUpDatabaseDescription'.tr(),
          );
        return true;
      }).catchError((error, trace) {
        HarbrLogger().error('Failed to backup database', error, trace);
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'tautulli.BackingUpDatabaseFailed'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  /// Delete cache.
  Future<bool> deleteCache({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<TautulliState>().enabled) {
      return await context
          .read<TautulliState>()
          .api!
          .system
          .deleteCache()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'tautulli.DeletingCache'.tr(),
            message: 'tautulli.DeletingCacheDescription'.tr(),
          );
        return true;
      }).catchError((error, trace) {
        HarbrLogger().error('Failed to delete cache', error, trace);
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'tautulli.DeletingCacheFailed'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  /// Delete image cache.
  Future<bool> deleteImageCache({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<TautulliState>().enabled) {
      return await context
          .read<TautulliState>()
          .api!
          .system
          .deleteImageCache()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'tautulli.DeletingImageCache'.tr(),
            message: 'tautulli.DeletingImageCacheDescription'.tr(),
          );
        return true;
      }).catchError((error, trace) {
        HarbrLogger().error('Failed to delete image cache', error, trace);
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'tautulli.DeletingImageCacheFailed'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  /// Delete temporary sessions.
  Future<bool> deleteTemporarySessions({
    required BuildContext context,
    bool showSnackbar = true,
  }) async {
    if (context.read<TautulliState>().enabled) {
      return await context
          .read<TautulliState>()
          .api!
          .activity
          .deleteTempSessions()
          .then((_) {
        if (showSnackbar)
          showHarbrSuccessSnackBar(
            title: 'tautulli.DeletingTemporarySessions'.tr(),
            message: 'tautulli.DeletingTemporarySessionsDescription'.tr(),
          );
        return true;
      }).catchError((error, trace) {
        HarbrLogger().error('Failed to delete temporary sessions', error, trace);
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'tautulli.DeletingTemporarySessionsFailed'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }

  /// Terminate an active session.
  Future<bool> terminateSession({
    required BuildContext context,
    required TautulliSession session,
    String? terminationMessage,
    bool showSnackbar = true,
  }) async {
    if (context.read<TautulliState>().enabled) {
      return await context
          .read<TautulliState>()
          .api!
          .activity
          .terminateSession(
            sessionKey: session.sessionKey,
            message: terminationMessage,
          )
          .then((_) {
        showHarbrSuccessSnackBar(
          title: 'tautulli.TerminatedSession'.tr(),
          message: [
            session.friendlyName,
            session.title,
          ].join(HarbrUI.TEXT_EMDASH.pad()),
        );
        return true;
      }).catchError((error, stack) {
        HarbrLogger().error('Failed to delete temporary sessions', error, stack);
        if (showSnackbar)
          showHarbrErrorSnackBar(
            title: 'tautulli.TerminateSessionFailed'.tr(),
            error: error,
          );
        return false;
      });
    }
    return false;
  }
}
