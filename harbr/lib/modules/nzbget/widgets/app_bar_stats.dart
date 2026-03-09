import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/modules/nzbget.dart';

class NZBGetAppBarStats extends StatelessWidget {
  const NZBGetAppBarStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Selector<NZBGetState, Tuple5<bool, String, String, String, String>>(
        selector: (_, model) => Tuple5(
          model.paused, //item1
          model.currentSpeed, //item2
          model.queueTimeLeft, //item3
          model.queueSizeLeft, //item4
          model.speedLimit, //item5
        ),
        builder: (context, data, widget) => GestureDetector(
          onTap: () async => _onTap(context, data.item5),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: HarbrColours.grey,
                  fontSize: HarbrUI.FONT_SIZE_H3,
                ),
                children: [
                  TextSpan(
                    text: _status(data.item1, data.item2),
                    style: const TextStyle(
                      fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
                      fontSize: HarbrUI.FONT_SIZE_HEADER,
                      color: HarbrColours.accent,
                    ),
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(text: data.item3 == '0:00:00' ? '―' : data.item3),
                  TextSpan(text: HarbrUI.TEXT_BULLET.pad()),
                  TextSpan(text: data.item4 == '0.0 B' ? '―' : data.item4)
                ],
              ),
              overflow: TextOverflow.fade,
              maxLines: 2,
              softWrap: false,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      );

  String _status(bool paused, String speed) => paused
      ? 'Paused'
      : speed == '0.0 B/s'
          ? 'Idle'
          : speed;

  Future<void> _onTap(BuildContext context, String speed) async {
    HapticFeedback.lightImpact();
    List values = await NZBGetDialogs.speedLimit(context, speed);
    if (values[0])
      switch (values[1]) {
        case -1:
          {
            values = await NZBGetDialogs.customSpeedLimit(context);
            if (values[0])
              NZBGetAPI.from(HarbrProfile.current)
                  .setSpeedLimit(values[1])
                  .then((_) => showHarbrSuccessSnackBar(
                        title: 'Speed Limit Set',
                        message:
                            'Set to ${(values[1] as int?).asKilobytes(decimals: 0)}/s',
                      ))
                  .catchError((error) => showHarbrErrorSnackBar(
                        title: 'Failed to Set Speed Limit',
                        error: error,
                      ));
            break;
          }
        default:
          NZBGetAPI.from(HarbrProfile.current)
              .setSpeedLimit(values[1])
              .then((_) => showHarbrSuccessSnackBar(
                    title: 'Speed Limit Set',
                    message:
                        'Set to ${(values[1] as int?).asKilobytes(decimals: 0)}/s',
                  ))
              .catchError((error) => showHarbrErrorSnackBar(
                    title: 'Failed to Set Speed Limit',
                    error: error,
                  ));
      }
  }
}
