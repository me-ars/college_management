class AdminModel {
  final String adminId;
  final String email;

  AdminModel({
    required this.adminId,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'adminId': adminId,
      'email': email,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      adminId: map['adminId'],
      email: map['email'],
    );
  }
}
