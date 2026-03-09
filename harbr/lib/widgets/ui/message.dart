import 'package:flutter/material.dart';
import 'package:harbr/modules.dart';
import 'package:harbr/router/router.dart';
import 'package:harbr/router/routes/dashboard.dart';
import 'package:harbr/vendor.dart';
import 'package:harbr/widgets/ui.dart';

class HarbrMessage extends StatelessWidget {
  final String text;
  final Color textColor;
  final String? buttonText;
  final Function? onTap;
  final bool useSafeArea;

  const HarbrMessage({
    Key? key,
    required this.text,
    this.textColor = Colors.white,
    this.buttonText,
    this.onTap,
    this.useSafeArea = true,
  }) : super(key: key);

  /// Return a message that is meant to be shown within a [ListView].
  factory HarbrMessage.inList({
    Key? key,
    required String text,
    bool useSafeArea = false,
  }) {
    return HarbrMessage(
      key: key,
      text: text,
      useSafeArea: useSafeArea,
    );
  }

  /// Returns a centered message with a simple message, with a button to pop out of the route.
  factory HarbrMessage.goBack({
    Key? key,
    required String text,
    required BuildContext context,
    bool useSafeArea = true,
  }) {
    return HarbrMessage(
      key: key,
      text: text,
      buttonText: 'harbr.GoBack'.tr(),
      onTap: () {
        if (HarbrRouter.router.canPop()) {
          HarbrRouter.router.pop();
        } else {
          HarbrRouter.router.pushReplacement(DashboardRoutes.HOME.path);
        }
      },
      useSafeArea: useSafeArea,
    );
  }

  /// Return a pre-structured "An Error Has Occurred" message, with a "Try Again" button shown.
  factory HarbrMessage.error({
    Key? key,
    required Function onTap,
    bool useSafeArea = true,
  }) {
    return HarbrMessage(
      key: key,
      text: 'harbr.AnErrorHasOccurred'.tr(),
      buttonText: 'harbr.TryAgain'.tr(),
      onTap: onTap,
      useSafeArea: useSafeArea,
    );
  }

  /// Return a pre-structured "<module> Is Not Enabled" message, with a "Return to Dashboard" button shown.
  factory HarbrMessage.moduleNotEnabled({
    Key? key,
    required BuildContext context,
    required String module,
    bool useSafeArea = true,
  }) {
    return HarbrMessage(
      key: key,
      text: 'harbr.ModuleIsNotEnabled'.tr(args: [module]),
      buttonText: 'harbr.ReturnToDashboard'.tr(),
      onTap: HarbrModule.DASHBOARD.launch,
      useSafeArea: useSafeArea,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: useSafeArea,
      left: useSafeArea,
      right: useSafeArea,
      bottom: useSafeArea,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            margin: HarbrUI.MARGIN_H_DEFAULT_V_HALF,
            elevation: HarbrUI.ELEVATION,
            shape: HarbrUI.shapeBorder,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: HarbrUI.FONT_WEIGHT_BOLD,
                        fontSize: HarbrUI.FONT_SIZE_MESSAGES,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 12.0),
                  ),
                ),
              ],
            ),
          ),
          if (buttonText != null)
            HarbrButtonContainer(
              children: [
                HarbrButton.text(
                  text: buttonText!,
                  icon: null,
                  onTap: onTap,
                  color: Colors.white,
                  backgroundColor: HarbrColours.accent,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
