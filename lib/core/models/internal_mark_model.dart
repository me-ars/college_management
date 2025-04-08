class InternalMark {
  final String uid;
  final String studentId;
  final String sem;
  final String subject;
  final String mark;
  final String course;

  InternalMark({
    required this.uid,
    required this.studentId,
    required this.sem,
    required this.subject,
    required this.mark,
    required this.course
  });

  // Convert Faculty object to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'studentId': studentId,
      'sem': sem,
      'subject': subject,
      'mark': mark,
      'course':course
    };
  }

  factory InternalMark.fromMap(Map<String, dynamic> map) {
    return InternalMark(
      course: map['course'],
      uid: map['uid'],
      studentId: map['studentId'],
      sem: map['sem'],
      subject: map['subject'],
      mark: map['mark'],
    );
  }
}
