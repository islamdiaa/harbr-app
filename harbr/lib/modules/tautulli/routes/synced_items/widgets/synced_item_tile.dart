import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/tautulli.dart';
import 'package:harbr/router/routes/tautulli.dart';

class TautulliSyncedItemTile extends StatelessWidget {
  final TautulliSyncedItem syncedItem;

  const TautulliSyncedItemTile({
    Key? key,
    required this.syncedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HarbrBlock(
      title: syncedItem.syncTitle,
      body: [
        _subtitle1(),
        _subtitle2(),
        _subtitle3(),
      ],
      backgroundHeaders: context.watch<TautulliState>().headers,
      backgroundUrl: context.watch<TautulliState>().getImageURLFromRatingKey(
            syncedItem.ratingKey,
            width: MediaQuery.of(context).size.width.truncate(),
          ),
      posterHeaders: context.watch<TautulliState>().headers,
      posterUrl: context.watch<TautulliState>().getImageURLFromRatingKey(
            syncedItem.ratingKey,
            width: MediaQuery.of(context).size.width.truncate(),
          ),
      posterPlaceholderIcon: HarbrIcons.VIDEO_CAM,
      onTap: () async => _onTap(context),
    );
  }

  TextSpan _subtitle1() {
    int _count = syncedItem.itemCompleteCount ?? 0;
    int _size = syncedItem.totalSize ?? 0;
    String _type = syncedItem.metadataType ?? 'harbr.Unknown'.tr();

    return TextSpan(
      children: [
        TextSpan(text: _type.toTitleCase()),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: _count == 1 ? '1 Item' : '$_count Items'),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: _size.asBytes(decimals: 1)),
      ],
    );
  }

  TextSpan _subtitle2() {
    return TextSpan(
      children: [
        TextSpan(text: syncedItem.user ?? 'Unknown User'),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: syncedItem.deviceName ?? 'Unknown Device'),
        TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
        TextSpan(text: syncedItem.platform ?? 'Unknown Platform'),
      ],
    );
  }

  TextSpan _subtitle3() {
    String _state = syncedItem.state ?? 'harbr.Unknown'.tr();
    return TextSpan(
      text: _state.toTitleCase(),
      style: const TextStyle(
        color: HarbrColours.accent,
        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
      ),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    TautulliRoutes.MEDIA_DETAILS.go(params: {
      'rating_key': syncedItem.ratingKey.toString(),
      'media_type': TautulliMediaType.from(syncedItem.metadataType).value,
    });
  }
}
