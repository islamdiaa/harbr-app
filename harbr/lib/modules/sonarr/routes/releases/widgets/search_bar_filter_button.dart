import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrReleasesAppBarFilterButton extends StatefulWidget {
  final ScrollController controller;

  const SonarrReleasesAppBarFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SonarrReleasesAppBarFilterButton> createState() => _State();
}

class _State extends State<SonarrReleasesAppBarFilterButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<SonarrReleasesState>(
        builder: (context, state, _) =>
            HarbrPopupMenuButton<SonarrReleasesFilter>(
          tooltip: 'sonarr.FilterReleases'.tr(),
          icon: Icons.filter_list_rounded,
          onSelected: (result) {
            state.filterType = result;
            widget.controller.animateToStart();
          },
          itemBuilder: (context) =>
              List<PopupMenuEntry<SonarrReleasesFilter>>.generate(
            SonarrReleasesFilter.values.length,
            (index) => PopupMenuItem<SonarrReleasesFilter>(
              value: SonarrReleasesFilter.values[index],
              child: Text(
                SonarrReleasesFilter.values[index].readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color: state.filterType == SonarrReleasesFilter.values[index]
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
