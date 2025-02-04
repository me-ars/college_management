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
  final String loginPassword;

  Faculty({
    required this.loginPassword,
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
      'loginPassword': loginPassword
    };
  }
}
