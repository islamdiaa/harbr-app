import 'package:flutter/material.dart';

import 'package:harbr/widgets/ui.dart';
import 'package:harbr/system/logger.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/modules/dashboard/core/adapters/calendar_starting_type.dart';
import 'package:harbr/modules/dashboard/core/api/data/abstract.dart';
import 'package:harbr/modules/dashboard/core/state.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/calendar_view.dart';
import 'package:harbr/modules/dashboard/routes/dashboard/widgets/schedule_view.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _State();
}

class _State extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin, HarbrLoadCallbackMixin {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> loadCallback() async {
    context.read<DashboardState>().resetToday();
    context.read<DashboardState>().resetUpcoming();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleCalendarType() {
    final state = context.read<DashboardState>();
    state.calendarType = state.calendarType == CalendarStartingType.CALENDAR
        ? CalendarStartingType.SCHEDULE
        : CalendarStartingType.CALENDAR;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: loadCallback,
      child: FutureBuilder(
        future: context.watch<DashboardState>().upcoming,
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<DateTime, List<CalendarData>>> snapshot,
        ) {
          if (snapshot.hasError) {
            HarbrLogger().error(
              'Failed to fetch unified calendar data',
              snapshot.error,
              snapshot.stackTrace,
            );
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final events = snapshot.data!;
            return Column(
              children: [
                // Filter action bar
                HarbrFilterActionBar(
                  leadingAction: HarbrFilterAction(
                    icon: Icons.calendar_today_rounded,
                    label: context.watch<DashboardState>().calendarType.name,
                    onTap: _toggleCalendarType,
                  ),
                  trailingActions: [
                    HarbrFilterAction(
                      icon: Icons.more_vert_rounded,
                      onTap: () {},
                    ),
                    HarbrFilterAction(
                      icon: Icons.menu_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
                // Search field
                HarbrSearchField(
                  hintText: 'Search releases...',
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                // Calendar / Schedule content
                Expanded(
                  child: Selector<DashboardState, CalendarStartingType>(
                    selector: (_, s) => s.calendarType,
                    builder: (context, type, _) {
                      if (type == CalendarStartingType.CALENDAR)
                        return CalendarView(events: events);
                      else
                        return ScheduleView(
                          events: events,
                          searchQuery: _searchQuery,
                        );
                    },
                  ),
                ),
              ],
            );
          }

          return const HarbrLoader();
        },
      ),
    );
  }
}
