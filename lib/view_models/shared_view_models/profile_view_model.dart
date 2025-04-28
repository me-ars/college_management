import 'package:college_management/app/app_state.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../../core/services/auth_services/auth_service.dart';

class ProfileViewModel extends BaseViewModel{
  final AuthService _authService;

  ProfileViewModel({required AuthService authService})
      : _authService = authService;

  Future<void> logoutUser({
    required AppState appState,
  }) async {
    try {
      setViewState(state: ViewState.busy);
      await _authService.logoutUser();
      appState.logoutUser();
      setViewState(state: ViewState.ideal);
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            logoutUser(appState: appState);
          });
    }
  }
}