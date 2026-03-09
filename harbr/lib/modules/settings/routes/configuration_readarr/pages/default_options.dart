import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/modules/readarr.dart';
import 'package:harbr/types/list_view_option.dart';

class ConfigurationReadarrDefaultOptionsRoute extends StatefulWidget {
  const ConfigurationReadarrDefaultOptionsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationReadarrDefaultOptionsRoute> createState() => _State();
}

class _State extends State<ConfigurationReadarrDefaultOptionsRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return HarbrAppBar(
      title: 'settings.DefaultOptions'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrHeader(text: 'readarr.Authors'.tr()),
        _filteringAuthors(),
        _sortingAuthors(),
        _sortingAuthorsDirection(),
        _viewAuthors(),
      ],
    );
  }

  Widget _viewAuthors() {
    const _db = ReadarrDatabase.NAVIGATION_INDEX;
    return _db.listenableBuilder(
      builder: (context, _) {
        HarbrListViewOption _view = _db.read() == 0
            ? HarbrListViewOption.GRID_VIEW
            : HarbrListViewOption.BLOCK_VIEW;
        return HarbrBlock(
          title: 'harbr.View'.tr(),
          body: [TextSpan(text: _view.readable)],
          trailing: const HarbrIconButton.arrow(),
          onTap: () async {
            List<String> titles = HarbrListViewOption.values
                .map<String>((view) => view.readable)
                .toList();
            List<IconData> icons = HarbrListViewOption.values
                .map<IconData>((view) => view.icon)
                .toList();

            Tuple2<bool, int> values =
                await SettingsDialogs().setDefaultOption(
              context,
              title: 'harbr.View'.tr(),
              values: titles,
              icons: icons,
            );

            if (values.item1) {
              HarbrListViewOption _opt =
                  HarbrListViewOption.values[values.item2];
              context.read<ReadarrState>().authorViewType = _opt;
            }
          },
        );
      },
    );
  }

  Widget _sortingAuthors() {
    return HarbrBlock(
      title: 'settings.SortCategory'.tr(),
      body: [
        TextSpan(
          text: context.read<ReadarrState>().sortType.readable,
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        List<String?> titles = ReadarrBooksSorting.values
            .map<String?>((sorting) => sorting.readable)
            .toList();
        List<IconData> icons = List.filled(titles.length, HarbrIcons.SORT);

        Tuple2<bool, int> values = await SettingsDialogs().setDefaultOption(
          context,
          title: 'settings.SortCategory'.tr(),
          values: titles,
          icons: icons,
        );

        if (values.item1) {
          context.read<ReadarrState>().sortType =
              ReadarrBooksSorting.values[values.item2];
        }
      },
    );
  }

  Widget _sortingAuthorsDirection() {
    return HarbrBlock(
      title: 'settings.SortDirection'.tr(),
      body: [
        TextSpan(
          text: context.read<ReadarrState>().sortAscending
              ? 'harbr.Ascending'.tr()
              : 'harbr.Descending'.tr(),
        ),
      ],
      trailing: HarbrSwitch(
        value: context.read<ReadarrState>().sortAscending,
        onChanged: (value) {
          context.read<ReadarrState>().sortAscending = value;
        },
      ),
    );
  }

  Widget _filteringAuthors() {
    return HarbrBlock(
      title: 'settings.FilterCategory'.tr(),
      body: [
        TextSpan(
          text: context.read<ReadarrState>().filterType.readable,
        ),
      ],
      trailing: const HarbrIconButton.arrow(),
      onTap: () async {
        List<String> titles = ReadarrBooksFilter.values
            .map<String>((filter) => filter.readable)
            .toList();
        List<IconData> icons = List.filled(titles.length, HarbrIcons.FILTER);

        Tuple2<bool, int> values = await SettingsDialogs().setDefaultOption(
          context,
          title: 'settings.FilterCategory'.tr(),
          values: titles,
          icons: icons,
        );

        if (values.item1) {
          context.read<ReadarrState>().filterType =
              ReadarrBooksFilter.values[values.item2];
        }
      },
    );
  }
}
