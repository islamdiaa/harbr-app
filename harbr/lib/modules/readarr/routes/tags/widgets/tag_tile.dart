import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrTagsTile extends StatefulWidget {
  final ReadarrTag tag;

  const ReadarrTagsTile({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  State<ReadarrTagsTile> createState() => _State();
}

class _State extends State<ReadarrTagsTile> with HarbrLoadCallbackMixin {
  List<String?>? authorList;

  @override
  Future<void> loadCallback() async {
    await context.read<ReadarrState>().authors!.then((authors) {
      List<String?> _authors = [];
      authors.values.forEach((element) {
        if (element.tags!.contains(widget.tag.id))
          _authors.add(element.authorName);
      });
      _authors.sort();
      if (mounted)
        setState(() {
          authorList = _authors;
        });
    }).catchError((error) {
      if (mounted)
        setState(() {
          authorList = null;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: widget.tag.label,
      body: [TextSpan(text: subtitle())],
      trailing: (authorList?.isNotEmpty ?? true)
          ? null
          : HarbrIconButton(
              icon: HarbrIcons.DELETE,
              color: HarbrColours.red,
              onPressed: _handleDelete,
            ),
      onTap: _handleInfo,
    );
  }

  String subtitle() {
    if (authorList == null) return 'Loading...';
    if (authorList!.isEmpty) return 'No Authors';
    return '${authorList!.length} Authors';
  }

  Future<void> _handleInfo() async {
    return HarbrDialogs().textPreview(
      context,
      'Author List',
      (authorList?.isEmpty ?? true)
          ? 'No Authors'
          : authorList!.join('\n'),
    );
  }

  Future<void> _handleDelete() async {
    if (authorList?.isNotEmpty ?? true) {
      showHarbrErrorSnackBar(
        title: 'Cannot Delete Tag',
        message: 'The tag must not be attached to any authors',
      );
    } else {
      bool result = await ReadarrDialogs().deleteTag(context);
      if (result)
        context
            .read<ReadarrState>()
            .api!
            .tag
            .delete(id: widget.tag.id!)
            .then((_) {
          showHarbrSuccessSnackBar(
            title: 'Deleted Tag',
            message: widget.tag.label,
          );
          context.read<ReadarrState>().fetchTags();
        }).catchError((error, stack) {
          HarbrLogger().error(
            'Failed to delete tag: ${widget.tag.id}',
            error,
            stack,
          );
          showHarbrErrorSnackBar(
            title: 'Failed to Delete Tag',
            error: error,
          );
        });
    }
  }
}
