import 'package:flutter/material.dart';

class HarbrPageView extends StatelessWidget {
  final PageController? controller;
  final List<Widget> children;

  const HarbrPageView({
    Key? key,
    this.controller,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: children,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
