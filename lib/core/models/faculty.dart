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
    };
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
    );
  }
}
