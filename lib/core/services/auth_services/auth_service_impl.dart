import 'package:college_management/core/models/faculty.dart';
import 'package:college_management/core/models/student.dart';
import 'package:college_management/core/services/firebase_service/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class AuthServiceImpl extends AuthService {
  final FirebaseService _firebaseService;

  AuthServiceImpl({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  @override
  Future<void> registerUser(
      {Student? student, Faculty? faculty, required String password}) async {
    try {
      final bool isStudent = student != null;
      final String email = isStudent ? student.email : faculty!.email;
      final documentId = isStudent ? student.studentId : faculty!.employeeId;
      print("Attempting to register user: $email");
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      Map<String, dynamic> userData = isStudent ? student.toMap() : faculty!.toMap();
      userData['uid'] = uid;

      await _firebaseService.setData(
        collectionName: "users",
        documentId: documentId,
        data: userData,
      );

      print("User registered successfully with UID: $uid");

    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      print("General error: $e");
      rethrow;
    }
  }

  @override
  Future loginUser({required String userId, required String password}) async {
    try {
      var users = await _firebaseService.getData(collectionName: "users");

      Map<String, dynamic>? filteredUser = users
          .cast<Map<String, dynamic>>()
          .firstWhere(
            (user) =>
                (user["employeeId"] == userId || user["studentId"] == userId),
            orElse: () => {},
          );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: filteredUser?["email"], password: password);
      return filteredUser;
    } catch (e) {
      rethrow;
    }
  }
}
