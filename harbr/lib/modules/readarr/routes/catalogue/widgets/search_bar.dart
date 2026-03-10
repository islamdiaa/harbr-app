import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/router/routes/readarr.dart';

class ReadarrAuthorSearchBar extends StatefulWidget {
  final ScrollController scrollController;

  const ReadarrAuthorSearchBar({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ReadarrAuthorSearchBar> createState() => _State();
}

class _State extends State<ReadarrAuthorSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<ReadarrState>().searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadarrState>(
      builder: (context, state, _) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HarbrFilterActionBar(
            leadingAction: HarbrFilterAction(
              icon: HarbrIcons.ADD,
              label: 'readarr.AddBook'.tr(),
              onTap: () => ReadarrRoutes.ADD_BOOK.go(),
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
            ],
          ),
          HarbrSearchField(
            controller: _controller,
            hintText: 'readarr.Search'.tr(),
            onChanged: (value) => state.searchQuery = value,
          ),
        ],
      ),
    );
  }

  void _showSortMenu(ReadarrState state) {
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
    showMenu<ReadarrBooksSorting>(
      context: context,
      position: position,
      items: ReadarrBooksSorting.values
          .map(
            (sorting) => PopupMenuItem<ReadarrBooksSorting>(
              value: sorting,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sorting.readable,
                    style: TextStyle(
                      fontSize: HarbrUI.FONT_SIZE_H3,
                      color: state.sortType == sorting
                          ? HarbrColours.accent
                          : Colors.white,
                    ),
                  ),
                  if (state.sortType == sorting)
                    Icon(
                      state.sortAscending
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
      if (state.sortType == result) {
        state.sortAscending = !state.sortAscending;
      } else {
        state.sortAscending = true;
        state.sortType = result;
      }
      widget.scrollController.animateToStart();
    });
  }

  void _showFilterMenu(ReadarrState state) {
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
    showMenu<ReadarrBooksFilter>(
      context: context,
      position: position,
      items: ReadarrBooksFilter.values
          .map(
            (filter) => PopupMenuItem<ReadarrBooksFilter>(
              value: filter,
              child: Text(
                filter.readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color: state.filterType == filter
                      ? HarbrColours.accent
                      : Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    ).then((result) {
      if (result == null) return;
      state.filterType = result;
      widget.scrollController.animateToStart();
    });
  }
}
