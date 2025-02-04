import 'package:college_management/core/models/faculty.dart';

import '../../models/student.dart';

abstract class AuthService {
  Future registerUser({Student? student,Faculty? faculty});
}