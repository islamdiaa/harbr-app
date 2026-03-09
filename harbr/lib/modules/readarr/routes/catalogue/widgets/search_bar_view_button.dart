import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/types/list_view_option.dart';

class ReadarrCatalogueSearchBarViewButton extends StatefulWidget {
  final ScrollController controller;

  const ReadarrCatalogueSearchBarViewButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ReadarrCatalogueSearchBarViewButton> createState() => _State();
}

class _State extends State<ReadarrCatalogueSearchBarViewButton> {
  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Consumer<ReadarrState>(
        builder: (context, state, _) =>
            HarbrPopupMenuButton<HarbrListViewOption>(
          tooltip: 'harbr.View'.tr(),
          icon: HarbrIcons.VIEW,
          onSelected: (result) {
            state.authorViewType = result;
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
                  color: state.authorViewType ==
                          HarbrListViewOption.values[index]
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
