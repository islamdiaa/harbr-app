import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/releases/state.dart';

class ReadarrReleasesAppBarSortButton extends StatefulWidget {
  final ScrollController controller;

  const ReadarrReleasesAppBarSortButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ReadarrReleasesAppBarSortButton> createState() => _State();
}

class _State extends State<ReadarrReleasesAppBarSortButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<ReadarrReleasesState>(
        builder: (context, state, _) =>
            HarbrPopupMenuButton<ReadarrReleasesSorting>(
          tooltip: 'readarr.SortReleases'.tr(),
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
              List<PopupMenuEntry<ReadarrReleasesSorting>>.generate(
            ReadarrReleasesSorting.values.length,
            (index) => PopupMenuItem<ReadarrReleasesSorting>(
              value: ReadarrReleasesSorting.values[index],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ReadarrReleasesSorting.values[index].readable,
                    style: TextStyle(
                      fontSize: HarbrUI.FONT_SIZE_H3,
                      color: state.sortType ==
                              ReadarrReleasesSorting.values[index]
                          ? HarbrColours.accent
                          : Colors.white,
                    ),
                  ),
                  if (state.sortType == ReadarrReleasesSorting.values[index])
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
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 13.5),
      color: Theme.of(context).canvasColor,
    );
  }
}
