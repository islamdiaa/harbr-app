import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class ReadarrAuthorDetailsNavigationBar extends StatelessWidget {
  final PageController? pageController;
  static List<ScrollController> scrollControllers = List.generate(
    icons.length,
    (_) => ScrollController(),
  );

  static const List<IconData> icons = [
    Icons.info_outline_rounded,
    Icons.book_rounded,
    Icons.history_rounded,
  ];

  static List<String> get titles => [
        'readarr.Overview'.tr(),
        'readarr.Books'.tr(),
        'readarr.History'.tr(),
      ];

  const ReadarrAuthorDetailsNavigationBar({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBottomNavigationBar(
      pageController: pageController,
      scrollControllers: scrollControllers,
      icons: icons,
      titles: titles,
    );
  }
}
