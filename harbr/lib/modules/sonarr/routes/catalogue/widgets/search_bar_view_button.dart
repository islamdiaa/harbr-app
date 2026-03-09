import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/types/list_view_option.dart';

class SonarrSeriesSearchBarViewButton extends StatefulWidget {
  final ScrollController controller;

  const SonarrSeriesSearchBarViewButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SonarrSeriesSearchBarViewButton> createState() => _State();
}

class _State extends State<SonarrSeriesSearchBarViewButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<SonarrState>(
        builder: (context, state, _) => HarbrPopupMenuButton<HarbrListViewOption>(
          tooltip: 'harbr.View'.tr(),
          icon: HarbrIcons.VIEW,
          onSelected: (result) {
            state.seriesViewType = result;
            widget.controller.animateToStart();
          },
          itemBuilder: (context) =>
              List<PopupMenuEntry<HarbrListViewOption>>.generate(
            HarbrListViewOption.values.length,
            (index) => PopupMenuItem<HarbrListViewOption>(
              value: HarbrListViewOption.values[index],
              child: Text(
                HarbrListViewOption.values[index].readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color:
                      state.seriesViewType == HarbrListViewOption.values[index]
                          ? HarbrColours.accent
                          : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      margin: const EdgeInsets.only(left: HarbrUI.DEFAULT_MARGIN_SIZE),
      color: Theme.of(context).canvasColor,
      height: HarbrTextInputBar.defaultHeight,
      width: HarbrTextInputBar.defaultHeight,
    );
  }
}
