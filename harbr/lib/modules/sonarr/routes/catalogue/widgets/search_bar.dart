import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/routes/sonarr.dart';
import 'package:harbr/types/list_view_option.dart';

class SonarrSeriesSearchBar extends StatefulWidget {
  final ScrollController scrollController;

  const SonarrSeriesSearchBar({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<SonarrSeriesSearchBar> createState() => _State();
}

class _State extends State<SonarrSeriesSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<SonarrState>().seriesSearchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SonarrState>(
      builder: (context, state, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HarbrFilterActionBar(
            leadingAction: HarbrFilterAction(
              icon: HarbrIcons.ADD,
              label: 'sonarr.AddSeries'.tr(),
              onTap: () => SonarrRoutes.ADD_SERIES.go(),
            ),
            trailingActions: [
              HarbrFilterAction(
                icon: HarbrIcons.SORT,
                onTap: () => _showSortMenu(state),
              ),
              HarbrFilterAction(
                icon: HarbrIcons.FILTER,
                onTap: () => _showFilterMenu(state),
              ),
              HarbrFilterAction(
                icon: HarbrIcons.VIEW,
                onTap: () => _showViewMenu(state),
              ),
            ],
          ),
          HarbrSearchField(
            controller: _controller,
            hintText: 'sonarr.Search'.tr(),
            onChanged: (value) => state.seriesSearchQuery = value,
          ),
        ],
      ),
    );
  }

  void _showSortMenu(SonarrState state) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.topRight(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<SonarrSeriesSorting>(
      context: context,
      position: position,
      items: SonarrSeriesSorting.values
          .map(
            (sorting) => PopupMenuItem<SonarrSeriesSorting>(
              value: sorting,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sorting.readable,
                    style: TextStyle(
                      fontSize: HarbrUI.FONT_SIZE_H3,
                      color: state.seriesSortType == sorting
                          ? HarbrColours.accent
                          : Colors.white,
                    ),
                  ),
                  if (state.seriesSortType == sorting)
                    Icon(
                      state.seriesSortAscending
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: HarbrUI.FONT_SIZE_H2,
                      color: HarbrColours.accent,
                    ),
                ],
              ),
            ),
          )
          .toList(),
    ).then((result) {
      if (result == null) return;
      if (state.seriesSortType == result) {
        state.seriesSortAscending = !state.seriesSortAscending;
      } else {
        state.seriesSortAscending = true;
        state.seriesSortType = result;
      }
      widget.scrollController.animateToStart();
    });
  }

  void _showFilterMenu(SonarrState state) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.topRight(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<SonarrSeriesFilter>(
      context: context,
      position: position,
      items: SonarrSeriesFilter.values
          .map(
            (filter) => PopupMenuItem<SonarrSeriesFilter>(
              value: filter,
              child: Text(
                filter.readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color: state.seriesFilterType == filter
                      ? HarbrColours.accent
                      : Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    ).then((result) {
      if (result == null) return;
      state.seriesFilterType = result;
      widget.scrollController.animateToStart();
    });
  }

  void _showViewMenu(SonarrState state) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.topRight(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<HarbrListViewOption>(
      context: context,
      position: position,
      items: HarbrListViewOption.values
          .map(
            (option) => PopupMenuItem<HarbrListViewOption>(
              value: option,
              child: Text(
                option.readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color: state.seriesViewType == option
                      ? HarbrColours.accent
                      : Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    ).then((result) {
      if (result == null) return;
      state.seriesViewType = result;
      widget.scrollController.animateToStart();
    });
  }
}
