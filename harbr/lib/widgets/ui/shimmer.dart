import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:shimmer/shimmer.dart';

class HarbrShimmer extends StatelessWidget {
  final Widget child;

  const HarbrShimmer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      baseColor: Theme.of(context).primaryColor,
      highlightColor: HarbrColours.accent,
    );
  }
}
