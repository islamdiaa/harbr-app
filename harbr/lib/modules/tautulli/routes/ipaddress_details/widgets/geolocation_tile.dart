import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliIPAddressDetailsGeolocationTile extends StatelessWidget {
  final TautulliGeolocationInfo geolocation;

  const TautulliIPAddressDetailsGeolocationTile({
    Key? key,
    required this.geolocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(
            title: 'country', body: geolocation.country ?? HarbrUI.TEXT_EMDASH),
        HarbrTableContent(
            title: 'region', body: geolocation.region ?? HarbrUI.TEXT_EMDASH),
        HarbrTableContent(
            title: 'city', body: geolocation.city ?? HarbrUI.TEXT_EMDASH),
        HarbrTableContent(
            title: 'postal',
            body: geolocation.postalCode ?? HarbrUI.TEXT_EMDASH),
        HarbrTableContent(
            title: 'timezone',
            body: geolocation.timezone ?? HarbrUI.TEXT_EMDASH),
        HarbrTableContent(
            title: 'latitude',
            body: '${geolocation.latitude ?? HarbrUI.TEXT_EMDASH}'),
        HarbrTableContent(
            title: 'longitude',
            body: '${geolocation.longitude ?? HarbrUI.TEXT_EMDASH}'),
      ],
    );
  }
}
