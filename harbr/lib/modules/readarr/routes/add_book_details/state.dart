import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrAddBookDetailsState extends ChangeNotifier {
  final ReadarrBook book;

  ReadarrAddBookDetailsState({required this.book});

  HarbrLoadingState _state = HarbrLoadingState.INACTIVE;
  HarbrLoadingState get state => _state;
  set state(HarbrLoadingState state) {
    _state = state;
    notifyListeners();
  }

  bool _canExecuteAction = false;
  bool get canExecuteAction => _canExecuteAction;
  set canExecuteAction(bool canExecuteAction) {
    _canExecuteAction = canExecuteAction;
    notifyListeners();
  }

  bool _monitored = ReadarrDatabase.ADD_BOOK_DEFAULT_MONITORED.read();
  bool get monitored => _monitored;
  set monitored(bool monitored) {
    _monitored = monitored;
    notifyListeners();
  }

  void initializeMonitored() {
    if (!_initializedMonitored) {
      _monitored = ReadarrDatabase.ADD_BOOK_DEFAULT_MONITORED.read();
      _initializedMonitored = true;
    }
  }

  bool _initializedMonitored = false;

  ReadarrQualityProfile? _qualityProfile;
  ReadarrQualityProfile? get qualityProfile => _qualityProfile;
  set qualityProfile(ReadarrQualityProfile? qualityProfile) {
    _qualityProfile = qualityProfile;
    notifyListeners();
  }

  void initializeQualityProfile(List<ReadarrQualityProfile> profiles) {
    if (_qualityProfile == null && profiles.isNotEmpty) {
      int? defaultId = ReadarrDatabase.ADD_BOOK_DEFAULT_QUALITY_PROFILE.read();
      _qualityProfile = profiles.firstWhere(
        (p) => p.id == defaultId,
        orElse: () => profiles.first,
      );
    }
  }

  ReadarrMetadataProfile? _metadataProfile;
  ReadarrMetadataProfile? get metadataProfile => _metadataProfile;
  set metadataProfile(ReadarrMetadataProfile? metadataProfile) {
    _metadataProfile = metadataProfile;
    notifyListeners();
  }

  void initializeMetadataProfile(List<ReadarrMetadataProfile> profiles) {
    if (_metadataProfile == null && profiles.isNotEmpty) {
      int? defaultId =
          ReadarrDatabase.ADD_BOOK_DEFAULT_METADATA_PROFILE.read();
      _metadataProfile = profiles.firstWhere(
        (p) => p.id == defaultId,
        orElse: () => profiles.first,
      );
    }
  }

  ReadarrRootFolder? _rootFolder;
  ReadarrRootFolder? get rootFolder => _rootFolder;
  set rootFolder(ReadarrRootFolder? rootFolder) {
    _rootFolder = rootFolder;
    notifyListeners();
  }

  void initializeRootFolder(List<ReadarrRootFolder> folders) {
    if (_rootFolder == null && folders.isNotEmpty) {
      int? defaultId = ReadarrDatabase.ADD_BOOK_DEFAULT_ROOT_FOLDER.read();
      _rootFolder = folders.firstWhere(
        (f) => f.id == defaultId,
        orElse: () => folders.first,
      );
    }
  }

  List<ReadarrTag> _tags = [];
  List<ReadarrTag> get tags => _tags;
  set tags(List<ReadarrTag> tags) {
    _tags = tags;
    notifyListeners();
  }

  void initializeTags(List<ReadarrTag> allTags) {
    // Initialize from defaults - usually empty
  }
}
