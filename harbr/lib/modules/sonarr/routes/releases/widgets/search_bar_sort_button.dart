import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrReleasesAppBarSortButton extends StatefulWidget {
  final ScrollController controller;

  const SonarrReleasesAppBarSortButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SonarrReleasesAppBarSortButton> createState() => _State();
}

class _State extends State<SonarrReleasesAppBarSortButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<SonarrReleasesState>(
        builder: (context, state, _) =>
            HarbrPopupMenuButton<SonarrReleasesSorting>(
          tooltip: 'sonarr.SortReleases'.tr(),
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
              List<PopupMenuEntry<SonarrReleasesSorting>>.generate(
            SonarrReleasesSorting.values.length,
            (index) => PopupMenuItem<SonarrReleasesSorting>(
              value: SonarrReleasesSorting.values[index],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    SonarrReleasesSorting.values[index].readable,
                    style: TextStyle(
                      fontSize: HarbrUI.FONT_SIZE_H3,
                      color:
                          state.sortType == SonarrReleasesSorting.values[index]
                              ? HarbrColours.accent
                              : Colors.white,
                    ),
                  ),
                  if (state.sortType == SonarrReleasesSorting.values[index])
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
