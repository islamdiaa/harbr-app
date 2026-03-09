import 'package:harbr/core.dart';

Future<void> showHarbrErrorSnackBar({
  required String title,
  dynamic error,
  String? message,
  bool showButton = false,
  String buttonText = 'view',
  Function? buttonOnPressed,
}) async =>
    showHarbrSnackBar(
      title: title,
      message: message ?? HarbrLogger.checkLogsMessage,
      type: HarbrSnackbarType.ERROR,
      showButton: error != null || showButton,
      buttonText: buttonText,
      buttonOnPressed: () async {
        if (error != null) {
          HarbrDialogs().textPreview(
            HarbrState.context,
            'Error',
            error.toString(),
          );
        } else if (buttonOnPressed != null) {
          buttonOnPressed();
        }
      },
    );
