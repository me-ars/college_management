import 'package:college_management/utils/string_utils.dart';

class ValidationUtils {
  static bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r'^\+?[0-9]{10,15}$');
    return regex.hasMatch(phoneNumber);
  }

  static bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }


  static bool isValidName(String name) {
    // Define a regex pattern for name validation (only alphabets and spaces, min 2 chars)
    final RegExp regex = RegExp(r'^[a-zA-Z ]{2,}\$');
    return regex.hasMatch(name);
  }

  static bool isAllFieldsEmpty({required List<String?> fieldValues}) {
    return fieldValues.every((value) => StringUtils.isEmptyString(value));
  }
}