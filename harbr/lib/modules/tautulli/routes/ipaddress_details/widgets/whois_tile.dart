import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/tautulli.dart';

class TautulliIPAddressDetailsWHOISTile extends StatelessWidget {
  final TautulliWHOISInfo whois;

  const TautulliIPAddressDetailsWHOISTile({
    Key? key,
    required this.whois,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrTableCard(
      content: [
        HarbrTableContent(title: 'host', body: whois.host ?? HarbrUI.TEXT_EMDASH),
        ..._subnets(),
      ],
    );
  }

  List<HarbrTableContent> _subnets() {
    if (whois.subnets?.isEmpty ?? true) return [];
    return whois.subnets!.fold<List<HarbrTableContent>>([], (list, subnet) {
      list.add(HarbrTableContent(
        title: 'isp',
        body: [
          subnet.description ?? HarbrUI.TEXT_EMDASH,
          '\n\n${subnet.address ?? HarbrUI.TEXT_EMDASH}',
          '\n${subnet.city}, ${subnet.state ?? HarbrUI.TEXT_EMDASH}',
          '\n${subnet.postalCode ?? HarbrUI.TEXT_EMDASH}',
          '\n${subnet.country ?? HarbrUI.TEXT_EMDASH}',
        ].join(),
      ));
      return list;
    });
  }
}
