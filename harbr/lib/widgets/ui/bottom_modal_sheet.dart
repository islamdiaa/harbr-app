import 'package:flutter/material.dart';
import 'package:harbr/system/state.dart';
import 'package:harbr/widgets/ui.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HarbrBottomModalSheet<T> {
  @protected
  Future<T?> showModal({
    Widget Function(BuildContext context)? builder,
  }) async {
    return showBarModalBottomSheet<T>(
      context: HarbrState.context,
      expand: false,
      backgroundColor:
          HarbrTheme.isAMOLEDTheme ? Colors.black : HarbrColors.surface0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: builder ?? this.builder as Widget Function(BuildContext),
      closeProgressThreshold: 0.90,
      elevation: HarbrUI.ELEVATION,
      overlayStyle: HarbrTheme().overlayStyle,
    );
  }

  Widget? builder(BuildContext context) => null;

  Future<dynamic> show({
    Widget Function(BuildContext context)? builder,
  }) async =>
      showModal(builder: builder);
}
