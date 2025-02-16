import 'package:flutter/cupertino.dart';

import '../core/models/faculty.dart';
import '../core/models/student.dart';

class AppState extends ChangeNotifier {
  Faculty? _faculty;

  Faculty? get faculty => _faculty;
  Student? _student;

  Student? get student => _student;

  AppState({Student? student, Faculty? faculty})
      : _student = student,
        _faculty = faculty;

  bool _admin = false;

  bool get admin => _admin;

  void setUser({Faculty? faculty, Student? student}) {
    if (faculty != null) {
      _faculty = faculty;
    } else {
      _student = student;
    }
    notifyListeners();
  }
}