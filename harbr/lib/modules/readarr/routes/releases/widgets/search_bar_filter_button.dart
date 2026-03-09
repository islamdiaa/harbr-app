import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/releases/state.dart';

class ReadarrReleasesAppBarFilterButton extends StatefulWidget {
  final ScrollController controller;

  const ReadarrReleasesAppBarFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ReadarrReleasesAppBarFilterButton> createState() => _State();
}

class _State extends State<ReadarrReleasesAppBarFilterButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<ReadarrReleasesState>(
        builder: (context, state, _) =>
            HarbrPopupMenuButton<ReadarrReleasesFilter>(
          tooltip: 'readarr.FilterReleases'.tr(),
          icon: Icons.filter_list_rounded,
          onSelected: (result) {
            state.filterType = result;
            widget.controller.animateToStart();
          },
          itemBuilder: (context) =>
              List<PopupMenuEntry<ReadarrReleasesFilter>>.generate(
            ReadarrReleasesFilter.values.length,
            (index) => PopupMenuItem<ReadarrReleasesFilter>(
              value: ReadarrReleasesFilter.values[index],
              child: Text(
                ReadarrReleasesFilter.values[index].readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color:
                      state.filterType == ReadarrReleasesFilter.values[index]
                          ? HarbrColours.accent
                          : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      height: HarbrTextInputBar.defaultHeight,
      width: HarbrTextInputBar.defaultHeight,
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 12.0, 14.0),
      color: Theme.of(context).canvasColor,
    );
  }
}
