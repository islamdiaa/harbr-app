import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/extensions/int/bytes.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrDialogs {
  String _qualityProfileDisplayName(String name) {
    if (name.toLowerCase() == 'spoken') return 'Audiobook';
    return name;
  }

  Future<bool> confirmDeleteAuthor(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'readarr.RemoveAuthor'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Remove'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        ReadarrDatabase.REMOVE_AUTHOR_DELETE_FILES.listenableBuilder(
          builder: (context, _) => HarbrDialog.checkbox(
            title: 'readarr.DeleteFiles'.tr(),
            value: ReadarrDatabase.REMOVE_AUTHOR_DELETE_FILES.read(),
            onChanged: (value) =>
                ReadarrDatabase.REMOVE_AUTHOR_DELETE_FILES.update(value!),
          ),
        ),
      ],
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return _flag;
  }

  Future<bool> confirmDeleteBook(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'readarr.RemoveBook'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Remove'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
            text: 'readarr.RemoveBookHint'.tr()),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<Tuple2<bool, int>> setQueuePageSize(BuildContext context) async {
    bool _flag = false;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _textController = TextEditingController(
      text: ReadarrDatabase.QUEUE_PAGE_SIZE.read().toString(),
    );

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Queue Size',
      buttons: [
        HarbrDialog.button(
          text: 'Set',
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
            text: 'Set the amount of items fetched for the queue.'),
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'Queue Page Size',
            onSubmitted: (_) => _setValues(true),
            validator: (value) {
              int? _value = int.tryParse(value!);
              if (_value != null && _value >= 1) return null;
              return 'Minimum of 1 Item';
            },
            keyboardType: TextInputType.number,
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputTextDialogContentPadding(),
    );

    return Tuple2(_flag, int.tryParse(_textController.text) ?? 50);
  }

  Future<bool> searchAllMissingBooks(
    BuildContext context,
  ) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'readarr.MissingBooks'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'readarr.Search'.tr(),
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
          text: 'readarr.MissingBooksHint'.tr(),
        ),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<bool> removeFromQueue(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'readarr.RemoveFromQueue'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Remove'.tr(),
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        ReadarrDatabase.QUEUE_REMOVE_FROM_CLIENT.listenableBuilder(
          builder: (context, _) => HarbrDialog.checkbox(
            title: 'readarr.RemoveFromClient'.tr(),
            value: ReadarrDatabase.QUEUE_REMOVE_FROM_CLIENT.read(),
            onChanged: (selected) =>
                ReadarrDatabase.QUEUE_REMOVE_FROM_CLIENT.update(selected!),
          ),
        ),
        ReadarrDatabase.QUEUE_BLOCKLIST.listenableBuilder(
          builder: (context, _) => HarbrDialog.checkbox(
            title: 'readarr.AddToBlocklist'.tr(),
            value: ReadarrDatabase.QUEUE_BLOCKLIST.read(),
            onChanged: (selected) =>
                ReadarrDatabase.QUEUE_BLOCKLIST.update(selected!),
          ),
        ),
      ],
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return _flag;
  }

  Future<void> addBookOptions(BuildContext context) async {
    await HarbrDialog.dialog(
      context: context,
      title: 'harbr.Options'.tr(),
      buttons: [
        HarbrDialog.button(
          text: 'harbr.Close'.tr(),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ],
      showCancelButton: false,
      content: [
        ReadarrDatabase.ADD_BOOK_SEARCH_FOR_MISSING.listenableBuilder(
          builder: (context, _) => HarbrDialog.checkbox(
            title: 'readarr.StartSearchForMissingBook'.tr(),
            value: ReadarrDatabase.ADD_BOOK_SEARCH_FOR_MISSING.read(),
            onChanged: (value) =>
                ReadarrDatabase.ADD_BOOK_SEARCH_FOR_MISSING.update(value!),
          ),
        ),
      ],
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
  }

  Future<Tuple2<bool, String>> addNewTag(BuildContext context) async {
    bool _flag = false;
    final _formKey = GlobalKey<FormState>();
    final _textController = TextEditingController();

    void _setValues(bool flag) {
      if (_formKey.currentState!.validate()) {
        _flag = flag;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Add Tag',
      buttons: [
        HarbrDialog.button(
          text: 'Add',
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        Form(
          key: _formKey,
          child: HarbrDialog.textFormInput(
            controller: _textController,
            title: 'Tag Label',
            onSubmitted: (_) => _setValues(true),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Label cannot be empty';
              return null;
            },
          ),
        ),
      ],
      contentPadding: HarbrDialog.inputDialogContentPadding(),
    );
    return Tuple2(_flag, _textController.text);
  }

  Future<bool> deleteTag(BuildContext context) async {
    bool _flag = false;

    void _setValues(bool flag) {
      _flag = flag;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Delete Tag',
      buttons: [
        HarbrDialog.button(
          text: 'Delete',
          textColor: HarbrColours.red,
          onPressed: () => _setValues(true),
        ),
      ],
      content: [
        HarbrDialog.textContent(
            text: 'Are you sure you want to delete this tag?'),
      ],
      contentPadding: HarbrDialog.textDialogContentPadding(),
    );
    return _flag;
  }

  Future<Tuple2<bool, ReadarrQualityProfile?>> editQualityProfile(
      BuildContext context, List<ReadarrQualityProfile?> profiles) async {
    bool _flag = false;
    ReadarrQualityProfile? profile;

    void _setValues(bool flag, ReadarrQualityProfile? value) {
      _flag = flag;
      profile = value;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Quality Profile',
      content: List.generate(
        profiles.length,
        (index) => HarbrDialog.tile(
          text: _qualityProfileDisplayName(profiles[index]!.name!),
          icon: Icons.portrait_rounded,
          iconColor: HarbrColours().byListIndex(index),
          onTap: () => _setValues(true, profiles[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, profile);
  }

  Future<Tuple2<bool, ReadarrMetadataProfile?>> editMetadataProfile(
      BuildContext context, List<ReadarrMetadataProfile?> profiles) async {
    bool _flag = false;
    ReadarrMetadataProfile? profile;

    void _setValues(bool flag, ReadarrMetadataProfile? value) {
      _flag = flag;
      profile = value;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Metadata Profile',
      content: List.generate(
        profiles.length,
        (index) => HarbrDialog.tile(
          text: profiles[index]!.name!,
          icon: Icons.portrait_rounded,
          iconColor: HarbrColours().byListIndex(index),
          onTap: () => _setValues(true, profiles[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, profile);
  }

  Future<Tuple2<bool, ReadarrRootFolder?>> editRootFolder(
      BuildContext context, List<ReadarrRootFolder> folders) async {
    bool _flag = false;
    ReadarrRootFolder? _folder;

    void _setValues(bool flag, ReadarrRootFolder value) {
      _flag = flag;
      _folder = value;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Root Folder',
      content: List.generate(
        folders.length,
        (index) => HarbrDialog.tile(
          text: folders[index].path!,
          subtitle: HarbrDialog.richText(
            children: [
              HarbrDialog.bolded(
                text: folders[index].freeSpace.asBytes(),
                fontSize: HarbrDialog.BUTTON_SIZE,
              ),
            ],
          ) as RichText?,
          icon: Icons.folder_rounded,
          iconColor: HarbrColours().byListIndex(index),
          onTap: () => _setValues(true, folders[index]),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );
    return Tuple2(_flag, _folder);
  }

  static Future<List<dynamic>> setDefaultPage(
    BuildContext context, {
    required List<String> titles,
    required List<IconData> icons,
  }) async {
    bool _flag = false;
    int _index = 0;

    void _setValues(bool flag, int index) {
      _flag = flag;
      _index = index;
      Navigator.of(context, rootNavigator: true).pop();
    }

    await HarbrDialog.dialog(
      context: context,
      title: 'Page',
      content: List.generate(
        titles.length,
        (index) => HarbrDialog.tile(
          text: titles[index],
          icon: icons[index],
          iconColor: HarbrColours().byListIndex(index),
          onTap: () => _setValues(true, index),
        ),
      ),
      contentPadding: HarbrDialog.listDialogContentPadding(),
    );

    return [_flag, _index];
  }
}
