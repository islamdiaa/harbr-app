import 'package:harbr/extensions/string/string.dart';
import 'package:harbr/core.dart';

Future<void> showHarbrSuccessSnackBar({
  required String title,
  required String? message,
  bool showButton = false,
  String buttonText = 'view',
  Function? buttonOnPressed,
}) async =>
    showHarbrSnackBar(
      title: title,
      message: message.uiSafe(),
      type: HarbrSnackbarType.SUCCESS,
      showButton: showButton,
      buttonText: buttonText,
      buttonOnPressed: buttonOnPressed,
    );
