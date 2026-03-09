import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr/routes/add_book/state.dart';

// ignore: non_constant_identifier_names
Widget ReadarrAddBookAppBar({
  required ScrollController scrollController,
  required String query,
  required bool autofocus,
}) =>
    HarbrAppBar(
      title: 'readarr.AddBook'.tr(),
      scrollControllers: [scrollController],
      bottom: _SearchBar(
        scrollController: scrollController,
        query: query,
        autofocus: autofocus,
      ),
    );

class _SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String query;
  final bool autofocus;
  final ScrollController scrollController;

  const _SearchBar({
    Key? key,
    required this.query,
    required this.autofocus,
    required this.scrollController,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      const Size.fromHeight(HarbrTextInputBar.defaultAppBarHeight);

  @override
  State<_SearchBar> createState() => _State();
}

class _State extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: HarbrTextInputBar.defaultAppBarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: HarbrTextInputBar(
                controller: _controller,
                scrollController: widget.scrollController,
                autofocus: widget.autofocus,
                onChanged: (value) =>
                    context.read<ReadarrAddBookState>().searchQuery = value,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<ReadarrAddBookState>().fetchLookup(context);
                  }
                },
                margin: HarbrTextInputBar.appBarMargin,
              ),
            ),
          ],
        ),
      );
}
