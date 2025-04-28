import 'package:college_management/app/app_state.dart';
import 'package:college_management/core/enums/view_state.dart';
import 'package:college_management/core/models/admin_model.dart';
import 'package:college_management/core/services/auth_services/auth_service.dart';
import 'package:college_management/core/services/database_service/database_service.dart';
import 'package:college_management/view_models/base_view_model.dart';

import '../../core/models/faculty.dart';
import '../../core/models/student.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService _authService;

  LoginViewModel(
      {required AuthService authService,
      required DatabaseService databaseService})
      : _authService = authService;

  onRefresh() {}

  onModelReady() {}

  Future<void> login(
      {required AppState appState,
      required String userId,
      required String password}) async {
    setViewState(state: ViewState.busy);
    try {
      Map<String, dynamic>? filteredUser =
          await _authService.loginUser(userId: userId, password: password);

      if (filteredUser!.isNotEmpty) {
        dynamic userObject;

        if (filteredUser.containsKey("employeeId")) {
          // It's a Faculty
          Faculty faculty = Faculty.fromMap(filteredUser);
          userObject = faculty;
        } else if (filteredUser.containsKey("studentId")) {
          // It's a Student
          Student student = Student.fromMap(filteredUser);
          userObject = student;
        } else if(filteredUser.containsKey("adminId")){
          AdminModel admin=AdminModel.fromMap(filteredUser);
          userObject=admin;
        }

        // Optionally store the user in appState
        if (userObject is Faculty) {
          // await _databaseService.insertFaculty(userObject);

          appState.setUser(faculty: userObject);
        } else if (userObject is Student) {
          // await _databaseService.insertStudent(userObject);
          appState.setUser(student: userObject);
        }
        else if(userObject is AdminModel){
          appState.setUser(admin: userObject);
        }
      }
    } catch (e) {
      showException(
          error: e,
          retryMethod: () {
            login(appState: appState, userId: userId, password: password);
          });
    } finally {
      setViewState(state: ViewState.ideal);
    }
  }
}
//{lastName: t, address: f, gender: Male, subject: c, coName: h, employeeId: t, joiningDate: y, coPhoneNumber: b, firstName: g, uid: vkAP4RaKawc0vW1PpqZI3Gf58813, phone: g, dob: 2025-02-07, loginPassword: 123456, course: , email: anandurs02@gmail.com}