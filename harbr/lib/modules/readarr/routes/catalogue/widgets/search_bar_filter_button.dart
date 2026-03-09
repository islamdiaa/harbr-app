import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/scroll_controller.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrAuthorSearchBarFilterButton extends StatefulWidget {
  final ScrollController controller;

  const ReadarrAuthorSearchBarFilterButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ReadarrAuthorSearchBarFilterButton> createState() => _State();
}

class _State extends State<ReadarrAuthorSearchBarFilterButton> {
  @override
  Widget build(BuildContext context) => HarbrCard(
        context: context,
        child: Consumer<ReadarrState>(
          builder: (context, state, _) =>
              HarbrPopupMenuButton<ReadarrBooksFilter>(
            tooltip: 'readarr.FilterCatalogue'.tr(),
            icon: Icons.filter_list_rounded,
            onSelected: (result) {
              state.filterType = result;
              widget.controller.animateToStart();
            },
            itemBuilder: (context) =>
                List<PopupMenuEntry<ReadarrBooksFilter>>.generate(
              ReadarrBooksFilter.values.length,
              (index) => PopupMenuItem<ReadarrBooksFilter>(
                value: ReadarrBooksFilter.values[index],
                child: Text(
                  ReadarrBooksFilter.values[index].readable,
                  style: TextStyle(
                    fontSize: HarbrUI.FONT_SIZE_H3,
                    color: state.filterType ==
                            ReadarrBooksFilter.values[index]
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
