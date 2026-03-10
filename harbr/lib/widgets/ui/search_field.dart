import 'package:flutter/material.dart';
import 'package:harbr/widgets/ui/theme_extension.dart';
import 'package:harbr/widgets/ui/tokens.dart';

/// A rounded search field with focus accent border.
///
/// Renders a pill-shaped search input with a search icon on the left,
/// optional clear button when text is present, and accent-colored border
/// on focus.
class HarbrSearchField extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final bool autofocus;

  const HarbrSearchField({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autofocus = false,
  });

  @override
  State<HarbrSearchField> createState() => _HarbrSearchFieldState();
}

class _HarbrSearchFieldState extends State<HarbrSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final harbr = context.harbr;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HarbrTokens.md,
        vertical: HarbrTokens.sm,
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _hasFocus = focused),
        child: AnimatedContainer(
          duration: HarbrTokens.durationFast,
          decoration: BoxDecoration(
            color: harbr.surface0,
            borderRadius: HarbrTokens.borderRadius12,
            border: Border.all(
              color: _hasFocus
                  ? harbr.accent.withValues(alpha: 0.50)
                  : harbr.border,
            ),
          ),
          child: TextField(
            controller: _controller,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: TextStyle(
              color: harbr.onSurface,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Search...',
              hintStyle: TextStyle(
                color: harbr.onSurfaceFaint,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: harbr.onSurfaceDim,
                size: HarbrTokens.iconMd,
              ),
              suffixIcon: _hasText
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: harbr.onSurfaceDim,
                        size: HarbrTokens.iconMd,
                      ),
                      onPressed: () {
                        _controller.clear();
                        widget.onChanged?.call('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: HarbrTokens.lg,
                vertical: HarbrTokens.md,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
