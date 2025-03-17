abstract class BaseException implements Exception {
  final String? message;
  final String error;
  final StackTrace? stackTrace;

  BaseException({this.message, required this.error, this.stackTrace});
}

class FirebaseException implements BaseException {
  @override
  final String? message;
  @override
  final String error;
  @override
  final StackTrace? stackTrace;

  FirebaseException(
      {this.message = "Something went wrong",
      required this.error,
      this.stackTrace});
}

class AppException implements BaseException {
  @override
  final String? message;
  @override
  final String error;
  @override
  final StackTrace? stackTrace;

  AppException(
      {this.message = "Something went wrong",
        required this.error,
        this.stackTrace});
}