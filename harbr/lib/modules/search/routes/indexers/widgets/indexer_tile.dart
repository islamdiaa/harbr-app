import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/database/models/indexer.dart';
import 'package:harbr/modules/search.dart';
import 'package:harbr/router/routes/search.dart';

class SearchIndexerTile extends StatelessWidget {
  final HarbrIndexer? indexer;

  const SearchIndexerTile({
    Key? key,
    required this.indexer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: indexer!.displayName,
      body: [TextSpan(text: indexer!.host)],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        context.read<SearchState>().indexer = indexer!;
        SearchRoutes.CATEGORIES.go();
      },
    );
  }
}
