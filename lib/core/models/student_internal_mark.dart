import 'package:college_management/core/models/internal_mark_model.dart';

class StudentInternalMark {
  final String studentId;
  final List<InternalMark> internalMarks;

  StudentInternalMark({
    required this.studentId,
    required this.internalMarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'internalMarks': internalMarks,
    };
  }

  factory StudentInternalMark.fromMap(Map<String, dynamic> map) {
    return StudentInternalMark(studentId: map['studentId'], internalMarks: map['internalMarks']);
  }
}
