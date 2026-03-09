import 'package:flutter/material.dart';
import 'package:harbr/core.dart';

class HarbrTableCard extends StatelessWidget {
  final String? title;
  final List<HarbrTableContent>? content;
  final List<HarbrButton>? buttons;

  const HarbrTableCard({
    Key? key,
    this.content,
    this.buttons,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrCard(
      context: context,
      child: Padding(
        child: _body(),
        padding: EdgeInsets.only(
          left: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
          right: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
          top: HarbrUI.DEFAULT_MARGIN_SIZE - HarbrUI.DEFAULT_MARGIN_SIZE / 4,
          bottom: buttons?.isEmpty ?? true
              ? HarbrUI.DEFAULT_MARGIN_SIZE - HarbrUI.DEFAULT_MARGIN_SIZE / 4
              : 0,
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        if (title?.isNotEmpty ?? false) _title(),
        ..._content(),
        _buttons(),
      ],
    );
  }

  Widget _title() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: HarbrUI.DEFAULT_MARGIN_SIZE),
          child: HarbrText.title(text: title!),
        ),
      ],
    );
  }

  List<Widget> _content() {
    return content!
        .map((child) => Padding(
              child: child,
              padding: const EdgeInsets.symmetric(
                horizontal: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
              ),
            ))
        .toList();
  }

  Widget _buttons() {
    if (buttons == null) return Container(height: 0.0);
    return Padding(
      child: Row(
        children:
            buttons!.map<Widget>((button) => Expanded(child: button)).toList(),
      ),
      padding: const EdgeInsets.only(
        top: HarbrUI.DEFAULT_MARGIN_SIZE / 2 - HarbrUI.DEFAULT_MARGIN_SIZE / 4,
        bottom: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
      ),
    );
  }
}
