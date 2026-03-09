import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harbr/core.dart';

class HarbrDialogs {
  /// Show an an edit text prompt.
  ///
  /// Can pass in [prefill] String to prefill the [TextFormField]. Can also pass in a list of [TextSpan] tp show text above the field.
  ///
  /// Returns list containing:
  /// - 0: Flag (true if they hit save, false if they cancelled the prompt)
  /// - 1: Value from the [TextEditingController].
  Future<Tuple2<bool, String>> editText(
      BuildContext context, String dialogTitle,
      {String prefill = '', List<TextSpan>? extraText}) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController()..text = prefill;

    void _setValues(bool flag) {
      if (_formKey.currentState?.validate() ?? false) {
        _flag = flag;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: dialogTitle,
      buttons: [
        HarbrDialog.button(
          text: 'Save',
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        if (extraText?.isNotEmpty ?? false)
          HarbrDialog.richText(children: extraText),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: dialogTitle,
            onSubmitted: (_) => _setValues(true),
            validator: (_) => null,
          ),
        ),
      ],
      contentPadding: (extraText?.length ?? 0) == 0
          ? HarbrDialog.inputDialogContentPadding()
          : HarbrDialog.inputTextDialogContentPadding(),
    );
    return Tuple2(_flag, _textController.text);
  }

  /// Show a text preview dialog.
  ///
  /// Can pass in boolean [alignLeft] to left align the text in the dialog (useful for bulleted lists)
  Future<void> textPreview(
      BuildContext context, String? dialogTitle, String text,
      {bool alignLeft = false}) async {
    await HarbrDialog.dialog(
      context: context,
      title: dialogTitle,
      cancelButtonText: 'Close',
      buttons: [
        HarbrDialog.button(
            text: 'Copy',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: text));
              showHarbrSuccessSnackBar(
                  title: 'Copied Content',
                  message: 'Copied text to the clipboard');
              Navigator.of(context, rootNavigator: true).pop();
            }),
      ],
      content: [
        HarbrDialog.textContent(text: text),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
  }

  Future<void> showRejections(
      BuildContext context, List<String> rejections) async {
    if (rejections.isEmpty)
      return textPreview(
        context,
        'Rejection Reasons',
        'No rejections found',
      );

    await HarbrDialog.dialog(
      context: context,
      title: 'Rejection Reasons',
      cancelButtonText: 'Close',
      content: List.generate(
        rejections.length,
        (index) => HarbrDialog.tile(
          text: rejections[index],
          icon: Icons.report_outlined,
          iconColor: HarbrColours.red,
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
  }

  Future<void> showMessages(BuildContext context, List<String> messages) async {
    if (messages.isEmpty) {
      return textPreview(context, 'Messages', 'No messages found');
    }
    await HarbrDialog.dialog(
      context: context,
      title: 'Messages',
      cancelButtonText: 'Close',
      content: List.generate(
        messages.length,
        (index) => HarbrDialog.tile(
          text: messages[index],
          icon: Icons.info_outline_rounded,
          iconColor: HarbrColours.accent,
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
  }

  /// **Will be removed in future**
  ///
  /// Show a delete catalogue with all files warning dialog.
  Future<List<dynamic>> deleteCatalogueWithFiles(
      BuildContext context, String moduleTitle) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Delete All Files',
      buttons: [
        HarbrDialog.button(
          text: 'Delete',
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
            text:
                'Are you sure you want to delete all the files and folders for $moduleTitle?'),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return [_flag];
  }

  Future<HarbrModule?> selectDownloadClient() async {
    final profile = HarbrProfile.current;
    final context = HarbrState.context;
    HarbrModule? module;

    await HarbrDialog.dialog(
      context: context,
      title: 'harbr.DownloadClient'.tr(),
      content: [
        if (profile.nzbgetEnabled)
          HarbrDialog.tile(
            text: HarbrModule.NZBGET.title,
            icon: HarbrModule.NZBGET.icon,
            iconColor: HarbrModule.NZBGET.color,
            onTap: () {
              module = HarbrModule.NZBGET;
              Navigator.of(context).pop();
            },
          ),
        if (profile.sabnzbdEnabled)
          HarbrDialog.tile(
            text: HarbrModule.SABNZBD.title,
            icon: HarbrModule.SABNZBD.icon,
            iconColor: HarbrModule.SABNZBD.color,
            onTap: () {
              module = HarbrModule.SABNZBD;
              Navigator.of(context).pop();
            },
          ),
      ],
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );

    return module;
  }
}
