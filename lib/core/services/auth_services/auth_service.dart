import 'package:college_management/core/models/faculty.dart';
import '../../models/student.dart';

abstract class AuthService {
  Future<void> registerUser(
      {Student? student, Faculty? faculty, required String password});

  Future loginUser({required String userId, required String password});

  Future<void> logoutUser();

  Future<String?> getCurrentUserEmail();

  Future<Map<String,dynamic>?> getUserDetails({required String userEmail});
}