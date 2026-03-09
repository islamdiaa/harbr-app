import 'package:flutter/material.dart';

import 'package:wake_on_lan/wake_on_lan.dart';
import 'package:harbr/database/tables/harbr.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_day.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_size.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_type.dart';
import 'package:harbr/modules/settings/core/types/header.dart';
import 'package:harbr/system/state.dart';
import 'package:harbr/utils/validator.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

class SettingsDialogs {
  Future<Tuple2<bool, int>> setDefaultOption(
    BuildContext context, {
    required String title,
    required List<String?> values,
    required List<IconData> icons,
  }) async {
    bool _flag = false;
    int _index = 0;

    void _setValues(bool flag, int index) {
      _flag = flag;
      _index = index;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: title,
      content: List.generate(
        values.length,
        (index) => HarbrDialog.tile(
          text: values[index]!,
          icon: icons[index],
          iconColor: HarbrColours().byListIndex(index),
          onTap: () => _setValues(true, index),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );

    return Tuple2(_flag, _index);
  }

  Future<bool> confirmAccountSignOut(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.SignOut'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'settings.SignOut'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.SignOutHint1'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<Tuple2<bool, String>> editHost(
    BuildContext context, {
    String prefill = '',
  }) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController()..text = prefill;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.Host'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Set'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint1'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint2'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint3'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint4'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint5'.tr()}',
          textAlign: TextAlign.left,
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'settings.Host'.tr(),
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _setValues(true),
            validator: (value) {
              // Allow empty value
              if (value?.isEmpty ?? true) return null;
              // Test for https:// or http://
              RegExp exp = RegExp(r"^(http|https)://", caseSensitive: false);
              if (exp.hasMatch(value!)) return null;
              return 'settings.HostValidation'.tr();
            },
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _textController.text);
  }

  Future<Tuple2<bool, String>> editExternalModuleHost(
    BuildContext context, {
    String prefill = '',
  }) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController()..text = prefill;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.Host'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Set'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint1'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint2'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint3'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.HostHint4'.tr()}',
          textAlign: TextAlign.left,
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'settings.Host'.tr(),
            keyboardType: TextInputType.url,
            onSubmitted: (_) => _setValues(true),
            validator: (value) {
              // Allow empty value
              if (value?.isEmpty ?? true) return null;
              // Test for https:// or http://
              RegExp exp = RegExp(r"^(http|https)://", caseSensitive: false);
              if (exp.hasMatch(value!)) return null;
              return 'settings.HostValidation'.tr();
            },
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _textController.text);
  }

  Future<bool> deleteIndexer(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.DeleteIndexer'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Delete'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.DeleteIndexerHint1'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<bool> deleteExternalModule(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.DeleteModule'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Delete'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.DeleteModuleHint1'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<bool> deleteHeader(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.DeleteHeader'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Delete'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.DeleteHeaderHint1'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<Tuple2<bool, HeaderType?>> addHeader(BuildContext context) async {
    bool _flag = false;
    HeaderType? _type;

    void _setValues(bool flag, HeaderType type) {
      _flag = flag;
      _type = type;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.AddHeader'.tr(),
      content: List.generate(
        HeaderType.values.length,
        (index) => HarbrDialog.tile(
          text: HeaderType.values[index].name,
          icon: HeaderType.values[index].icon,
          iconColor: HarbrColours().byListIndex(index),
          onTap: () => _setValues(true, HeaderType.values[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _type);
  }

  Future<Tuple3<bool, String, String>> addCustomHeader(
    BuildContext context,
  ) async {
    bool _flag = false;
    final formKey = GlobalKey<FormState>();
    TextEditingController _key = TextEditingController();
    TextEditingController _value = TextEditingController();

    void _setValues(bool flag) {
      if (formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.CustomHeader'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Add'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        Form(
          key: formKey,
          child: Column(
            children: [
              HarbrDialog.textFormInput(
                controller: _key,
                validator: (value) {
                  if (value?.isNotEmpty ?? false) return null;
                  return 'settings.HeaderKeyValidation'.tr();
                },
                onSubmitted: (_) => _setValues(true),
                title: 'settings.HeaderKey'.tr(),
              ),
              HarbrDialog.textFormInput(
                controller: _value,
                validator: (value) {
                  if (value?.isNotEmpty ?? false) return null;
                  return 'settings.HeaderValueValidation'.tr();
                },
                onSubmitted: (_) => _setValues(true),
                title: 'settings.HeaderValue'.tr(),
              ),
            ],
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputDialogContentPadding(),
    );
    return Tuple3(_flag, _key.text, _value.text);
  }

  Future<Tuple3<bool, String, String>> addBasicAuthenticationHeader(
    BuildContext context,
  ) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _username = TextEditingController();
    final _password = TextEditingController();

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.BasicAuthentication'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Add'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BasicAuthenticationHint1'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BasicAuthenticationHint2'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BasicAuthenticationHint3'.tr()}',
          textAlign: TextAlign.left,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              HarbrDialog.textFormInput(
                controller: _username,
                validator: (username) => (username?.isNotEmpty ?? false)
                    ? null
                    : 'settings.UsernameValidation'.tr(),
                onSubmitted: (_) => _setValues(true),
                title: 'settings.Username'.tr(),
              ),
              HarbrDialog.textFormInput(
                controller: _password,
                validator: (password) => (password?.isNotEmpty ?? false)
                    ? null
                    : 'settings.PasswordValidation'.tr(),
                onSubmitted: (_) => _setValues(true),
                obscureText: true,
                title: 'settings.Password'.tr(),
              ),
            ],
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple3(_flag, _username.text, _password.text);
  }

  Future<bool> clearLogs(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.ClearLogs'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Clear'.tr(),
          onPressed: () => _setValues(true),
          textColor: HarbrColours.red,
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.ClearLogsHint1'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<Tuple2<bool, String>> confirmDeleteAccount(
    BuildContext context,
  ) async {
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController();
    bool _flag = false;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.DeleteAccount'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Delete'.tr(),
          onPressed: () => _setValues(true),
          textColor: HarbrColours.red,
        ),
      ],
      content: [
        HarbrDialog.richText(
          children: [
            HarbrDialog.bolded(
              text: 'settings.DeleteAccountWarning1'.tr().toUpperCase(),
              color: HarbrColours.red,
              fontSize: HarbrDialog.BUTTON_SIZE,
            ),
            HarbrDialog.textSpanContent(text: '\n\n'),
            HarbrDialog.textSpanContent(
              text: 'settings.DeleteAccountHint1'.tr(),
            ),
            HarbrDialog.textSpanContent(text: '\n\n'),
            HarbrDialog.textSpanContent(
              text: 'settings.DeleteAccountHint2'.tr(),
            ),
          ],
          alignment: TextAlign.center,
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'settings.Password'.tr(),
            obscureText: true,
            onSubmitted: (_) => _setValues(true),
            validator: (value) => (value?.isEmpty ?? true)
                ? 'settings.PasswordValidation'.tr()
                : null,
          ),
        ),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return Tuple2(_flag, _textController.text);
  }

  Future<Tuple3<bool, String, String>> updateAccountEmail(
    BuildContext context,
  ) async {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _flag = false;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.UpdateEmail'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Update'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              HarbrDialog.textFormInput(
                controller: _emailController,
                title: 'settings.Email'.tr(),
                onSubmitted: (_) => _setValues(true),
                validator: (value) {
                  return HarbrValidator().email(value ?? '')
                      ? null
                      : 'settings.EmailValidation'.tr();
                },
              ),
              HarbrDialog.textFormInput(
                controller: _passwordController,
                title: 'settings.CurrentPassword'.tr(),
                obscureText: true,
                onSubmitted: (_) => _setValues(true),
                validator: (value) {
                  return value?.isEmpty ?? true
                      ? 'settings.PasswordValidation'.tr()
                      : null;
                },
              ),
            ],
          ),
        ),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return Tuple3(_flag, _emailController.text, _passwordController.text);
  }

  Future<Tuple3<bool, String, String>> updateAccountPassword(
    BuildContext context,
  ) async {
    final _formKey = GlobalKey<FormState>();
    final _currentPassController = TextEditingController();
    final _newPassController = TextEditingController();
    bool _flag = false;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.UpdatePassword'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Update'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              HarbrDialog.textFormInput(
                controller: _currentPassController,
                title: 'settings.CurrentPassword'.tr(),
                obscureText: true,
                onSubmitted: (_) => _setValues(true),
                validator: (value) {
                  return value?.isEmpty ?? true
                      ? 'settings.PasswordValidation'.tr()
                      : null;
                },
              ),
              HarbrDialog.textFormInput(
                controller: _newPassController,
                title: 'settings.NewPassword'.tr(),
                obscureText: true,
                onSubmitted: (_) => _setValues(true),
                validator: (value) {
                  return value?.isEmpty ?? true
                      ? 'settings.PasswordValidation'.tr()
                      : null;
                },
              ),
            ],
          ),
        ),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return Tuple3(_flag, _newPassController.text, _currentPassController.text);
  }

  Future<Tuple2<bool, String>> addProfile(
    BuildContext context,
    List<String?> profiles,
  ) async {
    final _formKey = GlobalKey<FormState>();
    final _controller = TextEditingController();
    bool _flag = false;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.AddProfile'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Add'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _controller,
            validator: (value) {
              if (profiles.contains(value)) {
                return 'settings.ProfileAlreadyExists'.tr();
              }
              if (value?.isEmpty ?? true) {
                return 'settings.ProfileNameRequired'.tr();
              }
              return null;
            },
            onSubmitted: (_) => _setValues(true),
            title: 'settings.ProfileName'.tr(),
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputDialogContentPadding(),
    );
    return Tuple2(_flag, _controller.text);
  }

  Future<Tuple2<bool, String>> renameProfile(
    BuildContext context,
    List<String> profiles,
  ) async {
    bool _flag = false;
    String _profile = '';

    void _setValues(bool flag, String profile) {
      _flag = flag;
      _profile = profile;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.RenameProfile'.tr(),
      content: List.generate(
        profiles.length,
        (index) => HarbrDialog.tile(
          icon: Icons.settings_rounded,
          iconColor: HarbrColours().byListIndex(index),
          text: profiles[index],
          onTap: () => _setValues(true, profiles[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _profile);
  }

  Future<Tuple2<bool, String>> renameProfileSelected(
    BuildContext context,
    List<String?> profiles,
  ) async {
    final _formKey = GlobalKey<FormState>();
    final _controller = TextEditingController();
    bool _flag = false;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.RenameProfile'.tr(),
      buttons: [
        HarbrDialog.button(
            text: 'harbr.Rename'.tr(),
            onPressed: () => _setValues(true),
            textColor: HarbrColours.accent),
      ],
      content: [
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _controller,
            validator: (value) {
              if (profiles.contains(value)) {
                return 'settings.ProfileAlreadyExists'.tr();
              }
              if (value?.isEmpty ?? true) {
                return 'settings.ProfileNameRequired'.tr();
              }
              return null;
            },
            onSubmitted: (_) => _setValues(true),
            title: 'settings.ProfileName'.tr(),
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputDialogContentPadding(),
    );
    return Tuple2(_flag, _controller.text);
  }

  Future<Tuple2<bool, String>> deleteProfile(
    BuildContext context,
    List<String> profiles,
  ) async {
    bool _flag = false;
    String _profile = '';

    void _setValues(bool flag, String profile) {
      _flag = flag;
      _profile = profile;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.DeleteProfile'.tr(),
      content: List.generate(
        profiles.length,
        (index) => HarbrDialog.tile(
          icon: Icons.settings_rounded,
          iconColor: HarbrColours().byListIndex(index),
          text: profiles[index],
          onTap: () => _setValues(true, profiles[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _profile);
  }

  Future<Tuple2<bool, String>> enabledProfile(
    BuildContext context,
    List<String> profiles,
  ) async {
    bool _flag = false;
    String _profile = '';

    void _setValues(bool flag, String profile) {
      _flag = flag;
      _profile = profile;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.EnabledProfile'.tr(),
      content: List.generate(
        profiles.length,
        (index) => HarbrDialog.tile(
          icon: HarbrIcons.USER,
          iconColor: HarbrColours().byListIndex(index),
          text: profiles[index],
          onTap: () => _setValues(true, profiles[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _profile);
  }

  Future<Tuple2<bool, CalendarStartingDay?>> editCalendarStartingDay(
    BuildContext context,
  ) async {
    bool _flag = false;
    CalendarStartingDay? _startingDate;

    void _setValues(bool flag, CalendarStartingDay startingDate) {
      _flag = flag;
      _startingDate = startingDate;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.StartingDay'.tr(),
      content: List.generate(
        CalendarStartingDay.values.length,
        (index) => HarbrDialog.tile(
          icon: Icons.calendar_today_rounded,
          iconColor: HarbrColours().byListIndex(index),
          text: CalendarStartingDay.values[index].name,
          onTap: () => _setValues(true, CalendarStartingDay.values[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _startingDate);
  }

  Future<Tuple2<bool, CalendarStartingSize?>> editCalendarStartingSize(
    BuildContext context,
  ) async {
    bool _flag = false;
    CalendarStartingSize? _startingSize;

    void _setValues(bool flag, CalendarStartingSize startingSize) {
      _flag = flag;
      _startingSize = startingSize;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.StartingSize'.tr(),
      content: List.generate(
        CalendarStartingSize.values.length,
        (index) => HarbrDialog.tile(
          icon: CalendarStartingSize.values[index].icon,
          iconColor: HarbrColours().byListIndex(index),
          text: CalendarStartingSize.values[index].name,
          onTap: () => _setValues(true, CalendarStartingSize.values[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _startingSize);
  }

  Future<Tuple2<bool, CalendarStartingType?>> editCalendarStartingView(
    BuildContext context,
  ) async {
    bool _flag = false;
    CalendarStartingType? _startingType;

    void _setValues(bool flag, CalendarStartingType startingType) {
      _flag = flag;
      _startingType = startingType;
      Navigator.of(context).pop();
    }

    IconData _getIcon(CalendarStartingType type) {
      switch (type) {
        case CalendarStartingType.CALENDAR:
          return CalendarStartingType.SCHEDULE.icon;
        case CalendarStartingType.SCHEDULE:
          return CalendarStartingType.CALENDAR.icon;
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.StartingView'.tr(),
      content: List.generate(
        CalendarStartingType.values.length,
        (index) => HarbrDialog.tile(
          icon: _getIcon(CalendarStartingType.values[index]),
          iconColor: HarbrColours().byListIndex(index),
          text: CalendarStartingType.values[index].name,
          onTap: () => _setValues(true, CalendarStartingType.values[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _startingType);
  }

  Future<Tuple2<bool, String>> editBroadcastAddress(
    BuildContext context,
    String prefill,
  ) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _controller = TextEditingController()..text = prefill;

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.BroadcastAddress'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Set'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BroadcastAddressHint1'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BroadcastAddressHint2'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BroadcastAddressHint3'.tr()}',
          textAlign: TextAlign.left,
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _controller,
            validator: (address) {
              if (address?.isEmpty ?? true) return null;
              return IPAddress.validate(address).state
                  ? null
                  : 'settings.BroadcastAddressValidation'.tr();
            },
            onSubmitted: (_) => _setValues(true),
            title: 'settings.BroadcastAddress'.tr(),
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _controller.text);
  }

  Future<Tuple2<bool, String>> editMACAddress(
    BuildContext context,
    String prefill,
  ) async {
    bool _flag = false;
    final formKey = GlobalKey<FormState>();
    final _controller = TextEditingController()..text = prefill;

    void _setValues(bool flag) {
      if (formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.MACAddress'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Set'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.MACAddressHint1'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.MACAddressHint2'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.MACAddressHint3'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text: '${HarbrUI.TEXT_BULLET} ${'settings.MACAddressHint4'.tr()}',
          textAlign: TextAlign.left,
        ),
        Form(
          key: formKey,
          child: HarbrDialog.textFormInput(
            controller: _controller,
            validator: (address) {
              if (address?.isEmpty ?? true) return null;
              return MACAddress.validate(address).state
                  ? null
                  : 'settings.MACAddressValidation'.tr();
            },
            onSubmitted: (_) => _setValues(true),
            title: 'settings.MACAddress'.tr(),
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _controller.text);
  }

  Future<bool> dismissTooltipBanners(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.DismissBanners'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Dismiss'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.DismissBannersHint1'.tr()),
        HarbrDialog.textContent(text: ''),
        HarbrDialog.textContent(text: 'settings.DismissBannersHint2'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<bool> clearImageCache(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.ClearImageCache'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Clear'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.ClearImageCacheHint1'.tr()),
        HarbrDialog.textContent(text: ''),
        HarbrDialog.textContent(text: 'settings.ClearImageCacheHint2'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<bool> clearConfiguration(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.ClearConfiguration'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Clear'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.ClearConfigurationHint1'.tr()),
        HarbrDialog.textContent(text: ''),
        HarbrDialog.textContent(text: 'settings.ClearConfigurationHint2'.tr()),
        HarbrDialog.textContent(text: ''),
        HarbrDialog.textContent(text: 'settings.ClearConfigurationHint3'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<Tuple2<bool, String>> decryptBackup(BuildContext context) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController();

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.DecryptBackup'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Restore'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(text: 'settings.DecryptBackupHint1'.tr()),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'settings.EncryptionKey'.tr(),
            obscureText: true,
            onSubmitted: (_) => _setValues(true),
            validator: (value) => (value?.length ?? 0) < 8
                ? 'settings.MinimumCharacters'.tr(args: [8.toString()])
                : null,
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _textController.text);
  }

  Future<Tuple2<bool, String>> backupConfiguration(BuildContext context) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController();

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.BackupConfiguration'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.BackUp'.tr(),
          textColor: HarbrColours.accent,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BackupConfigurationHint1'.tr()}',
          textAlign: TextAlign.left,
        ),
        HarbrDialog.textContent(
          text:
              '${HarbrUI.TEXT_BULLET} ${'settings.BackupConfigurationHint2'.tr()}',
          textAlign: TextAlign.left,
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            obscureText: true,
            controller: _textController,
            title: 'settings.EncryptionKey'.tr(),
            validator: (value) => (value?.length ?? 0) < 8
                ? 'settings.MinimumCharacters'.tr(args: [8.toString()])
                : null,
            onSubmitted: (_) => _setValues(true),
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _textController.text);
  }

  Future<Tuple2<bool, int>> changeBackgroundImageOpacity(
    BuildContext context,
  ) async {
    bool _flag = false;
    int _opacity = 0;
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController()
      ..text = HarbrDatabase.THEME_IMAGE_BACKGROUND_OPACITY.read().toString();

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _opacity = int.parse(_textController.text);
        _flag = flag;
        Navigator.of(context).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.ImageBackgroundOpacity'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Set'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text: 'settings.ImageBackgroundOpacityHint1'.tr(),
        ),
        HarbrDialog.textContent(text: ''),
        HarbrDialog.textContent(
          text: 'settings.ImageBackgroundOpacityHint2'.tr(),
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'settings.ImageBackgroundOpacity'.tr(),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _setValues(true),
            validator: (value) {
              int? _opacity = int.tryParse(value!);
              if (_opacity == null || _opacity < 0 || _opacity > 100)
                return 'settings.MustBeValueBetween'.tr(args: [
                  0.toString(),
                  100.toString(),
                ]);
              return null;
            },
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _opacity);
  }

  Future<void> accountHelpMessage(BuildContext context) async {
    await HarbrDialog.dialog(
      context: context,
      title: 'settings.AccountHelp'.tr(),
      content: [HarbrDialog.textContent(text: 'settings.AccountHelpHint1'.tr())],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
  }

  Future<Tuple2<bool, HarbrModule?>> selectBootModule() async {
    final context = HarbrState.context;
    bool _flag = false;
    HarbrModule? _module;

    void _setValues(HarbrModule module) {
      _flag = true;
      _module = module;
      Navigator.of(context).pop();
    }

    final modules = HarbrModule.values.filter((module) {
      final enabled = module.isEnabled;
      final featureFlag = module.featureFlag;
      final homeRoute = module.homeRoute != null;

      return homeRoute && enabled && featureFlag;
    }).toList();

    await HarbrDialog.dialog(
      context: context,
      title: 'settings.BootModule'.tr(),
      content: List.generate(
        modules.length,
        (index) => HarbrDialog.tile(
          text: modules[index].title,
          icon: modules[index].icon,
          iconColor: modules[index].color,
          onTap: () => _setValues(modules[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );

    return Tuple2(_flag, _module);
  }
}
