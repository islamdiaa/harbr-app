import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';

/// Wraps [child] in a [MaterialApp] with the Harbr midnight theme extension
/// registered, so widgets that use `context.harbr` can resolve correctly.
Widget harbrTestApp(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      extensions: const [HarbrThemeData.midnight],
    ),
    home: Scaffold(body: child),
  );
}

/// Wraps [child] in a [MaterialApp] with the AMOLED theme extension.
Widget harbrTestAppAmoled(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      extensions: const [HarbrThemeData.amoled],
    ),
    home: Scaffold(body: child),
  );
}

/// Wraps [child] with constrained width/height for responsive testing.
Widget harbrTestAppWithSize(Widget child, {double width = 400, double height = 800}) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      extensions: const [HarbrThemeData.midnight],
    ),
    home: SizedBox(
      width: width,
      height: height,
      child: MediaQuery(
        data: MediaQueryData(size: Size(width, height)),
        child: Scaffold(body: child),
      ),
    ),
  );
}
