import 'package:college_management/core/error/base_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../core/enums/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  bool _disposed = false;

  ViewState _viewState = ViewState.ideal;

  ViewState get viewState => _viewState;
  BaseException? _exception;

  BaseException? get exception => _exception;
  Function? _retryMethod;

  Function? get retryMethod => _retryMethod;

  String? _snackBarMessage;

  String? get snackBarMessage => _snackBarMessage;

  void showSnackBar({required String snackBarMessage}) {
    _snackBarMessage = snackBarMessage;
    notifyListeners();
  }

  void dispose() {
    super.dispose();
    _disposed = true;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  showException({required dynamic error, required Function retryMethod}) {
    if (error! is BaseException) {
      _exception = error;

    } else {
      _exception = AppException(error: error.toString());
    }
    _retryMethod = retryMethod;
    notifyListeners();
  }

  setViewState({required ViewState state, String? loadingMessage}) {
    _viewState = state;
    notifyListeners();
  }
}
