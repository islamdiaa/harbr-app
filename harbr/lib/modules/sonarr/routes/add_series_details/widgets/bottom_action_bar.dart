import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/sonarr.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes/sonarr.dart';

class SonarrAddSeriesDetailsActionBar extends StatelessWidget {
  const SonarrAddSeriesDetailsActionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBottomActionBar(
      actions: [
        HarbrActionBarCard(
          title: 'harbr.Options'.tr(),
          subtitle: 'sonarr.StartSearchFor'.tr(),
          onTap: () async => SonarrDialogs().addSeriesOptions(context),
        ),
        HarbrButton(
          type: HarbrButtonType.TEXT,
          text: 'harbr.Add'.tr(),
          icon: Icons.add_rounded,
          onTap: () async => _onTap(context),
          loadingState: context.watch<SonarrSeriesAddDetailsState>().state,
        ),
      ],
    );
  }

  Future<void> _onTap(BuildContext context) async {
    if (context.read<SonarrSeriesAddDetailsState>().canExecuteAction) {
      context.read<SonarrSeriesAddDetailsState>().state =
          HarbrLoadingState.ACTIVE;
      SonarrSeriesAddDetailsState _state =
          context.read<SonarrSeriesAddDetailsState>();
      await SonarrAPIController()
          .addSeries(
        context: context,
        series: _state.series,
        qualityProfile: _state.qualityProfile,
        languageProfile: _state.languageProfile,
        rootFolder: _state.rootFolder,
        seasonFolder: _state.useSeasonFolders,
        tags: _state.tags,
        seriesType: _state.seriesType,
        monitorType: _state.monitorType,
      )
          .then((series) async {
        context.read<SonarrState>().fetchAllSeries();
        context.read<SonarrSeriesAddDetailsState>().series.id = series!.id;

        HarbrRouter.router.pop();
        SonarrRoutes.SERIES.go(params: {
          'series': series.id!.toString(),
        });
      }).catchError((error, stack) {
        context.read<SonarrSeriesAddDetailsState>().state =
            HarbrLoadingState.ERROR;
      });
      context.read<SonarrSeriesAddDetailsState>().state =
          HarbrLoadingState.INACTIVE;
    }
  }
}
