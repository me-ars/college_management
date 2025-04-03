class LeaveRequest {
  final String studentFirstName;
  final String studentLastName;
  final String uid;
  final String studentId;
  final String course;
  final String sem;
  final String reason;
  final String fromDate;
  final String toDate;
  final bool verified;
  final String appliedDate;

  LeaveRequest({
    required this.studentFirstName,
    required this.studentLastName,
    required this.uid,
    required this.studentId,
    required this.course,
    required this.sem,
    required this.fromDate,
    required this.toDate,
    required this.appliedDate,
    required this.reason,
    required this.verified,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'studentFirstName': studentFirstName,
      'studentLastName': studentLastName,
      'studentId': studentId,
      'course': course,
      'sem': sem,
      'fromDate': fromDate,
      'toDate': toDate,
      'appliedDate': appliedDate,
      'reason': reason,
      'verified': verified,
    };
  }

  factory LeaveRequest.fromMap(Map<String, dynamic> map) {
    return LeaveRequest(
      uid: map['uid'],
      studentFirstName: map['studentFirstName'],
      studentLastName: map['studentLastName'],
      course: map['course'],
      sem: map['sem'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      appliedDate: map['appliedDate'],
      reason: map['reason'],
      studentId: map['studentId'],
      verified: map['verified'],
    );
  }

  LeaveRequest copyWith({
    String? uid,
    String? studentId,
    String? course,
    String? sem,
    String? reason,
    String? fromDate,
    String? toDate,
    String? appliedDate,
    bool? verified,
    String? studentLastName,
    String? studentFirstName,
  }) {
    return LeaveRequest(
      studentFirstName: studentFirstName?? this.studentFirstName,
      studentLastName: studentLastName ?? this.studentLastName,
      uid: uid ?? this.uid,
      studentId: studentId ?? this.studentId,
      course: course ?? this.course,
      sem: sem ?? this.sem,
      reason: reason ?? this.reason,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      appliedDate: appliedDate ?? this.appliedDate,
      verified: verified ?? this.verified,
    );
  }
}
