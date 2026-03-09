import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrEditAuthorState extends ChangeNotifier {
  ReadarrAuthor? _author;
  ReadarrAuthor? get author => _author;
  set author(ReadarrAuthor? author) {
    _author = author;
    notifyListeners();
  }

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

  void setMonitored(bool value) {
    _author?.monitored = value;
    notifyListeners();
  }

  ReadarrQualityProfile? _qualityProfile;
  ReadarrQualityProfile? get qualityProfile => _qualityProfile;
  set qualityProfile(ReadarrQualityProfile? qualityProfile) {
    _qualityProfile = qualityProfile;
    notifyListeners();
  }

  ReadarrMetadataProfile? _metadataProfile;
  ReadarrMetadataProfile? get metadataProfile => _metadataProfile;
  set metadataProfile(ReadarrMetadataProfile? metadataProfile) {
    _metadataProfile = metadataProfile;
    notifyListeners();
  }

  List<ReadarrTag> _tags = [];
  List<ReadarrTag> get tags => _tags;
  set tags(List<ReadarrTag> tags) {
    _tags = tags;
    notifyListeners();
  }

  void initializeQualityProfile(List<ReadarrQualityProfile> profiles) {
    if (_qualityProfile == null && author?.qualityProfileId != null) {
      for (var p in profiles) {
        if (p.id == author!.qualityProfileId) {
          _qualityProfile = p;
          break;
        }
      }
    }
  }

  void initializeMetadataProfile(List<ReadarrMetadataProfile> profiles) {
    if (_metadataProfile == null && author?.metadataProfileId != null) {
      for (var p in profiles) {
        if (p.id == author!.metadataProfileId) {
          _metadataProfile = p;
          break;
        }
      }
    }
  }

  void initializeTags(List<ReadarrTag> allTags) {
    if (_tags.isEmpty && author?.tags != null) {
      _tags = allTags.where((t) => author!.tags!.contains(t.id)).toList();
    }
  }
}
