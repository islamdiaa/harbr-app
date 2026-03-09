import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/sonarr.dart';

class SonarrSeriesSearchBarFilterButton extends StatefulWidget {
  final ScrollController controller;

  const SonarrSeriesSearchBarFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<SonarrSeriesSearchBarFilterButton> createState() => _State();
}

class _State extends State<SonarrSeriesSearchBarFilterButton> {
  @override
  Widget build(BuildContext context) => HarbrCard(
        context: context,
        child: Consumer<SonarrState>(
          builder: (context, state, _) =>
              HarbrPopupMenuButton<SonarrSeriesFilter>(
            tooltip: 'sonarr.FilterCatalogue'.tr(),
            icon: Icons.filter_list_rounded,
            onSelected: (result) {
              state.seriesFilterType = result;
              widget.controller.animateToStart();
            },
            itemBuilder: (context) =>
                List<PopupMenuEntry<SonarrSeriesFilter>>.generate(
              SonarrSeriesFilter.values.length,
              (index) => PopupMenuItem<SonarrSeriesFilter>(
                value: SonarrSeriesFilter.values[index],
                child: Text(
                  SonarrSeriesFilter.values[index].readable,
                  style: TextStyle(
                    fontSize: HarbrUI.FONT_SIZE_H3,
                    color: state.seriesFilterType ==
                            SonarrSeriesFilter.values[index]
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
        margin: const EdgeInsets.only(left: HarbrUI.DEFAULT_MARGIN_SIZE),
        color: Theme.of(context).canvasColor,
      );
}
