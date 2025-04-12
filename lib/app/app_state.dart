import 'package:flutter/material.dart';
import '../core/models/faculty.dart';
import '../core/models/student.dart';
import '../core/services/firebase_service/firebase_service.dart';

class AppState extends ChangeNotifier {
  Faculty? _faculty;

  Faculty? get faculty => _faculty;
  Student? _student;

  Student? get student => _student;
  final FirebaseService _firebaseService;

  bool _admin = false;

  bool get admin => _admin;

  AppState(
      {Student? student,
      Faculty? faculty,
      required bool isAdmin,
      required FirebaseService firebaseService})
      : _student = student,
        _faculty = faculty,
        _firebaseService = firebaseService,
        _admin = isAdmin;

  void setUser({Faculty? faculty, Student? student}) {
    if (faculty != null) {
      _faculty = faculty;
    } else {
      _student = student;
    }

    notifyListeners();
  }

  void logoutUser({Faculty? faculty, Student? student}) {
    if (faculty != null) {
      _faculty = null;
    } else {
      _student = null;
    }
    _admin = false;
notifyListeners();
    notifyListeners();
  }
}
