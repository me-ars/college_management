class ContactUsModel {
  final String email;
  final String phone;

  ContactUsModel({
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
    };
  }

  factory ContactUsModel.fromMap(Map<String, dynamic> map) {
    return ContactUsModel(email: map['email'], phone: map['phone']);
  }
}
