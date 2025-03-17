class Faculty {
  final String firstName;
  final String lastName;
  final String employeeId;
  final String course;
  final String joiningDate;
  final String subject;
  final String gender;
  final String dob;
  final String phone;
  final String email;
  final String coName;
  final String coPhoneNumber;
  final String address;
  bool? isHOD;

  Faculty({
    required this.firstName,
    required this.lastName,
    required this.employeeId,
    required this.course,
    required this.joiningDate,
    required this.subject,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.email,
    required this.coName,
    required this.coPhoneNumber,
    required this.address,
    this.isHOD,
  });

  // Convert Faculty object to a Map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'employeeId': employeeId,
      'course': course,
      'joiningDate': joiningDate,
      'subject': subject,
      'gender': gender,
      'dob': dob,
      'phone': phone,
      'email': email,
      'coName': coName,
      'coPhoneNumber': coPhoneNumber,
      'address': address,
      'isHOD':isHOD
    };
  }
  Faculty copyWith({
    String? firstName,
    String? lastName,
    String? employeeId,
    String? course,
    String? joiningDate,
    String? subject,
    String? gender,
    String? dob,
    String? phone,
    String? email,
    String? coName,
    String? coPhoneNumber,
    String? address,
    bool? isHOD,
  }) {
    return Faculty(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      employeeId: employeeId ?? this.employeeId,
      course: course ?? this.course,
      joiningDate: joiningDate ?? this.joiningDate,
      subject: subject ?? this.subject,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      coName: coName ?? this.coName,
      coPhoneNumber: coPhoneNumber ?? this.coPhoneNumber,
      address: address ?? this.address,
      isHOD: isHOD ?? this.isHOD,
    );
  }

  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      firstName: map['firstName'],
      lastName: map['lastName'],
      employeeId: map['employeeId'],
      course: map['course'],
      joiningDate: map['joiningDate'],
      subject: map['subject'],
      gender: map['gender'],
      dob: map['dob'],
      phone: map['phone'],
      email: map['email'],
      coName: map['coName'],
      coPhoneNumber: map['coPhoneNumber'],
      address: map['address'],
      isHOD: map['isHOD']
    );
  }
}
