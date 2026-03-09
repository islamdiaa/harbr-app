import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/utils/profile_tools.dart';

class ProfilesRoute extends StatefulWidget {
  const ProfilesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilesRoute> createState() => _State();
}

class _State extends State<ProfilesRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'settings.Profiles'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        SettingsBanners.PROFILES_SUPPORT.banner(),
        _enabledProfile(),
        _addProfile(),
        _renameProfile(),
        _deleteProfile(),
      ],
    );
  }

  Widget _addProfile() {
    return HarbrBlock(
      title: 'settings.AddProfile'.tr(),
      body: [TextSpan(text: 'settings.AddProfileDescription'.tr())],
      trailing: const HarbrIconButton(icon: HarbrIcons.ADD),
      onTap: () async {
        final dialogs = SettingsDialogs();
        final context = HarbrState.context;
        final profiles = HarbrProfile.list;

        final selected = await dialogs.addProfile(context, profiles);
        if (selected.item1) {
          HarbrProfileTools().create(selected.item2);
        }
      },
    );
  }

  Widget _renameProfile() {
    return HarbrBlock(
      title: 'settings.RenameProfile'.tr(),
      body: [TextSpan(text: 'settings.RenameProfileDescription'.tr())],
      trailing: const HarbrIconButton(icon: HarbrIcons.RENAME),
      onTap: () async {
        final dialogs = SettingsDialogs();
        final context = HarbrState.context;
        final profiles = HarbrProfile.list;

        final selected = await dialogs.renameProfile(context, profiles);
        if (selected.item1) {
          final name = await dialogs.renameProfileSelected(context, profiles);
          if (name.item1) {
            HarbrProfileTools().rename(selected.item2, name.item2);
          }
        }
      },
    );
  }

  Widget _deleteProfile() {
    return HarbrBlock(
        title: 'settings.DeleteProfile'.tr(),
        body: [TextSpan(text: 'settings.DeleteProfileDescription'.tr())],
        trailing: const HarbrIconButton(icon: HarbrIcons.DELETE),
        onTap: () async {
          final dialogs = SettingsDialogs();
          final enabledProfile = HarbrDatabase.ENABLED_PROFILE.read();
          final context = HarbrState.context;
          final profiles = HarbrProfile.list;
          profiles.removeWhere((p) => p == enabledProfile);

          if (profiles.isEmpty) {
            showHarbrInfoSnackBar(
              title: 'settings.NoProfilesFound'.tr(),
              message: 'settings.NoAdditionalProfilesAdded'.tr(),
            );
            return;
          }

          final selected = await dialogs.deleteProfile(context, profiles);
          if (selected.item1) {
            HarbrProfileTools().remove(selected.item2);
          }
        });
  }

  Widget _enabledProfile() {
    const db = HarbrDatabase.ENABLED_PROFILE;
    return db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.EnabledProfile'.tr(),
        body: [TextSpan(text: db.read())],
        trailing: const HarbrIconButton(icon: HarbrIcons.USER),
        onTap: () async {
          final dialogs = SettingsDialogs();
          final enabledProfile = HarbrDatabase.ENABLED_PROFILE.read();
          final context = HarbrState.context;
          final profiles = HarbrProfile.list;
          profiles.removeWhere((p) => p == enabledProfile);

          if (profiles.isEmpty) {
            showHarbrInfoSnackBar(
              title: 'settings.NoProfilesFound'.tr(),
              message: 'settings.NoAdditionalProfilesAdded'.tr(),
            );
            return;
          }

          final selected = await dialogs.enabledProfile(context, profiles);
          if (selected.item1) {
            HarbrProfileTools().changeTo(selected.item2);
          }
        },
      ),
    );
  }
}
