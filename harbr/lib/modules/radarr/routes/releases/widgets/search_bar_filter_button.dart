import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrReleasesAppBarFilterButton extends StatefulWidget {
  final ScrollController controller;

  const RadarrReleasesAppBarFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<RadarrReleasesAppBarFilterButton> createState() => _State();
}

class _State extends State<RadarrReleasesAppBarFilterButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<RadarrReleasesState>(
        builder: (context, state, _) =>
            HarbrPopupMenuButton<RadarrReleasesFilter>(
          tooltip: 'Filter Releases',
          icon: Icons.filter_list_rounded,
          onSelected: (result) {
            state.filterType = result;
            widget.controller.animateToStart();
          },
          itemBuilder: (context) =>
              List<PopupMenuEntry<RadarrReleasesFilter>>.generate(
            RadarrReleasesFilter.values.length,
            (index) => PopupMenuItem<RadarrReleasesFilter>(
              value: RadarrReleasesFilter.values[index],
              child: Text(
                RadarrReleasesFilter.values[index].readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color: state.filterType == RadarrReleasesFilter.values[index]
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
