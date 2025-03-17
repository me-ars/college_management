class AnnouncementModel {
  final String uid;
  final String date;
  final String message;
  final String course;

  AnnouncementModel({
    required this.uid,
    required this.message,
    required this.date,
    required this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'message': message,
      'date': date,
      'course': course,
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
        uid: map['uid'],
        date: map['date'],
        course: map['course'],
        message: map['message']);
  }
}
