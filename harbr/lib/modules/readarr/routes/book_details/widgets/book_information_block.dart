import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrBookInformationBlock extends StatelessWidget {
  final ReadarrBook book;

  const ReadarrBookInformationBlock({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
          title: 'readarr.Author'.tr(),
          body: book.harbrAuthorTitle,
        ),
        HarbrTableContent(
          title: 'readarr.Status'.tr(),
          body: book.harbrFileStatus,
        ),
        HarbrTableContent(
          title: 'readarr.SizeOnDisk'.tr(),
          body: book.harbrSizeOnDisk,
        ),
        HarbrTableContent(
          title: 'readarr.ReleaseDate'.tr(),
          body: book.harbrReleaseDate,
        ),
        HarbrTableContent(
          title: 'readarr.Pages'.tr(),
          body: book.harbrPageCount,
        ),
        HarbrTableContent(
          title: 'readarr.Genres'.tr(),
          body: book.harbrGenres,
        ),
        HarbrTableContent(
          title: 'readarr.Monitored'.tr(),
          body: book.harbrIsMonitored ? 'Yes' : 'No',
        ),
        HarbrTableContent(
          title: 'readarr.AddedOn'.tr(),
          body: book.harbrDateAdded,
        ),
        HarbrTableContent(
          title: 'readarr.Editions'.tr(),
          body: book.harbrEditionCount,
        ),
      ],
    );
  }
}
