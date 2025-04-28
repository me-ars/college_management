import 'package:college_management/core/constants/firebase_collection_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../models/faculty.dart';
import '../../models/student.dart';
import '../firebase_service/firebase_service.dart';
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

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      Map<String, dynamic> userData =
          isStudent ? student.toMap() : faculty!.toMap();
      userData['uid'] = uid;

      await _firebaseService.setData(
        collectionName: "users",
        documentId: documentId,
        data: userData,
      );

      if (kDebugMode) {
        print("User registered successfully with UID: $uid");
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> loginUser({
    required String userId,
    required String password,
  }) async {
    try {
      // Fetch user by document ID (assuming each user has a document named after userId)
      final userData = await _firebaseService.getData(
        collectionName: "users",
        documentId: userId,
      );

      if (userData == null || userData.isEmpty) {
        return null;
      }

      // Try to sign in with the retrieved email and provided password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userData[0]["email"],
        password: password,
      );

      return userData[0];
    } catch (e) {
      rethrow;
    }
  }


  /// Returns the current logged-in user's email
  @override
  Future<String?> getCurrentUserEmail() async{
    User? user =  FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  @override
  Future<Map<String,dynamic>?> getUserDetails({required String userEmail}) async {
    var x=  await _firebaseService.getData(
        collectionName: FirebaseCollectionConstants.users,
        filterField: 'email',
        filterValue: userEmail);
    Map<String,dynamic> userdata =
    x[0];
    if (userdata.isNotEmpty) {
      return userdata;
    } else {
      return null;
    }
  }

  /// Logs out the current user
  @override
  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (kDebugMode) {
        print("User logged out successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error logging out: $e");
      }
      rethrow;
    }
  }
}
