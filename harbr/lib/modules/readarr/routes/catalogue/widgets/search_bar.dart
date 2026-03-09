import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/catalogue/widgets/search_bar_filter_button.dart';
import 'package:harbr/modules/readarr/routes/catalogue/widgets/search_bar_sort_button.dart';
import 'package:harbr/modules/readarr/routes/catalogue/widgets/search_bar_view_button.dart';

class ReadarrAuthorSearchBar extends StatefulWidget {
  final ScrollController scrollController;

  const ReadarrAuthorSearchBar({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ReadarrAuthorSearchBar> createState() => _State();
}

class _State extends State<ReadarrAuthorSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<ReadarrState>().searchQuery;
    _focusNode.addListener(_handleFocus);
  }

  void _handleFocus() {
    if (_focusNode.hasPrimaryFocus != _hasFocus)
      setState(() => _hasFocus = _focusNode.hasPrimaryFocus);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _sc = widget.scrollController;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Consumer<ReadarrState>(
            builder: (context, state, _) => HarbrTextInputBar(
              controller: _controller,
              scrollController: _sc,
              focusNode: _focusNode,
              autofocus: false,
              onChanged: (value) =>
                  context.read<ReadarrState>().searchQuery = value,
              margin: EdgeInsets.zero,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(
            milliseconds: HarbrUI.ANIMATION_SPEED_SCROLLING,
          ),
          curve: Curves.easeInOutQuart,
          width: _hasFocus
              ? 0.0
              : (HarbrTextInputBar.defaultHeight * 3 +
                  HarbrUI.DEFAULT_MARGIN_SIZE * 3),
          child: Row(
            children: [
              Flexible(
                child: ReadarrAuthorSearchBarFilterButton(controller: _sc),
              ),
              Flexible(
                child: ReadarrAuthorSearchBarSortButton(controller: _sc),
              ),
              Flexible(
                child: ReadarrCatalogueSearchBarViewButton(controller: _sc),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
