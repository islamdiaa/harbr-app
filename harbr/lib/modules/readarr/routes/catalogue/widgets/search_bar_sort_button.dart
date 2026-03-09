import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrAuthorSearchBarSortButton extends StatefulWidget {
  final ScrollController controller;

  const ReadarrAuthorSearchBarSortButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ReadarrAuthorSearchBarSortButton> createState() => _State();
}

class _State extends State<ReadarrAuthorSearchBarSortButton> {
  @override
  Widget build(BuildContext context) => HarbrCard(
        context: context,
        child: Consumer<ReadarrState>(
          builder: (context, state, _) =>
              HarbrPopupMenuButton<ReadarrBooksSorting>(
            tooltip: 'readarr.SortCatalogue'.tr(),
            icon: Icons.sort_rounded,
            onSelected: (result) {
              if (state.sortType == result) {
                state.sortAscending = !state.sortAscending;
              } else {
                state.sortAscending = true;
                state.sortType = result;
              }
              widget.controller.animateToStart();
            },
            itemBuilder: (context) =>
                List<PopupMenuEntry<ReadarrBooksSorting>>.generate(
              ReadarrBooksSorting.values.length,
              (index) => PopupMenuItem<ReadarrBooksSorting>(
                value: ReadarrBooksSorting.values[index],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ReadarrBooksSorting.values[index].readable,
                      style: TextStyle(
                        fontSize: HarbrUI.FONT_SIZE_H3,
                        color: state.sortType ==
                                ReadarrBooksSorting.values[index]
                            ? HarbrColours.accent
                            : Colors.white,
                      ),
                    ),
                    if (state.sortType == ReadarrBooksSorting.values[index])
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
            ),
          ),
        ),
        height: HarbrTextInputBar.defaultHeight,
        width: HarbrTextInputBar.defaultHeight,
        margin: const EdgeInsets.only(left: HarbrUI.DEFAULT_MARGIN_SIZE),
        color: Theme.of(context).canvasColor,
      );
}
