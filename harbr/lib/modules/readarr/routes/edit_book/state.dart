import 'package:flutter/material.dart';
import 'package:harbr/core.dart';
import 'package:harbr/modules/readarr.dart';

class ReadarrEditBookState extends ChangeNotifier {
  ReadarrBook? _book;
  ReadarrBook? get book => _book;
  set book(ReadarrBook? book) {
    _book = book;
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
    _book?.monitored = value;
    notifyListeners();
  }
}
