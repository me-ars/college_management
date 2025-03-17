class Fee {
  final String uid;
  final String studentId;
  final String sem;
  final String feeFor;
  final String paidDate;

  Fee({
    required this.uid,
    required this.studentId,
    required this.sem,
    required this.feeFor,
    required this.paidDate,
  });

  // Convert Faculty object to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'studentId': studentId,
      'sem': sem,
      'feeFor': feeFor,
      'paidDate': paidDate,
    };
  }

  factory Fee.fromMap(Map<String, dynamic> map) {
    return Fee(
      uid: map['uid'],
      studentId: map['studentId'],
      sem: map['sem'],
      feeFor: map['feeFor'],
      paidDate: map['paidDate'],
    );
  }
}
