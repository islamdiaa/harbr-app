import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/router/routes/radarr.dart';
import 'package:harbr/types/list_view_option.dart';

class RadarrCatalogueSearchBar extends StatefulWidget
    implements PreferredSizeWidget {
  final ScrollController scrollController;

  const RadarrCatalogueSearchBar({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(116);

  @override
  State<RadarrCatalogueSearchBar> createState() => _State();
}

class _State extends State<RadarrCatalogueSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<RadarrState>().moviesSearchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RadarrState>(
      builder: (context, state, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HarbrFilterActionBar(
            leadingAction: HarbrFilterAction(
              icon: HarbrIcons.ADD,
              label: 'radarr.AddMovie'.tr(),
              onTap: () => RadarrRoutes.ADD_MOVIE.go(),
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
            hintText: 'radarr.Search'.tr(),
            onChanged: (value) => state.moviesSearchQuery = value,
          ),
        ],
      ),
    );
  }

  void _showSortMenu(RadarrState state) {
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
    showMenu<RadarrMoviesSorting>(
      context: context,
      position: position,
      items: RadarrMoviesSorting.values
          .map(
            (sorting) => PopupMenuItem<RadarrMoviesSorting>(
              value: sorting,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sorting.readable,
                    style: TextStyle(
                      fontSize: HarbrUI.FONT_SIZE_H3,
                      color: state.moviesSortType == sorting
                          ? HarbrColours.accent
                          : Colors.white,
                    ),
                  ),
                  if (state.moviesSortType == sorting)
                    Icon(
                      state.moviesSortAscending
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
      if (state.moviesSortType == result) {
        state.moviesSortAscending = !state.moviesSortAscending;
      } else {
        state.moviesSortAscending = true;
        state.moviesSortType = result;
      }
      widget.scrollController.animateToStart();
    });
  }

  void _showFilterMenu(RadarrState state) {
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
    showMenu<RadarrMoviesFilter>(
      context: context,
      position: position,
      items: RadarrMoviesFilter.values
          .map(
            (filter) => PopupMenuItem<RadarrMoviesFilter>(
              value: filter,
              child: Text(
                filter.readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color: state.moviesFilterType == filter
                      ? HarbrColours.accent
                      : Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    ).then((result) {
      if (result == null) return;
      state.moviesFilterType = result;
      widget.scrollController.animateToStart();
    });
  }

  void _showViewMenu(RadarrState state) {
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
                  color: state.moviesViewType == option
                      ? HarbrColours.accent
                      : Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    ).then((result) {
      if (result == null) return;
      state.moviesViewType = result;
      widget.scrollController.animateToStart();
    });
  }
}
