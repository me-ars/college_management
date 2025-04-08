class AttendanceModel {
  final bool isPresent;
  final String uid;
  final String studentId;
  final String sem;
  final String course;
  final String attendanceDate;

  AttendanceModel({
    required this.isPresent,
    required this.uid,
    required this.studentId,
    required this.sem,
    required this.course,
    required this.attendanceDate,
  });

  // Convert AttendanceModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'isPresent': isPresent,
      'uid': uid,
      'studentId': studentId,
      'sem': sem,
      'course': course,
      'attendanceDate': attendanceDate,
    };
  }

  // Create AttendanceModel from a Map
  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      isPresent: map['isPresent'],
      uid: map['uid'],
      studentId: map['studentId'],
      sem: map['sem'],
      course: map['course'],
      attendanceDate: map['attendanceDate'],
    );
  }

  // CopyWith method to create a new instance with updated values
  AttendanceModel copyWith({
    bool? isPresent,
    String? uid,
    String? studentId,
    String? sem,
    String? course,
    String? attendanceDate,
  }) {
    return AttendanceModel(
      isPresent: isPresent ?? this.isPresent,
      uid: uid ?? this.uid,
      studentId: studentId ?? this.studentId,
      sem: sem ?? this.sem,
      course: course ?? this.course,
      attendanceDate: attendanceDate ?? this.attendanceDate,
    );
  }
}
