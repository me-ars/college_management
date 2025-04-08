class Student {
  final String? sem;
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
    required this.sem,
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
      'sem': sem,
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

  // Create a Student object from a Map
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      sem: map['sem'],
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

  // CopyWith method to create a modified copy of the Student object
  Student copyWith({
    String? sem,
    String? firstName,
    String? lastName,
    String? studentId,
    String? course,
    String? joiningDate,
    String? batch,
    String? gender,
    String? dob,
    String? phone,
    String? email,
    String? guardianName,
    String? guardianPhone,
    String? address,
    String? sslc,
    String? plusTwo,
    String? bachelors,
  }) {
    return Student(
      sem: sem ?? this.sem,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      studentId: studentId ?? this.studentId,
      course: course ?? this.course,
      joiningDate: joiningDate ?? this.joiningDate,
      batch: batch ?? this.batch,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      address: address ?? this.address,
      sslc: sslc ?? this.sslc,
      plusTwo: plusTwo ?? this.plusTwo,
      bachelors: bachelors ?? this.bachelors,
    );
  }
}
