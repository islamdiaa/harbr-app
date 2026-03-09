import 'package:flutter/material.dart';
import 'package:harbr/database/tables/dashboard.dart';

import 'package:harbr/widgets/ui.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/navigation_bar.dart';

class DashboardDialogs {
  Future<Tuple2<bool, int>> defaultPage(BuildContext context) async {
    bool _flag = false;
    int _index = 0;

    void _setValues(bool flag, int index) {
      _flag = flag;
      _index = index;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'harbr.Page'.tr(),
      content: List.generate(
        HomeNavigationBar.titles.length,
        (index) => HarbrDialog.tile(
          text: HomeNavigationBar.titles[index],
          icon: HomeNavigationBar.icons[index],
          iconColor: HarbrColours().byListIndex(index),
          onTap: () => _setValues(true, index),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );

    return Tuple2(_flag, _index);
  }

  Future<Tuple2<bool, int>> setPastDays(BuildContext context) async {
    bool _flag = false;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _textController = TextEditingController(
      text: DashboardDatabase.CALENDAR_DAYS_PAST.read().toString(),
    );

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'dashboard.PastDays'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Set'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text: 'dashboard.PastDaysDescription'.tr(),
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'dashboard.PastDays'.tr(),
            onSubmitted: (_) => _setValues(true),
            validator: (value) {
              int? _value = int.tryParse(value!);
              if (_value != null && _value >= 1) return null;
              return 'dashboard.MinimumOfOneDay'.tr();
            },
            keyboardType: TextInputType.number,
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );

    return Tuple2(_flag, int.tryParse(_textController.text) ?? 14);
  }

  Future<Tuple2<bool, int>> setFutureDays(BuildContext context) async {
    bool _flag = false;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _textController = TextEditingController(
      text: DashboardDatabase.CALENDAR_DAYS_FUTURE.read().toString(),
    );

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'dashboard.FutureDays'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Set'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text: 'dashboard.FutureDaysDescription'.tr(),
        ),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'dashboard.FutureDays'.tr(),
            onSubmitted: (_) => _setValues(true),
            validator: (value) {
              int? _value = int.tryParse(value!);
              if (_value != null && _value >= 1) return null;
              return 'dashboard.MinimumOfOneDay'.tr();
            },
            keyboardType: TextInputType.number,
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );

    return Tuple2(_flag, int.tryParse(_textController.text) ?? 14);
  }
}
