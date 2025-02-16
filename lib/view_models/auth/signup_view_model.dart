import 'package:college_management/app/app_state.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/faculty.dart';
import 'package:college_management/view_models/base_view_model.dart';
import '../../core/models/student.dart';
import '../../core/services/auth_services/auth_service.dart';
import '../../core/services/database_service/database_service.dart';

class SignupViewModel extends BaseViewModel {
  final AuthService _authService;
  final DatabaseService _databaseService;

  SignupViewModel(
      {required AuthService firebaseService,
      required DatabaseService databaseService})
      : _authService = firebaseService,
        _databaseService = databaseService;

  onRefresh() {}

  onModelReady() {}

  Future<void> signupUser({required bool isStudent,
    Faculty? faculty,
    Student? student,
    required String password,
    required AppState appState}) async {
    setViewState(state: ViewState.busy);
    try {
      await _authService.registerUser(faculty: faculty,student: student,password: password);
      appState.setUser(student: student, faculty: faculty);
      if (isStudent) {
        await _databaseService.insertStudent(student!);
      } else {
        await _databaseService.insertFaculty(faculty!);
      }
      setViewState(state: ViewState.ideal);
    } catch (e) {
      print(e);
    }
  }
}
