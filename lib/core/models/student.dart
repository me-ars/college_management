class Student {
  final String firstName;
  final String lastName;
  final String studentId;
  final String course;
  final String joiningDate;
  final String batch;
  final String gender;
  final String dob;
  final String phone;
  final String email;
  final String guardianName;
  final String guardianPhone;
  final String address;
  final String sslc;
  final String plusTwo;
  final String bachelors;

  Student({
    required this.firstName,
    required this.lastName,
    required this.studentId,
    required this.course,
    required this.joiningDate,
    required this.batch,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.email,
    required this.guardianName,
    required this.guardianPhone,
    required this.address,
    required this.sslc,
    required this.plusTwo,
    required this.bachelors,
  });

  // Convert Student object to a Map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'studentId': studentId,
      'course': course,
      'joiningDate': joiningDate,
      'batch': batch,
      'gender': gender,
      'dob': dob,
      'phone': phone,
      'email': email,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'address': address,
      'sslc': sslc,
      'plusTwo': plusTwo,
      'bachelors': bachelors,
    };
  }
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      firstName: map['firstName'],
      lastName: map['lastName'],
      studentId: map['studentId'],
      course: map['course'],
      joiningDate: map['joiningDate'],
      batch: map['batch'],
      gender: map['gender'],
      dob: map['dob'],
      phone: map['phone'],
      email: map['email'],
      guardianName: map['guardianName'],
      guardianPhone: map['guardianPhone'],
      address: map['address'],
      sslc: map['sslc'],
      plusTwo: map['plusTwo'],
      bachelors: map['bachelors'],
    );
  }
}
