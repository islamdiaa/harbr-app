import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/extensions/string/links.dart';

enum _Type {
  CONTENT,
  SPACER,
}

class HarbrTableContent extends StatelessWidget {
  final String? title;
  final String? body;
  final String? url;
  final bool bodyIsUrl;
  final int titleFlex;
  final int bodyFlex;
  final double spacerSize;
  final TextAlign titleAlign;
  final TextAlign bodyAlign;
  final _Type type;

  const HarbrTableContent._({
    Key? key,
    this.title,
    this.body,
    this.url,
    this.bodyIsUrl = false,
    this.titleAlign = TextAlign.end,
    this.bodyAlign = TextAlign.start,
    this.titleFlex = 5,
    this.bodyFlex = 10,
    this.spacerSize = HarbrUI.DEFAULT_MARGIN_SIZE,
    required this.type,
  });

  factory HarbrTableContent.spacer({
    Key? key,
    double spacerSize = HarbrUI.DEFAULT_MARGIN_SIZE,
  }) =>
      HarbrTableContent._(
        key: key,
        type: _Type.SPACER,
        spacerSize: spacerSize,
      );

  factory HarbrTableContent({
    Key? key,
    String? title,
    required String? body,
    String? url,
    bool bodyIsUrl = false,
    TextAlign titleAlign = TextAlign.end,
    TextAlign bodyAlign = TextAlign.start,
    int titleFlex = 1,
    int bodyFlex = 2,
  }) =>
      HarbrTableContent._(
        key: key,
        title: title,
        body: body,
        url: url,
        bodyIsUrl: bodyIsUrl,
        titleAlign: titleAlign,
        bodyAlign: bodyAlign,
        titleFlex: titleFlex,
        bodyFlex: bodyFlex,
        type: _Type.CONTENT,
      );

  @override
  Widget build(BuildContext context) {
    if (type == _Type.SPACER) return SizedBox(height: spacerSize);
    return Row(
      children: [
        if (title != null) _title(),
        _subtitle(),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _title() {
    return Expanded(
      child: Padding(
        child: Text(
          title?.toUpperCase() ?? HarbrUI.TEXT_EMDASH,
          textAlign: titleAlign,
          style: const TextStyle(
            color: HarbrColours.grey,
            fontSize: HarbrUI.FONT_SIZE_H3,
          ),
        ),
        padding: const EdgeInsets.only(
          top: HarbrUI.DEFAULT_MARGIN_SIZE / 4,
          bottom: HarbrUI.DEFAULT_MARGIN_SIZE / 4,
          right: HarbrUI.DEFAULT_MARGIN_SIZE / 4,
        ),
      ),
      flex: titleFlex,
    );
  }

  Widget _subtitle() {
    return Expanded(
      child: InkWell(
        child: Padding(
          child: Text(
            body ?? HarbrUI.TEXT_EMDASH,
            textAlign: bodyAlign,
            style: const TextStyle(
              color: HarbrColours.white,
              fontSize: HarbrUI.FONT_SIZE_H3,
            ),
          ),
          padding: const EdgeInsets.only(
            top: HarbrUI.DEFAULT_MARGIN_SIZE / 4,
            bottom: HarbrUI.DEFAULT_MARGIN_SIZE / 4,
            left: HarbrUI.DEFAULT_MARGIN_SIZE / 2,
          ),
        ),
        borderRadius: BorderRadius.circular(HarbrUI.BORDER_RADIUS),
        onTap: _onTap(),
        onLongPress: _onLongPress(),
      ),
      flex: bodyFlex,
    );
  }

  void Function()? _onTap() {
    final sanitizedUrl = url ?? '';
    if (sanitizedUrl.isEmpty && !bodyIsUrl) return null;
    if (sanitizedUrl.isNotEmpty) return sanitizedUrl.openLink;
    return body!.openLink;
  }

  void Function()? _onLongPress() {
    final sanitizedUrl = url ?? '';
    if (sanitizedUrl.isEmpty && !bodyIsUrl) return null;
    if (sanitizedUrl.isNotEmpty) return sanitizedUrl.copyToClipboard;
    return body!.copyToClipboard;
  }
}
