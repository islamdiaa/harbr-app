import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  int _weekOffset = 0;

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

  /// Returns the Monday of the week containing [date].
  DateTime _weekStart(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1)); // Monday = 1
  }

  /// Builds the week navigation bar with left/right chevrons and a label.
  Widget _buildWeekNavBar(HarbrThemeData harbr) {
    final now = DateTime.now();
    final start = _weekStart(now).add(Duration(days: _weekOffset * 7));
    final end = start.add(const Duration(days: 6));

    final dayFmt = DateFormat('d MMM');
    final yearFmt = DateFormat('yyyy');
    final label = '${dayFmt.format(start)} - ${dayFmt.format(end)} ${yearFmt.format(end)}';

    return Container(
      decoration: BoxDecoration(
        color: harbr.surface0,
        border: Border.all(color: harbr.border),
        borderRadius: HarbrTokens.borderRadius12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(() => _weekOffset--),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.chevron_left_rounded, size: 20, color: harbr.onSurfaceDim),
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: harbr.onSurface),
          ),
          GestureDetector(
            onTap: () => setState(() => _weekOffset++),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.chevron_right_rounded, size: 20, color: harbr.onSurfaceDim),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the row of 7 day pills for the current week.
  Widget _buildDayPills(
    HarbrThemeData harbr,
    Map<DateTime, List<CalendarData>> events,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = _weekStart(now).add(Duration(days: _weekOffset * 7));
    final dayNameFmt = DateFormat('E'); // e.g. "Mon"

    return Row(
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final dayNorm = DateTime(day.year, day.month, day.day);
        final isToday = dayNorm == today;
        final hasItems = events.keys.any((k) =>
            k.year == dayNorm.year &&
            k.month == dayNorm.month &&
            k.day == dayNorm.day);

        // Determine colors
        final Color bg;
        final Color textColor;
        if (isToday) {
          bg = harbr.accent;
          textColor = Colors.white;
        } else if (hasItems) {
          bg = harbr.surface0;
          textColor = harbr.onSurface;
        } else {
          bg = Colors.transparent;
          textColor = harbr.onSurfaceDim;
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
            child: Container(
              constraints: const BoxConstraints(minWidth: 40),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                border: hasItems && !isToday
                    ? Border.all(color: harbr.border)
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dayNameFmt.format(day).substring(0, 3).toUpperCase(),
                    style: TextStyle(fontSize: 10, color: textColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.day}',
                    style: TextStyle(fontSize: 15, color: textColor),
                  ),
                  if (hasItems && !isToday) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: harbr.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
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
            final allEvents = snapshot.data!;
            final harbr = context.harbr;

            // Filter events to the selected week
            final now = DateTime.now();
            final weekStart = _weekStart(now).add(Duration(days: _weekOffset * 7));
            final weekEnd = weekStart.add(const Duration(days: 7));
            final events = Map<DateTime, List<CalendarData>>.fromEntries(
              allEvents.entries.where((e) =>
                !e.key.isBefore(weekStart) && e.key.isBefore(weekEnd)),
            );
            return Column(
              children: [
                // SafeArea top padding (no appbar)
                SafeArea(bottom: false, child: const SizedBox(height: HarbrTokens.lg)),

                // Header: "Calendar"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.lg),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Calendar',
                      style: TextStyle(
                        color: harbr.onSurface,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: HarbrTokens.lg),

                // Week navigation bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.lg),
                  child: _buildWeekNavBar(harbr),
                ),
                const SizedBox(height: 16),

                // Day pills row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: HarbrTokens.lg),
                  child: _buildDayPills(harbr, events),
                ),
                const SizedBox(height: 20),

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
