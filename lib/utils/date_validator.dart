class DateValidator {
  static bool isValidDate(String date) {
    if (date.isEmpty) return false;
    DateTime selectedDate = DateTime.parse(date);
    DateTime today = DateTime.now();
    return selectedDate.isAfter(today);
  }
}
