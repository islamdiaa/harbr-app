import 'package:flutter/material.dart';

import 'package:harbr/widgets/ui.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_type.dart';
import 'package:harbr/modules/dashboard/core/state.dart';

class SwitchViewAction extends StatelessWidget {
  /// The index of the calendar tab in the dashboard navigation.
  static const int calendarTabIndex = 2;

  /// The currently selected navigation index.
  final int selectedIndex;

  const SwitchViewAction({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedIndex != calendarTabIndex) return const SizedBox.shrink();

    return Selector<DashboardState, CalendarStartingType>(
      selector: (_, state) => state.calendarType,
      builder: (context, view, _) {
        return HarbrIconButton.appBar(
          icon: view.icon,
          onPressed: () {
            final state = context.read<DashboardState>();
            if (view == CalendarStartingType.CALENDAR)
              state.calendarType = CalendarStartingType.SCHEDULE;
            else
              state.calendarType = CalendarStartingType.CALENDAR;
          },
        );
      },
    );
  }
}
