import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/radarr.dart';
import 'package:harbr/modules/settings.dart';
import 'package:harbr/types/list_view_option.dart';

class ConfigurationRadarrDefaultOptionsRoute extends StatefulWidget {
  const ConfigurationRadarrDefaultOptionsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationRadarrDefaultOptionsRoute> createState() => _State();
}

class _State extends State<ConfigurationRadarrDefaultOptionsRoute>
    with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HarbrScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'settings.DefaultOptions'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return HarbrListView(
      controller: scrollController,
      children: [
        HarbrHeader(text: 'radarr.Movies'.tr()),
        _filteringMovies(),
        _sortingMovies(),
        _sortingMoviesDirection(),
        _viewMovies(),
        HarbrHeader(text: 'radarr.Releases'.tr()),
        _filteringReleases(),
        _sortingReleases(),
        _sortingReleasesDirection(),
      ],
    );
  }

  Widget _viewMovies() {
    const _db = RadarrDatabase.DEFAULT_VIEW_MOVIES;
    return _db.listenableBuilder(
      builder: (context, _) {
        return HarbrBlock(
          title: 'harbr.View'.tr(),
          body: [TextSpan(text: _db.read().readable)],
          trailing: const HarbrIconButton.arrow(),
          onTap: () async {
            List<String> titles = HarbrListViewOption.values
                .map<String>((view) => view.readable)
                .toList();
            List<IconData> icons = HarbrListViewOption.values
                .map<IconData>((view) => view.icon)
                .toList();

            Tuple2<bool, int> values = await SettingsDialogs().setDefaultOption(
              context,
              title: 'harbr.View'.tr(),
              values: titles,
              icons: icons,
            );

            if (values.item1) {
              HarbrListViewOption _opt = HarbrListViewOption.values[values.item2];
              context.read<RadarrState>().moviesViewType = _opt;
              _db.update(_opt);
            }
          },
        );
      },
    );
  }

  Widget _sortingMovies() {
    const _db = RadarrDatabase.DEFAULT_SORTING_MOVIES;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.SortCategory'.tr(),
        body: [TextSpan(text: _db.read().readable)],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          List<String> titles = RadarrMoviesSorting.values
              .map<String>((sorting) => sorting.readable)
              .toList();
          List<IconData> icons = List.filled(titles.length, HarbrIcons.SORT);

          Tuple2<bool, int> values = await SettingsDialogs().setDefaultOption(
            context,
            title: 'settings.SortCategory'.tr(),
            values: titles,
            icons: icons,
          );

          if (values.item1) {
            _db.update(RadarrMoviesSorting.values[values.item2]);
            context.read<RadarrState>().moviesSortType = _db.read();
            context.read<RadarrState>().moviesSortAscending =
                RadarrDatabase.DEFAULT_SORTING_MOVIES_ASCENDING.read();
          }
        },
      ),
    );
  }

  Widget _sortingMoviesDirection() {
    const _db = RadarrDatabase.DEFAULT_SORTING_MOVIES_ASCENDING;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.SortDirection'.tr(),
        body: [
          TextSpan(
            text: _db.read()
                ? 'harbr.Ascending'.tr()
                : 'harbr.Descending'.tr(),
          ),
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: (value) {
            _db.update(value);
            context.read<RadarrState>().moviesSortType =
                RadarrDatabase.DEFAULT_SORTING_MOVIES.read();
            context.read<RadarrState>().moviesSortAscending = _db.read();
          },
        ),
      ),
    );
  }

  Widget _filteringMovies() {
    const _db = RadarrDatabase.DEFAULT_FILTERING_MOVIES;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.FilterCategory'.tr(),
        body: [TextSpan(text: _db.read().readable)],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          List<String?> titles = RadarrMoviesFilter.values
              .map<String?>((filter) => filter.readable)
              .toList();
          List<IconData> icons = List.filled(titles.length, HarbrIcons.FILTER);

          Tuple2<bool, int> values = await SettingsDialogs().setDefaultOption(
            context,
            title: 'settings.FilterCategory'.tr(),
            values: titles,
            icons: icons,
          );

          if (values.item1) {
            _db.update(RadarrMoviesFilter.values[values.item2]);
            context.read<RadarrState>().moviesFilterType = _db.read();
          }
        },
      ),
    );
  }

  Widget _sortingReleases() {
    const _db = RadarrDatabase.DEFAULT_SORTING_RELEASES;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.SortCategory'.tr(),
        body: [TextSpan(text: _db.read().readable)],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          List<String?> titles = RadarrReleasesSorting.values
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
            _db.update(RadarrReleasesSorting.values[values.item2]);
          }
        },
      ),
    );
  }

  Widget _sortingReleasesDirection() {
    const _db = RadarrDatabase.DEFAULT_SORTING_RELEASES_ASCENDING;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.SortDirection'.tr(),
        body: [
          TextSpan(
            text: _db.read()
                ? 'harbr.Ascending'.tr()
                : 'harbr.Descending'.tr(),
          ),
        ],
        trailing: HarbrSwitch(
          value: _db.read(),
          onChanged: (value) => _db.update(value),
        ),
      ),
    );
  }

  Widget _filteringReleases() {
    const _db = RadarrDatabase.DEFAULT_FILTERING_RELEASES;
    return _db.listenableBuilder(
      builder: (context, _) => HarbrBlock(
        title: 'settings.FilterCategory'.tr(),
        body: [TextSpan(text: _db.read().readable)],
        trailing: const HarbrIconButton.arrow(),
        onTap: () async {
          List<String?> titles = RadarrReleasesFilter.values
              .map<String?>((sorting) => sorting.readable)
              .toList();
          List<IconData> icons = List.filled(titles.length, HarbrIcons.FILTER);

          Tuple2<bool, int> values = await SettingsDialogs().setDefaultOption(
            context,
            title: 'settings.FilterCategory'.tr(),
            values: titles,
            icons: icons,
          );

          if (values.item1) {
            _db.update(RadarrReleasesFilter.values[values.item2]);
          }
        },
      ),
    );
  }
}
