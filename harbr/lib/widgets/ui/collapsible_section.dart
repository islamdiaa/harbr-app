import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// An expandable/collapsible section with a chevron toggle.
///
/// Container uses a glassmorphism background (black at 30% opacity with
/// backdrop blur) and [HarbrTokens.borderRadiusXxl]. The header shows a
/// title and a rotating chevron icon.
class HarbrCollapsibleSection extends StatefulWidget {
  final String title;
  final bool initiallyExpanded;
  final Widget child;

  /// Optional trailing widget in the header (e.g. a count badge).
  final Widget? headerTrailing;

  const HarbrCollapsibleSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
    this.headerTrailing,
  });

  @override
  State<HarbrCollapsibleSection> createState() =>
      _HarbrCollapsibleSectionState();
}

class _HarbrCollapsibleSectionState extends State<HarbrCollapsibleSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: HarbrTokens.durationNormal,
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return Padding(
      padding: HarbrTokens.paddingCard,
      child: ClipRRect(
        borderRadius: HarbrTokens.borderRadiusXxl,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: HarbrTokens.borderRadiusXxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                InkWell(
                  onTap: _toggle,
                  borderRadius: HarbrTokens.borderRadiusXxl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: HarbrTokens.lg,
                      vertical: HarbrTokens.md,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              color: harbr.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (widget.headerTrailing != null) ...[
                          widget.headerTrailing!,
                          const SizedBox(width: HarbrTokens.sm),
                        ],
                        RotationTransition(
                          turns: _rotationAnimation,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: harbr.onSurfaceDim,
                            size: HarbrTokens.iconLg,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Collapsible content
                SizeTransition(
                  sizeFactor: _sizeAnimation,
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
