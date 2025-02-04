import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/faculty.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../../core/models/student.dart';
import '../../core/services/auth_services/auth_service.dart';

class SignupViewModel extends BaseViewModel {
  final AuthService _firebaseService;

  SignupViewModel({required AuthService firebaseService})
      : _firebaseService = firebaseService;

  onRefresh() {}

  onModelReady() {}

  Future<void> signupUser(
      {required bool isStudent, Faculty? faculty, Student? student}) async {
    setViewState(state: ViewState.busy);
    try {

      await _firebaseService.registerUser(faculty: faculty,student: student);
      setViewState(state: ViewState.ideal);

    } catch (e) {
      print(e);
    }
  }
}
