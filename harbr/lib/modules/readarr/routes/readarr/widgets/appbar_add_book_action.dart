import 'package:flutter/material.dart';
import 'package:harbr/router/routes/readarr.dart';
import 'package:harbr/widgets/ui.dart';

class ReadarrAppBarAddBookAction extends StatelessWidget {
  const ReadarrAppBarAddBookAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrIconButton(
      icon: Icons.add_rounded,
      onPressed: ReadarrRoutes.ADD_BOOK.go,
    );
  }
}
