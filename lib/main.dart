import 'package:college_management/core/models/faculty.dart';
import 'package:college_management/core/models/student.dart';
import 'package:college_management/core/services/auth_services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/mes_aimat.dart';
import 'init_dependencies.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies(); //init
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBqNLUFTita28e-pHv5HfjzwJRx_kLXBL8",
          appId: "1:385710333160:android:4aca25ed8c4e7559cf3d5d",
          messagingSenderId: "385710333160",
          projectId: "mes-aimat-27492"));

  Map<String, dynamic>? userData = await getUser();

  Faculty? faculty;//value
  Student? student;
  bool isAdmin = false;

  if (userData != null) {
    if (userData.containsKey("employeeId")) {
      faculty = Faculty.fromMap(userData); // Faculty user
    } else {
      student = Student.fromMap(userData); // Student user
    }
  } else {
    // If no user data, check if the user is logged in (admin case)
    String? userEmail = await locator<AuthService>().getCurrentUserEmail();
    if (userEmail != null) {
      isAdmin = true; // ✅ Set admin only if email exists but no data
    }
  }

  runApp(MesAimat(isAdmin: isAdmin, student: student, faculty: faculty));
}


Future<Map<String, dynamic>?> getUser() async {
  String? userEmail = await locator<AuthService>().getCurrentUserEmail();
  if (userEmail == null) return null;
  Map<String, dynamic>? user = await locator<AuthService>().getUserDetails(userEmail: userEmail);
  return user;
}
