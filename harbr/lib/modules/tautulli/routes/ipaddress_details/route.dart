import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class IPDetailsRoute extends StatefulWidget {
  final String? ipAddress;

  const IPDetailsRoute({
    Key? key,
    required this.ipAddress,
  }) : super(key: key);

  @override
  State<IPDetailsRoute> createState() => _State();
}

class _State extends State<IPDetailsRoute> with HarbrScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TautulliIPAddressDetailsState(context, widget.ipAddress),
      builder: (context, _) => HarbrScaffold(
        scaffoldKey: _scaffoldKey,
        appBar: _appBar() as PreferredSizeWidget?,
        body: _body(context),
      ),
    );
  }

  Widget _appBar() {
    return HarbrAppBar(
      title: 'IP Address Details',
      scrollControllers: [scrollController],
    );
  }

  Widget _body(BuildContext context) {
    return HarbrRefreshIndicator(
      context: context,
      key: _refreshKey,
      onRefresh: () async =>
          context.read<TautulliIPAddressDetailsState>().fetchAll(context),
      child: FutureBuilder(
        future: Future.wait([
          context.watch<TautulliIPAddressDetailsState>().geolocation!,
          context.watch<TautulliIPAddressDetailsState>().whois!,
        ]),
        builder: (context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.hasError) {
            if (snapshot.connectionState != ConnectionState.waiting)
              HarbrLogger().error(
                'Unable to fetch Tautulli IP address information',
                snapshot.error,
                snapshot.stackTrace,
              );
            return HarbrMessage.error(onTap: _refreshKey.currentState!.show);
          }
          if (snapshot.hasData)
            return _list(snapshot.data![0] as TautulliGeolocationInfo,
                snapshot.data![1] as TautulliWHOISInfo);
          return const HarbrLoader();
        },
      ),
    );
  }

  Widget _list(TautulliGeolocationInfo geolocation, TautulliWHOISInfo whois) {
    return HarbrListView(
      controller: scrollController,
      children: [
        const HarbrHeader(text: 'Location'),
        TautulliIPAddressDetailsGeolocationTile(geolocation: geolocation),
        const HarbrHeader(text: 'Connection'),
        TautulliIPAddressDetailsWHOISTile(whois: whois),
      ],
    );
  }
}
