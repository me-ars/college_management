import 'package:college_management/core/models/admin_model.dart';
import 'package:flutter/material.dart';
import '../core/models/faculty.dart';
import '../core/models/student.dart';

class AppState extends ChangeNotifier {
  Faculty? _faculty;

  Faculty? get faculty => _faculty;
  Student? _student;

  Student? get student => _student;

  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;
  AdminModel? _admin;

  AdminModel? get admin => _admin;
  AppState(
      {Student? student,
      Faculty? faculty,
      required bool isAdmin,
       AdminModel? admin})
      : _student = student,
        _faculty = faculty,
        _isAdmin = isAdmin,
        _admin = admin;

  void setUser({Faculty? faculty, Student? student,AdminModel? admin}) {
    if(admin!=null){
      _isAdmin=true;
      _admin=admin;
    }
    if (faculty != null) {
      _faculty = faculty;
    } else if(student!=null) {
      _student = student;
    }
    notifyListeners();
  }

  void logoutUser({Faculty? faculty, Student? student}) {
    _faculty = null;
    _student = null;
    _admin=null;
    _isAdmin = false;
    notifyListeners();
  }
}
