import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class ReadarrNavigationBar extends StatelessWidget {
  final PageController? pageController;
  static List<ScrollController> scrollControllers = List.generate(
    icons.length,
    (_) => ScrollController(),
  );

  static const List<IconData> icons = [
    Icons.book_rounded,
    Icons.calendar_today_rounded,
    Icons.event_busy_rounded,
    Icons.more_horiz_rounded,
  ];

  static List<String> get titles => [
        'readarr.Books'.tr(),
        'readarr.Upcoming'.tr(),
        'readarr.Missing'.tr(),
        'readarr.More'.tr(),
      ];

  const ReadarrNavigationBar({
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
