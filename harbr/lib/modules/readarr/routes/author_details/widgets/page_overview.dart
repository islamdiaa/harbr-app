import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/modules/readarr/routes/author_details/widgets/navigation_bar.dart';

class ReadarrAuthorDetailsOverviewPage extends StatefulWidget {
  final ReadarrAuthor author;
  final ReadarrQualityProfile? qualityProfile;
  final List<ReadarrTag> tags;

  const ReadarrAuthorDetailsOverviewPage({
    Key? key,
    required this.author,
    required this.qualityProfile,
    required this.tags,
  }) : super(key: key);

  @override
  State<ReadarrAuthorDetailsOverviewPage> createState() => _State();
}

class _State extends State<ReadarrAuthorDetailsOverviewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HarbrListView(
      controller: ReadarrAuthorDetailsNavigationBar.scrollControllers[0],
      children: [
        _informationBlock(),
        _descriptionBlock(),
      ],
    );
  }

  Widget _informationBlock() {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
          title: 'readarr.Path'.tr(),
          body: widget.author.path ?? HarbrUI.TEXT_EMDASH,
        ),
        HarbrTableContent(
          title: 'readarr.Quality'.tr(),
          body: widget.qualityProfile?.name ?? HarbrUI.TEXT_EMDASH,
        ),
        HarbrTableContent(
          title: 'readarr.Monitored'.tr(),
          body: widget.author.monitored! ? 'Yes' : 'No',
        ),
        HarbrTableContent(
          title: 'readarr.Books'.tr(),
          body: widget.author.harbrBookProgress,
        ),
        HarbrTableContent(
          title: 'readarr.Size'.tr(),
          body: widget.author.harbrSizeOnDisk,
        ),
        HarbrTableContent(
          title: 'readarr.Genres'.tr(),
          body: widget.author.harbrGenres,
        ),
        HarbrTableContent(
          title: 'readarr.DateAdded'.tr(),
          body: widget.author.harbrDateAdded,
        ),
        HarbrTableContent(
          title: 'readarr.Tags'.tr(),
          body: widget.author.harbrTags(widget.tags),
        ),
      ],
    );
  }

  Widget _descriptionBlock() {
    return HarbrBlock(
      title: 'readarr.Description'.tr(),
      body: [
        TextSpan(
          text: widget.author.harbrOverview,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
