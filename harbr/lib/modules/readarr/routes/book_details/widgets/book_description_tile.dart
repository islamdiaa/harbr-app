import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrBookDescriptionTile extends StatelessWidget {
  final ReadarrBook book;

  const ReadarrBookDescriptionTile({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: 'readarr.Description'.tr(),
      body: [
        TextSpan(
          text: book.harbrOverview,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
