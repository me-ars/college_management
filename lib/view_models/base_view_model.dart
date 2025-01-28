import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../core/enums/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  bool _disposed = false;

  ViewState _viewState = ViewState.ideal;

  ViewState get viewState => _viewState;


  void dispose() {
    _disposed = true;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  setViewState({required ViewState state, String? loadingMessage}) {
    _viewState = state;

    notifyListeners();
  }
}
