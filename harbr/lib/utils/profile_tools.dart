import 'package:harbr/database/models/profile.dart';
import 'package:harbr/database/box.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/system/state.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/system/logger.dart';
import 'package:harbr/types/exception.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

class HarbrProfileTools {
  bool changeTo(
    String profile, {
    bool showSnackbar = true,
    bool popToRootRoute = false,
  }) {
    try {
      if (HarbrDatabase.ENABLED_PROFILE.read() == profile) return true;
      _changeTo(profile);

      if (showSnackbar) {
        showHarbrSuccessSnackBar(
          title: 'settings.ChangedProfile'.tr(),
          message: profile,
        );
      }

      if (popToRootRoute) {
        HarbrRouter().popToRootRoute();
      }

      return true;
    } on ProfileNotFoundException catch (error, trace) {
      HarbrLogger().exception(error, trace);
    }
    return false;
  }

  Future<bool> create(
    String profile, {
    bool showSnackbar = true,
  }) async {
    try {
      await _create(profile);
      _changeTo(profile);

      if (showSnackbar) {
        showHarbrSuccessSnackBar(
          title: 'settings.AddedProfile'.tr(),
          message: profile,
        );
      }
    } on ProfileAlreadyExistsException catch (error, trace) {
      HarbrLogger().exception(error, trace);
    } catch (error, trace) {
      HarbrLogger().error('Failed to create profile', error, trace);
    }

    return false;
  }

  Future<bool> remove(
    String profile, {
    bool showSnackbar = true,
  }) async {
    try {
      await _remove(profile);

      if (showSnackbar) {
        showHarbrSuccessSnackBar(
          title: 'settings.DeletedProfile'.tr(),
          message: profile,
        );
      }
    } on ProfileNotFoundException catch (error, trace) {
      HarbrLogger().exception(error, trace);
    } on ActiveProfileRemovalException catch (error, trace) {
      HarbrLogger().exception(error, trace);
    } catch (error, trace) {
      HarbrLogger().error('Failed to delete profile', error, trace);
    }

    return false;
  }

  Future<bool> rename(
    String oldProfile,
    String newProfile, {
    bool showSnackbar = true,
  }) async {
    try {
      await _rename(oldProfile, newProfile);

      if (showSnackbar) {
        showHarbrSuccessSnackBar(
          title: 'settings.RenamedProfile'.tr(),
          message: 'settings.ProfileToProfile'.tr(
            args: [oldProfile, newProfile],
          ),
        );
      }

      return true;
    } on ProfileNotFoundException catch (error, trace) {
      HarbrLogger().exception(error, trace);
    } on ProfileAlreadyExistsException catch (error, trace) {
      HarbrLogger().exception(error, trace);
    } catch (error, trace) {
      HarbrLogger().error('Failed to rename profile', error, trace);
    }

    return false;
  }

  void _changeTo(String profile) {
    if (!HarbrBox.profiles.contains(profile)) {
      throw ProfileNotFoundException(profile);
    }

    HarbrDatabase.ENABLED_PROFILE.update(profile);
    HarbrState.reset();
  }

  Future<void> _create(String profile) async {
    if (HarbrBox.profiles.contains(profile)) {
      throw ProfileAlreadyExistsException(profile);
    }

    await HarbrBox.profiles.update(profile, HarbrProfile());
  }

  Future<void> _remove(String profile) async {
    if (HarbrDatabase.ENABLED_PROFILE.read() == profile) {
      throw ActiveProfileRemovalException(profile);
    }

    if (!HarbrBox.profiles.contains(profile)) {
      throw ProfileNotFoundException(profile);
    }

    await HarbrBox.profiles.delete(profile);
  }

  Future<void> _rename(String oldProfile, String newProfile) async {
    if (!HarbrBox.profiles.contains(oldProfile)) {
      throw ProfileNotFoundException(oldProfile);
    }

    if (HarbrBox.profiles.contains(newProfile)) {
      throw ProfileAlreadyExistsException(newProfile);
    }

    final oldDb = HarbrBox.profiles.read(oldProfile)!;
    final newDb = HarbrProfile.clone(oldDb);

    await HarbrBox.profiles.update(newProfile, newDb);
    _changeTo(newProfile);

    oldDb.delete();
  }
}

class ProfileNotFoundException with ErrorExceptionMixin {
  final String profile;
  const ProfileNotFoundException(this.profile);

  @override
  String toString() {
    return 'ProfileNotFoundException: "$profile" was not found';
  }
}

class ProfileAlreadyExistsException with ErrorExceptionMixin {
  final String profile;
  const ProfileAlreadyExistsException(this.profile);

  @override
  String toString() {
    return 'ProfileAlreadyExistsException: "$profile" already exists';
  }
}

class ActiveProfileRemovalException with ErrorExceptionMixin {
  final String profile;
  const ActiveProfileRemovalException(this.profile);

  @override
  String toString() {
    return 'ActiveProfileRemovalException: "$profile" can\'t be removed as it is in use';
  }
}
