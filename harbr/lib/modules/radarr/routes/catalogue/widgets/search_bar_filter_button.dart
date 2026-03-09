import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/radarr.dart';

class RadarrCatalogueSearchBarFilterButton extends StatefulWidget {
  final ScrollController controller;

  const RadarrCatalogueSearchBarFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<RadarrCatalogueSearchBarFilterButton> createState() => _State();
}

class _State extends State<RadarrCatalogueSearchBarFilterButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<RadarrState>(
        builder: (context, state, _) => HarbrPopupMenuButton<RadarrMoviesFilter>(
          tooltip: 'radarr.FilterCatalogue'.tr(),
          icon: HarbrIcons.FILTER,
          onSelected: (result) {
            state.moviesFilterType = result;
            widget.controller.animateToStart();
          },
          itemBuilder: (context) =>
              List<PopupMenuEntry<RadarrMoviesFilter>>.generate(
            RadarrMoviesFilter.values.length,
            (index) => PopupMenuItem<RadarrMoviesFilter>(
              value: RadarrMoviesFilter.values[index],
              child: Text(
                RadarrMoviesFilter.values[index].readable,
                style: TextStyle(
                  fontSize: HarbrUI.FONT_SIZE_H3,
                  color:
                      state.moviesFilterType == RadarrMoviesFilter.values[index]
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
}
